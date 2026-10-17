import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// ×[JokerTuning.heavyFactor] mult when a piece of
/// [JokerTuning.heavyMinPieceSize]+ cells completes a line.
final class Heavyweight extends JokerEffect {
  const Heavyweight();

  @override
  JokerId get id => .heavy;

  @override
  JokerId get partner => .bigbox;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.pieceSize >= move.tuning.heavyMinPieceSize
      ? step.multiplyMult(move.tuning.heavyFactor, id)
      : step;
}
