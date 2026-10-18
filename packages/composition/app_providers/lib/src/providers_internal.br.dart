import 'dart:async';

import 'package:ads/ads.dart';
import 'package:app_providers/src/release_ids.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:leaderboards/leaderboards.dart';
import 'package:play_stats/play_stats.dart';
import 'package:push/push.dart';
import 'package:purchases/purchases.dart';
import 'package:remote_config/remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:sounds/sounds.dart';
import 'package:store_review/store_review.dart';
import 'package:telemetry/telemetry.dart' as telemetry;

part 'providers_internal.br.g.dart';

// app_providers — layer-internal providers: the instances composition builds
// once and hands out.

/// One for the app's life, so the ad SDK starts once. A test build can show
/// the form as in the EEA from anywhere: `--dart-define=UMP_DEBUG_EEA=true`
/// with the device's id from the UMP log as `UMP_TEST_DEVICE_ID`.
@Riverpod(keepAlive: true)
Consent consent(Ref ref) => GoogleConsent(
  adTestDeviceIds: [
    for (final id in admobTestDeviceIds.split(','))
      if (id.trim().isNotEmpty) id.trim(),
  ],
  debugEea:
      ref.watch(testToolsProvider) &&
      const bool.fromEnvironment('UMP_DEBUG_EEA'),
  testDeviceIds: [
    if (const String.fromEnvironment('UMP_TEST_DEVICE_ID') case final id
        when id.isNotEmpty)
      id,
  ],
);

/// Whether this build plays the real ad units: a release build that isn't a
/// test build. Every other build plays Google's test units.
bool _playsRealAds(Ref ref) => kReleaseMode && !ref.watch(testToolsProvider);

bool get _onIos => defaultTargetPlatform == .iOS;

/// One for the app's life, kept loaded between runs.
@Riverpod(keepAlive: true)
InterstitialAds interstitialAds(Ref ref) => AdMobInterstitialAds(
  adsAllowed: ref.watch(consentProvider).adsAllowed,
  unitId: _playsRealAds(ref)
      ? (_onIos ? admobUnits.interstitialIos : admobUnits.interstitialAndroid)
      : (_onIos
            ? TestAdUnits.interstitialIos
            : TestAdUnits.interstitialAndroid),
);

/// One for the app's life, kept loaded for the next revive.
@Riverpod(keepAlive: true)
RewardedAds rewardedAds(Ref ref) => AdMobRewardedAds(
  adsAllowed: ref.watch(consentProvider).adsAllowed,
  unitId: _playsRealAds(ref)
      ? (_onIos ? admobUnits.rewardedIos : admobUnits.rewardedAndroid)
      : (_onIos ? TestAdUnits.rewardedIos : TestAdUnits.rewardedAndroid),
);

/// Where every feature's events go: Firebase, and in a test build the
/// testers' on-device log too.
@Riverpod(keepAlive: true)
AnalyticsSink analyticsSink(Ref ref) => ref.watch(testToolsProvider)
    ? telemetry.CompositeAnalyticsSink([
        telemetry.FirebaseAnalyticsSink(),
        ref.watch(playStatsProvider),
      ])
    : telemetry.FirebaseAnalyticsSink();

/// One for the app's life, listening to the stores from launch so no
/// purchase is missed.
@Riverpod(keepAlive: true)
Purchases purchases(Ref ref) => StorePurchases();

/// One for the app's life. None on a platform whose ids are still
/// placeholders: Game Center would ask a player to sign in for boards that
/// don't exist, and Play Games has no project to sign in to.
@Riverpod(keepAlive: true)
Leaderboards leaderboards(Ref ref) {
  final ids = _onIos
      ? [dailyLeaderboard.ios, bestLeaderboard.ios]
      : [playGamesAppId, dailyLeaderboard.android, bestLeaderboard.android];

  return ids.any((id) => id.startsWith('PLACEHOLDER_'))
      ? const NoLeaderboards()
      : const GamesServicesLeaderboards();
}

/// One for the app's life: the OS's rating prompt and the store page.
@Riverpod(keepAlive: true)
StoreReview storeReview(Ref ref) => InAppStoreReview(appStoreId: appStoreId);

/// One for the app's life: the daily reminder, a local notification.
@Riverpod(keepAlive: true)
DailyReminder dailyReminder(Ref ref) => LocalDailyReminder();

/// One for the app's life: its sounds are loaded once, at launch.
@Riverpod(keepAlive: true)
GameSounds gameSounds(Ref ref) {
  final sounds = GameSounds();
  ref.onDispose(() => unawaited(sounds.dispose()));

  return sounds;
}

/// One for the app's life, so its writes stay in order. Its days are the
/// game's clock's.
@Riverpod(keepAlive: true)
LocalPlayStats playStats(Ref ref) =>
    LocalPlayStats(now: ref.watch(game.clockProvider).now);

/// One for the app's life. A test build fetches every few minutes, so a value
/// published in the console reaches a tester's next run; a release build twice
/// a day, as Remote Config's quotas expect.
@Riverpod(keepAlive: true)
RemoteValues remoteValues(Ref ref) => FirebaseRemoteValues(
  minimumFetchInterval: ref.watch(testToolsProvider)
      ? const Duration(minutes: 5)
      : const Duration(hours: 12),
);

/// The launch's fetch, started at boot and kept: the update check waits for
/// it, briefly, before deciding.
@Riverpod(keepAlive: true)
Future<void> remoteValuesFetched(Ref ref) =>
    ref.watch(remoteValuesProvider).fetchAndActivate();

/// Whether this is a test build: `TEST_TOOLS`, the app's to say.
@Riverpod(keepAlive: true)
bool testTools(Ref ref) => throw UnimplementedError(
  'testToolsProvider is overridden by featureBindingOverrides',
);
