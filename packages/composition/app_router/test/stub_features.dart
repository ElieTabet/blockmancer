import 'package:blockmancer_engine/blockmancer_engine.dart';
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
List<Override> stubFeatures({
  game.RunStore? runStore,
  bool tutorialSeen = true,
}) => [
  ...game.bindProviders(
    analyticsSink: (ref) => const _NoAnalytics(),
    bestScores: (ref) => const _NoBestScores(),
    clock: (ref) => const _NoonClock(),
    engagementStore: (ref) => _MemoryEngagementStore(),
    gameRules: (ref) => const BlockmancerEngine(),
    progressionStore: (ref) =>
        _MemoryProgressionStore(ref.watch(game.initialProgressionProvider)),
    remoteValue: (ref) =>
        (_) => null,
    runStore: (ref) => runStore ?? _NoRunStore(),
    showInterstitial: (ref) =>
        () async => const AdResult.failed(code: 'no_ads'),
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
    dismissUpdateOffer: (ref) => () async {},
    hasSavedRun: (ref) => ref.watch(game.hasSavedRunProvider.future),
    jokerCollection: (ref) => ref.watch(game.jokerCollectionProvider),
    markJokersAnnounced: (ref) => ref.watch(game.markJokersAnnouncedProvider),
    openStoreListing: (ref) =>
        () async => true,
    practiceBest: (ref) async => null,
    progression: (ref) => ref.watch(game.progressionProvider.future),
    // Still, so the map's "you are here" pin lets pumpAndSettle settle.
    reduceMotionSetting: (ref) => true,
    updateOffer: (ref) async => null,
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
    crashForTest: (ref) => () {},
    shareText: (ref) =>
        (text, {origin, subject}) async => false,
    showsTestTools: (ref) => false,
  ),
  ...splash_ui.bindProviders(
    tutorialSeen: (ref) async => tutorialSeen,
    updateRequired: (ref) async => false,
  ),
];

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
final class MemoryRunStore implements game.RunStore {
  game.SavedRun? saved;

  @override
  Future<void> clear() async => saved = null;

  @override
  Future<game.SavedRun?> load() async => saved;

  @override
  Future<void> save(game.SavedRun run) async => saved = run;
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
