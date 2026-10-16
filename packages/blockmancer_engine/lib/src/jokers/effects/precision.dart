import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';

/// +6 mult when a 1–2 cell piece completes a line.
final class Precision extends JokerEffect {
  const Precision();

  static const _bonusMult = 6;
  static const _maxPieceSize = 2;

  @override
  JokerId get id => .precision;

  @override
  JokerId get partner => .tiny;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.pieceSize <= _maxPieceSize ? step.addMult(id, _bonusMult) : step;
}
