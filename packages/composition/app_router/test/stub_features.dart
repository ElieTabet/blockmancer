import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:home_presentation/home_presentation.dart' as home_ui;

/// Home's daily card, which is how these tests know Home is on screen.
const homeDailyTitle = 'Daily run';

/// The game's back arrow, which is how these tests know a run is on screen.
const gameLeaveTooltip = 'Back to the menu';

/// Fills the slots Home and the game read, so a composition test mounts the
/// real screens with the real rules and, unless [runStore] keeps one, no saved
/// run.
List<Override> stubFeatures({game.RunStore? runStore}) => [
  ...game.bindProviders(
    bestScores: (ref) => const _NoBestScores(),
    clock: (ref) => const _NoonClock(),
    gameRules: (ref) => const BlockmancerEngine(),
    runStore: (ref) => runStore ?? _NoRunStore(),
  ),
  ...game_ui.bindProviders(
    rewardedAction: (ref) =>
        () async => true,
  ),
  ...home_ui.bindProviders(
    dailyBest: (ref) async => null,
    hasSavedRun: (ref) => ref.watch(game.hasSavedRunProvider.future),
    practiceBest: (ref) async => null,
  ),
];

final class _NoBestScores implements game.BestScores {
  const _NoBestScores();

  @override
  Future<int?> best(game.GameMode mode) async => null;

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
