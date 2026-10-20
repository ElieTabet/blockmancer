import 'dart:async';

import 'package:app_providers/app_providers.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:app_providers/src/release_ids.dart';
import 'package:app_router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_domain/src/providers_di.br.dart' as game_di;
import 'package:purchases/purchases.dart';
import 'package:settings_presentation/src/providers_di.br.dart'
    as settings_ui_di;
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A store that owns Remove ads for this player, and reports it on a restore.
final class _FakeStore implements Purchases {
  var rechecks = 0;
  final StreamController<PurchaseUpdate> reported = .broadcast();
  var restores = 0;

  @override
  Stream<PurchaseUpdate> get updates => reported.stream;

  @override
  Future<bool> buy(String productId) async => true;

  @override
  Future<String?> priceOf(String productId) async => null;

  @override
  Future<void> recheckQuietly() async => rechecks++;

  @override
  Future<bool> restore() async {
    restores++;
    reported.add((
      code: null,
      outcome: PurchaseOutcome.restored,
      productId: iapRemoveAds,
    ));

    return true;
  }
}

// The whole composition but the screens: what is under test is that a
// restore reaches everything Remove ads changes.
void main() {
  test('the launch only checks quietly; a restore from Settings brings Remove '
      'ads back: kept, a free revive, no interstitial, and "Ads removed" in '
      'Settings', () async {
    // Given: a reinstall, nothing kept on the phone
    SharedPreferences.setMockInitialValues({});
    final store = _FakeStore();
    final container = ProviderContainer(
      overrides: [
        ...appOverrides(
          collectsTelemetry: false,
          router: AppRouter(),
          testTools: false,
        ),
        purchasesProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);
    container.listen(settings_ui_di.removeAdsOwnedProvider, (_, _) {});
    await startPurchases(container);
    expect((store.rechecks, store.restores), (1, 0));
    expect(await container.read(game.reviveNeedsAdProvider.future), isTrue);

    // When
    final outcome = await container.read(
      settings_ui_di.restorePurchasesProvider,
    )();

    // Then
    expect(outcome, RestoreOutcome.restored);
    expect(store.restores, 1);
    expect(
      (await SharedPreferences.getInstance()).getBool('purchases.removeAds'),
      isTrue,
    );
    expect(await container.read(game.reviveNeedsAdProvider.future), isFalse);
    // What the between-runs ad checks first, and stops at.
    expect(await container.read(game_di.adsRemovedProvider.future), isTrue);
    expect(container.read(settings_ui_di.removeAdsOwnedProvider), isTrue);
  });
}
