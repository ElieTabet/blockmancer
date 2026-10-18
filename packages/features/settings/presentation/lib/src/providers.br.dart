import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/entities/app_language_locale.dart';
import 'package:settings_presentation/src/providers_di.br.dart' as di;
import 'package:settings_presentation/src/routing/settings_routing.dart';

part 'providers.br.g.dart';

// settings_presentation — public providers exposed by this layer.

typedef ApplyStoredLanguageFun = Future<void> Function();

/// Shows the app in the language the player chose. Startup awaits it before
/// the first frame, so a chosen language never flashes the phone's first.
@riverpod
ApplyStoredLanguageFun applyStoredLanguage(Ref ref) =>
    () async => (await ref.read(settingsProvider.future)).language.apply();

List<Override> bindProviders({
  required di.BuyRemoveAdsFun Function(Ref ref) buyRemoveAds,
  required VoidCallback Function(Ref ref) crashForTest,
  required di.RateAppFun Function(Ref ref) rateApp,
  required bool Function(Ref ref) removeAdsOwned,
  required Future<String?> Function(Ref ref) removeAdsPrice,
  required di.RestorePurchasesFun Function(Ref ref) restorePurchases,
  required di.ShareTextFun Function(Ref ref) shareText,
  required bool Function(Ref ref) showsTestTools,
}) => [
  di.buyRemoveAdsProvider.overrideWith(buyRemoveAds),
  di.crashForTestProvider.overrideWith(crashForTest),
  di.rateAppProvider.overrideWith(rateApp),
  di.removeAdsOwnedProvider.overrideWith(removeAdsOwned),
  di.removeAdsPriceProvider.overrideWith(removeAdsPrice),
  di.restorePurchasesProvider.overrideWith(restorePurchases),
  di.shareTextProvider.overrideWith(shareText),
  di.showsTestToolsProvider.overrideWith(showsTestTools),
];

List<Override> bindRoutingProviders({
  required SettingsRouting Function(Ref ref) settingsRouting,
}) => [di.settingsRoutingProvider.overrideWith(settingsRouting)];
