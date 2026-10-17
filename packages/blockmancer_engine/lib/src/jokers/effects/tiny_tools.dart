import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';

/// Pieces of up to [JokerTuning.tinyMaxPieceSize] cells are drawn
/// [JokerTuning.tinyFactor]× as often.
final class TinyTools extends JokerEffect {
  const TinyTools();

  @override
  JokerId get id => .tiny;

  @override
  JokerId get partner => .precision;

  @override
  int pieceWeight(Shape shape, JokerTuning tuning, int weight) =>
      shape.size <= tuning.tinyMaxPieceSize
      ? weight * tuning.tinyFactor
      : weight;
}
