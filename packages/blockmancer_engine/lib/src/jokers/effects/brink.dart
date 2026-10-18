import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// ×[JokerTuning.brinkFactor] mult when [JokerTuning.brinkMinOccupied] or more
/// cells, filled or stone, are occupied once the piece has landed and before
/// its lines clear.
final class Brink extends JokerEffect {
  const Brink();

  @override
  JokerId get id => .brink;

  @override
  JokerKind get kind => .multiplicativeMult;

  @override
  JokerId get partner => .fullhouse;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.occupiedAfterPlacing >= move.tuning.brinkMinOccupied
      ? step.multiplyMult(move.tuning.brinkFactor, id)
      : step;
}
