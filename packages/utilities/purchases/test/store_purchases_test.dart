import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases/purchases.dart';
import 'package:shared_domain/shared_domain.dart';

class _MockStore extends Mock implements InAppPurchase {}

class _FakePurchaseDetails extends Fake implements PurchaseDetails {}

class _FakePurchaseParam extends Fake implements PurchaseParam {}

PurchaseDetails _purchase(
  PurchaseStatus status, {
  bool pendingComplete = false,
}) => PurchaseDetails(
  productID: 'remove_ads',
  status: status,
  transactionDate: null,
  verificationData: PurchaseVerificationData(
    localVerificationData: '',
    serverVerificationData: '',
    source: 'test',
  ),
)..pendingCompletePurchase = pendingComplete;

void main() {
  late _MockStore store;
  late StreamController<List<PurchaseDetails>> stream;

  setUpAll(() {
    registerFallbackValue(_FakePurchaseDetails());
    registerFallbackValue(_FakePurchaseParam());
  });

  setUp(() {
    store = _MockStore();
    stream = StreamController.broadcast();
    when(() => store.purchaseStream).thenAnswer((_) => stream.stream);
    when(() => store.completePurchase(any())).thenAnswer((_) async {});
    when(() => store.isAvailable()).thenAnswer((_) async => true);
  });

  tearDown(() => stream.close());

  test('Given a purchase the store hands over, When it arrives, Then it is '
      'reported and acknowledged', () async {
    // Given
    final purchases = StorePurchases(store: store);
    final updates = <PurchaseUpdate>[];
    purchases.updates.listen(updates.add);

    // When
    stream.add([_purchase(.purchased, pendingComplete: true)]);
    await Future<void>.delayed(Duration.zero);

    // Then
    expect(updates, [
      (code: null, outcome: PurchaseOutcome.purchased, productId: 'remove_ads'),
    ]);
    verify(() => store.completePurchase(any())).called(1);
  });

  test('Given a purchase the last launch left unfinished, When the store hands '
      'it over at launch with nothing listening yet, Then it is still '
      'acknowledged', () async {
    // Given: the stream opened at launch, no screen listening
    final purchases = StorePurchases(store: store);
    purchases.updates;

    // When
    stream.add([_purchase(.purchased, pendingComplete: true)]);
    await Future<void>.delayed(Duration.zero);

    // Then
    verify(() => store.completePurchase(any())).called(1);
  });

  test('Given each status, Then it maps onto its outcome', () async {
    // Given
    final purchases = StorePurchases(store: store);
    final outcomes = <PurchaseOutcome>[];
    purchases.updates.listen((update) => outcomes.add(update.outcome));

    // When
    stream.add([
      _purchase(.canceled),
      _purchase(.error),
      _purchase(.pending),
      _purchase(.restored),
    ]);
    await Future<void>.delayed(Duration.zero);

    // Then
    expect(outcomes, [
      PurchaseOutcome.canceled,
      PurchaseOutcome.failed,
      PurchaseOutcome.pending,
      PurchaseOutcome.restored,
    ]);
  });

  test('Given a product the store doesn\'t know, When it is bought, Then '
      'nothing opens and no price shows', () async {
    // Given
    when(() => store.queryProductDetails(any())).thenAnswer(
      (_) async => ProductDetailsResponse(
        notFoundIDs: const ['remove_ads'],
        productDetails: const [],
      ),
    );
    final purchases = StorePurchases(store: store);

    // When / Then
    expect(await purchases.buy('remove_ads'), isFalse);
    expect(await purchases.priceOf('remove_ads'), isNull);
    verifyNever(
      () => store.buyNonConsumable(purchaseParam: any(named: 'purchaseParam')),
    );
  });
}
