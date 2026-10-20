import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_presentation/src/routing/settings_routing.dart';

part 'providers_di.br.g.dart';

// settings_presentation — inbound dependency-injection slots. Each throws
// until the composition layer overrides it.

/// Crashes the app on purpose, so a test build can check that crash reports
/// arrive.
@riverpod
VoidCallback crashForTest(Ref ref) => throw UnimplementedError(
  'crashForTestProvider must be overridden by the composition layer',
);

@riverpod
SettingsRouting settingsRouting(Ref ref) => throw UnimplementedError(
  'settingsRoutingProvider must be overridden by the composition layer (app_router)',
);

/// Opens the share sheet with [text], and answers whether it opened. [origin]
/// is the rect it points from on an iPad.
typedef ShareTextFun =
    Future<bool> Function(String text, {Rect? origin, String? subject});

@riverpod
ShareTextFun shareText(Ref ref) => throw UnimplementedError(
  'shareTextProvider must be overridden by the composition layer',
);

/// Whether this is a test build, whose testers get their own rows: sharing
/// the play stats and a test crash.
@riverpod
bool showsTestTools(Ref ref) => throw UnimplementedError(
  'showsTestToolsProvider must be overridden by the composition layer',
);

/// Opens the store's sheet for Remove ads; false when it couldn't open.
typedef BuyRemoveAdsFun = Future<bool> Function();

@riverpod
BuyRemoveAdsFun buyRemoveAds(Ref ref) => throw UnimplementedError(
  'buyRemoveAdsProvider must be overridden by the composition layer',
);

/// Whether the player owns Remove ads.
@riverpod
bool removeAdsOwned(Ref ref) => throw UnimplementedError(
  'removeAdsOwnedProvider must be overridden by the composition layer',
);

/// Remove ads' price for this player, or null while the store can't say.
@riverpod
Future<String?> removeAdsPrice(Ref ref) => throw UnimplementedError(
  'removeAdsPriceProvider must be overridden by the composition layer',
);

/// Asks the store for what the player owns: whether Remove ads is owned once
/// it has answered, or null when a restore is already under way, whose own
/// answer is the one to show.
typedef RestorePurchasesFun = Future<bool?> Function();

@riverpod
RestorePurchasesFun restorePurchases(Ref ref) => throw UnimplementedError(
  'restorePurchasesProvider must be overridden by the composition layer',
);

/// Opens the app's page in its store, for a rating: always allowed, unlike
/// the OS's prompt.
typedef RateAppFun = Future<void> Function();

@riverpod
RateAppFun rateApp(Ref ref) => throw UnimplementedError(
  'rateAppProvider must be overridden by the composition layer',
);
