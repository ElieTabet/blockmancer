import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.fullHouseMultPerBlock] mult for every
/// [JokerTuning.fullHouseCellsPerMult] occupied cells,
/// filled or stone, once the piece has landed and before its lines clear.
final class FullHouse extends JokerEffect {
  const FullHouse();

  @override
  JokerId get id => .fullhouse;

  @override
  JokerId get partner => .brink;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) {
    final mult =
        move.occupiedAfterPlacing ~/
        move.tuning.fullHouseCellsPerMult *
        move.tuning.fullHouseMultPerBlock;

    return mult > 0 ? step.addMult(mult, id) : step;
  }
}
