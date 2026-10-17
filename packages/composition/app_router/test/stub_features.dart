import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:home_presentation/home_presentation.dart' as home_ui;
import 'package:settings_domain/settings_domain.dart' as settings;
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
    bestScores: (ref) => const _NoBestScores(),
    clock: (ref) => const _NoonClock(),
    gameRules: (ref) => const BlockmancerEngine(),
    runStore: (ref) => runStore ?? _NoRunStore(),
  ),
  ...game_ui.bindProviders(
    hapticsOnSetting: (ref) => false,
    markTutorialSeen: (ref) => () async {},
    playSound: (ref) => (sound, {semitones = 0, variance = 0}) {},
    reduceMotionSetting: (ref) => false,
    rewardedAction: (ref) =>
        () async => true,
    soundOnSetting: (ref) => false,
  ),
  ...home_ui.bindProviders(
    dailyBest: (ref) async => null,
    hasSavedRun: (ref) => ref.watch(game.hasSavedRunProvider.future),
    practiceBest: (ref) async => null,
  ),
  ...settings.bindProviders(
    clearProgress: (ref) => ref.watch(game.clearProgressProvider),
    settingsStore: (ref) => const _FirstLaunchSettingsStore(),
  ),
  ...splash_ui.bindProviders(tutorialSeen: (ref) async => tutorialSeen),
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
