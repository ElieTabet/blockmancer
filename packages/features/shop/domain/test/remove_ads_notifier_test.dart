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

const _product = 'blockmancer.remove_ads';

PurchaseUpdate _update(PurchaseOutcome outcome, {String? code}) =>
    (code: code, outcome: outcome, productId: _product);

void main() {
  late _Analytics analytics;
  late _MemoryEntitlement entitlement;
  late StreamController<PurchaseUpdate> store;
  late List<String> calls;

  ProviderContainer launch({
    void Function()? onRestore,
    bool storeReachable = true,
  }) {
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
        recheckPurchases: (ref) => () async {
          calls.add('recheck');
          onRestore?.call();
        },
        removeAdsProductId: (ref) => _product,
        restorePurchases: (ref) => () async {
          calls.add('restore');

          if (!storeReachable) return false;

          onRestore?.call();

          return true;
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
    expect(calls, ['buy blockmancer.remove_ads']);
    expect(shop.read(removeAdsProvider).value, isTrue);
    expect(entitlement.removed, isTrue);
    expect(analytics.logged, const [
      AnalyticsEvent.purchaseStarted(product: _product),
      AnalyticsEvent.purchaseCompleted(product: _product),
    ]);
  });

  test('Given the store\'s sheet opening, When Remove ads is tapped again, '
      'Then no second sheet is asked for', () async {
    // Given
    final shop = launch();
    await shop.read(removeAdsProvider.future);
    final notifier = shop.read(removeAdsProvider.notifier);

    // When
    final taps = await Future.wait([notifier.buy(), notifier.buy()]);
    await notifier.buy();

    // Then
    expect(calls, ['buy blockmancer.remove_ads']);
    expect(taps, [isTrue, isTrue]);
  });

  test('Given a buy the store has reported on, When Remove ads is tapped '
      'again, Then the sheet opens again', () async {
    // Given
    final shop = launch();
    await shop.read(removeAdsProvider.future);
    final notifier = shop.read(removeAdsProvider.notifier);
    await notifier.buy();
    store.add(_update(.canceled));
    await settle();

    // When
    await notifier.buy();

    // Then
    expect(calls, ['buy blockmancer.remove_ads', 'buy blockmancer.remove_ads']);
  });

  test('Given a restore under way, When Restore purchases is tapped again, '
      'Then the store is asked once, and only the first tap answers', () async {
    // Given
    final shop = launch(onRestore: () => store.add(_update(.restored)));
    await shop.read(removeAdsProvider.future);
    final notifier = shop.read(removeAdsProvider.notifier);

    // When
    final taps = await Future.wait([notifier.restore(), notifier.restore()]);

    // Then
    expect(calls, ['restore']);
    expect(taps, [RestoreOutcome.restored, isNull]);

    expect(await notifier.restore(), RestoreOutcome.restored);
    expect(calls, ['restore', 'restore']);
  });

  test('Given the store reporting several restored purchases, When the '
      'player restores, Then it is answered once, without error', () async {
    // Given
    final shop = launch(
      onRestore: () => store
        ..add(_update(.restored))
        ..add(_update(.restored)),
    );
    await shop.read(removeAdsProvider.future);

    // When / Then
    expect(
      await shop.read(removeAdsProvider.notifier).restore(),
      RestoreOutcome.restored,
    );
    await settle();
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
      const AnalyticsEvent.purchaseFailed(code: 'canceled', product: _product),
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
    expect(calls, ['recheck']);
    expect(shop.read(removeAdsProvider).value, isTrue);
    expect(entitlement.removed, isTrue);
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
    expect(restored, RestoreOutcome.restored);
    expect(shop.read(removeAdsProvider).value, isTrue);
    expect(entitlement.removed, isTrue);
    expect(analytics.logged, const [
      AnalyticsEvent.purchaseRestored(product: _product),
    ]);
  });

  test('Given nothing bought on this store account, When the player '
      'restores, Then nothing is found and ads stay on', () async {
    // Given
    final shop = launch();
    await shop.read(removeAdsProvider.future);

    // When
    final outcome = await shop.read(removeAdsProvider.notifier).restore();

    // Then
    expect(outcome, RestoreOutcome.nothingFound);
    expect(shop.read(removeAdsProvider).value, isFalse);
    expect(entitlement.removed, isFalse);
  });

  test('Given the store out of reach, When the player restores, Then they '
      'are told so, and ads stay on', () async {
    // Given
    final shop = launch(storeReachable: false);
    await shop.read(removeAdsProvider.future);

    // When
    final outcome = await shop.read(removeAdsProvider.notifier).restore();

    // Then
    expect(outcome, RestoreOutcome.storeUnreachable);
    expect(shop.read(removeAdsProvider).value, isFalse);
  });

  test('Given Remove ads kept on the device, When the app launches offline, '
      'Then ads stay removed', () async {
    // Given
    entitlement.removed = true;

    // When / Then
    expect(await launch().read(removeAdsProvider.future), isTrue);
  });
}
