import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.precisionBonusMult] mult when a piece of up to
/// [JokerTuning.precisionMaxPieceSize] cells completes a line.
final class Precision extends JokerEffect {
  const Precision();

  @override
  JokerId get id => .precision;

  @override
  JokerId get partner => .tiny;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.pieceSize <= move.tuning.precisionMaxPieceSize
      ? step.addMult(move.tuning.precisionBonusMult, id)
      : step;
}
