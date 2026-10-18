import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.stonemasonChipsPerStone] chips per stone cleared;
/// [JokerTuning.stonemasonExtraStones] more stones at the start of every round.
final class Stonemason extends JokerEffect {
  const Stonemason();

  @override
  JokerId get id => .stonemason;

  @override
  JokerKind get kind => .chips;

  @override
  JokerId get partner => .quarry;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) {
    final stones = move.clear.stonesCleared;

    return stones > 0
        ? step.addChips(move.tuning.stonemasonChipsPerStone * stones, id)
        : step;
  }

  @override
  RoundSetup onRoundSetup(RoundSetup setup, JokerTuning tuning) =>
      setup.addStones(tuning.stonemasonExtraStones, id);
}
