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
/// real screens with the real rules and nothing stored.
List<Override> stubFeatures() => [
  ...game.bindProviders(
    bestScores: (ref) => const _NoBestScores(),
    clock: (ref) => const _NoonClock(),
    gameRules: (ref) => const BlockmancerEngine(),
  ),
  ...game_ui.bindProviders(
    rewardedAction: (ref) =>
        () async => true,
  ),
  ...home_ui.bindProviders(
    dailyBest: (ref) async => null,
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

final class _NoonClock implements game.Clock {
  const _NoonClock();

  @override
  DateTime now() => DateTime.utc(2026, 10, 17, 12);
}
