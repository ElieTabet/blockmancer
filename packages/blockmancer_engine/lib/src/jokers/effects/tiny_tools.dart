import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';

/// Pieces of 1–2 cells are drawn 3× as often.
final class TinyTools extends JokerEffect {
  const TinyTools();

  static const _factor = 3;
  static const _maxPieceSize = 2;

  @override
  JokerId get id => .tiny;

  @override
  JokerId get partner => .precision;

  @override
  int pieceWeight(Shape shape, int weight) =>
      shape.size <= _maxPieceSize ? weight * _factor : weight;
}
