import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/game_presentation.dart' as game_ui;

/// The game tab's title, which is how these tests know it is on screen.
const gameTitle = 'Blockmancer';

/// Fills the slots the game tab reads, so a composition test mounts the real
/// tab with the real rules.
List<Override> stubGame() => [
  ...game.bindProviders(
    bestScores: (ref) => const _NoBestScores(),
    gameRules: (ref) => const BlockmancerEngine(),
  ),
  ...game_ui.bindProviders(
    rewardedAction: (ref) =>
        () async => true,
  ),
];

final class _NoBestScores implements game.BestScores {
  const _NoBestScores();

  @override
  Future<int?> best(game.GameMode mode) async => null;

  @override
  Future<void> save(game.GameMode mode, int total) async {}
}
