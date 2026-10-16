import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +50 chips per stone cleared; 2 more stones at the start of every round.
final class Stonemason extends JokerEffect {
  const Stonemason();

  static const _chipsPerStone = 50;
  static const _extraStones = 2;

  @override
  JokerId get id => .stonemason;

  @override
  JokerId get partner => .quarry;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) {
    final stones = move.clear.stonesCleared;

    return stones > 0 ? step.addChips(_chipsPerStone * stones, id) : step;
  }

  @override
  RoundSetup onRoundSetup(RoundSetup setup) =>
      setup.addStones(_extraStones, id);
}
