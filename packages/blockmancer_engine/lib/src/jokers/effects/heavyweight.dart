import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// ×2 mult when a piece of 4+ cells completes a line.
final class Heavyweight extends JokerEffect {
  const Heavyweight();

  static const _factor = 2;
  static const _minPieceSize = 4;

  @override
  JokerId get id => .heavy;

  @override
  JokerId get partner => .bigbox;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.pieceSize >= _minPieceSize ? step.multiplyMult(_factor, id) : step;
}
