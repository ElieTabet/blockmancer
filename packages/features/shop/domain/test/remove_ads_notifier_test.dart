import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shop_domain/shop_domain.dart';

final class _MemoryEntitlement implements EntitlementStore {
  var removed = false;

  @override
  Future<bool> adsRemoved() async => removed;

  @override
  Future<void> keepAdsRemoved() async => removed = true;
}

final class _Analytics implements AnalyticsSink {
  final logged = <AnalyticsEvent>[];

  @override
  void log(AnalyticsEvent event) => logged.add(event);
}

PurchaseUpdate _update(PurchaseOutcome outcome, {String? code}) =>
    (code: code, outcome: outcome, productId: removeAdsProductId);

void main() {
  late _Analytics analytics;
  late _MemoryEntitlement entitlement;
  late StreamController<PurchaseUpdate> store;
  late List<String> calls;

  ProviderContainer launch({void Function()? onRestore}) {
    final container = ProviderContainer(
      overrides: bindProviders(
        analyticsSink: (ref) => analytics,
        buyProduct: (ref) => (productId) async {
          calls.add('buy $productId');

          return true;
        },
        entitlementStore: (ref) => entitlement,
        priceOf: (ref) =>
            (productId) async => r'$3.99',
        purchaseUpdates: (ref) =>
            () => store.stream,
        restorePurchases: (ref) => () async {
          calls.add('restore');
          onRestore?.call();
        },
      ),
    );
    addTearDown(container.dispose);
    container.listen(removeAdsProvider, (_, _) {});

    return container;
  }

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    analytics = _Analytics();
    entitlement = _MemoryEntitlement();
    store = StreamController.broadcast();
    calls = [];
  });

  tearDown(() => store.close());

  test('Given a player who buys Remove ads, When the store confirms it, Then '
      'ads are removed for good and the purchase is counted', () async {
    // Given
    final shop = launch();
    await shop.read(removeAdsProvider.future);

    // When
    await shop.read(removeAdsProvider.notifier).buy();
    store.add(_update(.purchased));
    await settle();

    // Then
    expect(calls, ['buy remove_ads']);
    expect(shop.read(removeAdsProvider).value, isTrue);
    expect(entitlement.removed, isTrue);
    expect(analytics.logged, const [
      AnalyticsEvent.purchaseStarted(product: removeAdsProductId),
      AnalyticsEvent.purchaseCompleted(product: removeAdsProductId),
    ]);
  });

  test('Given a player who backs out of the store, Then ads stay on and the '
      'purchase counts as failed, canceled', () async {
    // Given
    final shop = launch();
    await shop.read(removeAdsProvider.future);

    // When
    await shop.read(removeAdsProvider.notifier).buy();
    store.add(_update(.canceled));
    await settle();

    // Then
    expect(shop.read(removeAdsProvider).value, isFalse);
    expect(
      analytics.logged.last,
      const AnalyticsEvent.purchaseFailed(
        code: 'canceled',
        product: removeAdsProductId,
      ),
    );
  });

  test('Given a reinstall, When the launch re-checks with the store, Then '
      'Remove ads comes back, quietly', () async {
    // Given
    final shop = launch(onRestore: () => store.add(_update(.restored)));
    await shop.read(removeAdsProvider.future);

    // When
    await shop.read(removeAdsProvider.notifier).recheck();
    await settle();

    // Then
    expect(shop.read(removeAdsProvider).value, isTrue);
    expect(analytics.logged, isEmpty);
  });

  test('Given a player who restores from Settings, Then Remove ads comes back '
      'and the restore is counted', () async {
    // Given
    final shop = launch(onRestore: () => store.add(_update(.restored)));
    await shop.read(removeAdsProvider.future);

    // When
    final restored = await shop.read(removeAdsProvider.notifier).restore();

    // Then
    expect(restored, isTrue);
    expect(analytics.logged, const [
      AnalyticsEvent.purchaseRestored(product: removeAdsProductId),
    ]);
  });

  test('Given Remove ads kept on the device, When the app launches offline, '
      'Then ads stay removed', () async {
    // Given
    entitlement.removed = true;

    // When / Then
    expect(await launch().read(removeAdsProvider.future), isTrue);
  });
}
