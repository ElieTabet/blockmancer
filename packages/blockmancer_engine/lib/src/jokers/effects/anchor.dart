import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.anchorMult] mult when the move clears the bottom row.
final class Anchor extends JokerEffect {
  const Anchor();

  @override
  JokerId get id => .anchor;

  @override
  JokerId get partner => .avalanche;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.clear.rows.contains(Board.size - 1)
      ? step.addMult(move.tuning.anchorMult, id)
      : step;
}
