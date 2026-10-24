import 'dart:async';

import 'package:app_router/app_router.dart';
import 'package:app_update_domain/app_update_domain.dart' as app_update;
import 'package:app_update_presentation/app_update_presentation.dart'
    as app_update_ui;
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_domain/game_domain.dart' as game;
import 'package:shared_domain/shared_domain.dart'
    show AdResult, AnalyticsEvent, AnalyticsSink, Progression;
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:home_presentation/home_presentation.dart' as home_ui;
import 'package:settings_domain/settings_domain.dart' as settings;
import 'package:settings_presentation/settings_presentation.dart'
    as settings_ui;
import 'package:splash_presentation/splash_presentation.dart' as splash_ui;

/// Home's daily card, which is how these tests know Home is on screen.
const homeDailyTitle = 'Daily run';

/// The game's back arrow, which is how these tests know a run is on screen.
const gameLeaveLabel = 'Back to the menu';

/// Settings' gear on Home, which is how these tests open Settings.
const homeSettingsLabel = 'Settings';

/// Settings' back arrow.
const settingsCloseLabel = 'Close';

/// The tutorial coach's first line, which is how these tests know the
/// tutorial is on screen.
const tutorialFirstLine = 'Drag a piece onto the board';

/// Fills the slots the splash, Home, the game and Settings read, so a
/// composition test mounts the real screens with the real rules, a first
/// launch's settings, no sound or haptics and, unless [runStore] keeps one, no
/// saved run. The splash goes Home unless [tutorialSeen] says otherwise.
///
/// Nothing is published to Remote Config and no update is asked for, unless
/// [remoteValue] publishes: then the real update check reads it, for the
/// splash, the map's banner and the update screen [router] puts up.
List<Override> stubFeatures({
  required AppRouter router,
  app_update.RemoteValueFun Function(Ref ref)? remoteValue,
  game.RunStore? runStore,
  bool tutorialSeen = true,
}) => [
  if (remoteValue != null) ...[
    ...app_update.bindProviders(
      appVersion: (ref) async => '1.0.0',
      remoteValue: remoteValue,
      remoteValuesFetched: (ref) => Future.value(),
      storePlatform: (ref) => .ios,
      storeUrls: (ref) => (android: 'play', ios: 'appstore'),
      updateDismissals: (ref) => _MemoryDismissals(),
    ),
    ...app_update_ui.bindProviders(
      openUrl: (ref) =>
          (url) async => true,
      whenGameSettled: (ref) => ref.watch(game_ui.whenGameSettledProvider),
    ),
    ...app_update_ui.bindRoutingProviders(
      appUpdateRouting: (ref) => AppUpdateRoutingImpl(router),
    ),
  ],
  ...game.bindProviders(
    adsRemoved: (ref) async => false,
    analyticsSink: (ref) => const _NoAnalytics(),
    bestScores: (ref) => const _NoBestScores(),
    clock: (ref) => const _NoonClock(),
    engagementStore: (ref) => _MemoryEngagementStore(),
    gameRules: (ref) => const BlockmancerEngine(),
    onRunFinished: (ref) => () async {},
    progressionStore: (ref) =>
        _MemoryProgressionStore(ref.watch(game.initialProgressionProvider)),
    remoteValue:
        remoteValue ??
        (ref) =>
            (_) => null,
    runStore: (ref) => runStore ?? _NoRunStore(),
    appVersion: (ref) async => '1.0.0',
    requestReview: (ref) => () async {},
    sessionHadError: (ref) =>
        () => false,
    showInterstitial: (ref) =>
        () async => const AdResult.failed(code: 'no_ads'),
    submitBestScore: (ref) => (_) async {},
    submitDailyScore: (ref) => (_) async {},
  ),
  ...game_ui.bindProviders(
    hapticsOnSetting: (ref) => false,
    markTutorialSeen: (ref) => () async {},
    playSound: (ref) => (sound, {semitones = 0, variance = 0}) {},
    preloadAds: (ref) => () {},
    reduceMotionSetting: (ref) => false,
    rewardedAction: (ref) =>
        () async => const AdResult.earned(),
    rewardedAdReady: (ref) => Stream.value(true),
    soundOnSetting: (ref) => false,
  ),
  ...home_ui.bindProviders(
    dailyBest: (ref) async => null,
    dailyDate: (ref) => DateTime.utc(2026, 10, 17),
    dailyStreak: (ref) async => 0,
    dismissUpdateOffer: (ref) => remoteValue == null
        ? () async {}
        : ref.watch(app_update.dismissUpdateOfferProvider),
    hasSavedRun: (ref) => ref.watch(game.hasSavedRunProvider.future),
    jokerCollection: (ref) => ref.watch(game.jokerCollectionProvider),
    markJokersAnnounced: (ref) => ref.watch(game.markJokersAnnouncedProvider),
    markSpellbookSeen: (ref) => ref.watch(game.markSpellbookSeenProvider),
    openStoreListing: (ref) =>
        () async => true,
    practiceBest: (ref) async => null,
    progression: (ref) => ref.watch(game.progressionProvider.future),
    // Still, so the map's "you are here" pin lets pumpAndSettle settle.
    reduceMotionSetting: (ref) => true,
    showDailyLeaderboard: (ref) => () async {},
    updateOffer: (ref) => remoteValue == null
        ? Future.value()
        : ref.watch(app_update.updateOfferProvider.future),
    worlds: (ref) => ref.watch(game.worldSummariesProvider),
  ),
  ...settings.bindProviders(
    appDetails: (ref) async => const settings.AppDetails(
      build: '1',
      device: 'unknown',
      os: 'unknown',
      version: '1.0.0',
    ),
    clearProgress: (ref) => ref.watch(game.clearProgressProvider),
    composeEmail: (ref) =>
        (mailto) async => false,
    exportTestStats: (ref) =>
        () async => '{}',
    gatherConsent: (ref) =>
        () async => (canRequestAds: false, privacyOptionsRequired: false),
    openUrl: (ref) =>
        (url) async => false,
    setAnalyticsConsent: (ref) => ({required granted}) async {},
    settingsStore: (ref) => const _FirstLaunchSettingsStore(),
    showPrivacyOptions: (ref) => () async {},
  ),
  ...settings_ui.bindProviders(
    buyRemoveAds: (ref) =>
        () async => false,
    crashForTest: (ref) => () {},
    rateApp: (ref) => () async {},
    removeAdsOwned: (ref) => false,
    removeAdsPrice: (ref) async => null,
    restorePurchases: (ref) =>
        () async => .nothingFound,
    shareText: (ref) =>
        (text, {origin, subject}) async => false,
    showsTestTools: (ref) => false,
  ),
  ...splash_ui.bindProviders(
    reduceMotionSetting: (ref) async => true,
    tutorialSeen: (ref) async => tutorialSeen,
    updateRequired: (ref) => remoteValue == null
        ? Future.value(false)
        : ref.watch(app_update.updateRequiredProvider.future),
  ),
];

/// The banner closed per version, kept in memory.
final class _MemoryDismissals implements app_update.UpdateDismissals {
  String? dismissed;

  @override
  Future<void> dismiss(String version) async => dismissed = version;

  @override
  Future<String?> dismissedVersion() async => dismissed;
}

/// A first launch's settings, and nothing kept.
final class _FirstLaunchSettingsStore implements settings.SettingsStore {
  const _FirstLaunchSettingsStore();

  @override
  Future<settings.AppSettings> load() async => const settings.AppSettings();

  @override
  Future<void> save(settings.AppSettings settings) async {}
}

final class _NoBestScores implements game.BestScores {
  const _NoBestScores();

  @override
  Future<int?> best(game.GameMode mode) async => null;

  @override
  Future<Set<int>> dailyDays() async => {};

  @override
  Future<void> clearAll() async {}

  @override
  Future<void> save(game.GameMode mode, int total) async {}
}

/// Takes what is saved and gives nothing back.
final class _NoRunStore implements game.RunStore {
  @override
  Future<void> clear() async {}

  @override
  Future<game.SavedRun?> load() async => null;

  @override
  Future<void> save(game.SavedRun run) async {}
}

/// A run store that outlives the app it is given to, as the device's does.
/// Writes wait for [gate] when one is set.
final class MemoryRunStore implements game.RunStore {
  Completer<void>? gate;
  game.SavedRun? saved;

  @override
  Future<void> clear() async {
    await gate?.future;
    saved = null;
  }

  @override
  Future<game.SavedRun?> load() async => saved;

  @override
  Future<void> save(game.SavedRun run) async {
    await gate?.future;
    saved = run;
  }
}

final class _NoonClock implements game.Clock {
  const _NoonClock();

  @override
  DateTime now() => DateTime.utc(2026, 10, 17, 12);
}

/// The progression kept in memory, from a new player's.
final class _MemoryProgressionStore implements game.ProgressionStore {
  _MemoryProgressionStore(this._saved);

  Progression _saved;

  @override
  Future<Progression> load() async => _saved;

  @override
  Future<void> save(Progression progression) async => _saved = progression;
}

/// Counts nothing: a routing test plays no one's runs.
final class _NoAnalytics implements AnalyticsSink {
  const _NoAnalytics();

  @override
  void log(AnalyticsEvent event) {}
}

/// The engagement kept in memory, starting from nothing played.
final class _MemoryEngagementStore implements game.EngagementStore {
  game.Engagement saved = const game.Engagement();

  @override
  Future<game.Engagement> load() async => saved;

  @override
  Future<void> save(game.Engagement engagement) async => saved = engagement;
}
