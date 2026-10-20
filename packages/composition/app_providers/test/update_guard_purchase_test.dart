import 'dart:async';

import 'package:app_providers/app_providers.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:app_providers/src/release_ids.dart';
import 'package:app_router/app_router.dart';
import 'package:app_update_domain/app_update_domain.dart' as app_update;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases/purchases.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_domain/shop_domain.dart' as shop;

import 'fake_remote_values.dart';

/// A store whose sheet opens, and whose purchases arrive when the test says.
final class _FakeStore implements Purchases {
  final StreamController<PurchaseUpdate> reported = .broadcast();

  @override
  Stream<PurchaseUpdate> get updates => reported.stream;

  @override
  Future<bool> buy(String productId) async => true;

  @override
  Future<String?> priceOf(String productId) async => null;

  @override
  Future<void> recheckQuietly() async {}

  @override
  Future<bool> restore() async => true;
}

// The whole composition but the screens: what is under test is that the
// update screen going up leaves the purchase the player was making to land.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a purchase in flight when the update screen goes up is still '
      'completed, and Remove ads kept', () async {
    // Given: version 1.0.0, the store's sheet open on Remove ads
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Blockmancer',
      buildNumber: '1',
      buildSignature: '',
      packageName: 'com.elietabet.blockmancer',
      version: '1.0.0',
    );
    final store = _FakeStore();
    final values = FakeRemoteValues();
    final container = ProviderContainer(
      overrides: [
        ...appOverrides(
          collectsTelemetry: false,
          router: AppRouter(),
          testTools: false,
        ),
        purchasesProvider.overrideWithValue(store),
        remoteValuesProvider.overrideWithValue(values),
      ],
    );
    addTearDown(container.dispose);
    fetchRemoteConfig(container);
    startUpdateGuard(container);
    await startPurchases(container);
    expect(await container.read(shop.removeAdsProvider.notifier).buy(), isTrue);

    // When: a minimum above it is published, then the store completes the
    // purchase
    values.publish('min_version_android', '1.0.1');
    await pumpEventQueue();
    expect(
      await container.read(app_update.updateRequiredProvider.future),
      isTrue,
    );
    store.reported.add((
      code: null,
      outcome: PurchaseOutcome.purchased,
      productId: iapRemoveAds,
    ));
    await pumpEventQueue();

    // Then
    expect(container.read(shop.removeAdsProvider).value, isTrue);
    expect(
      (await SharedPreferences.getInstance()).getBool('purchases.removeAds'),
      isTrue,
    );
  });
}
