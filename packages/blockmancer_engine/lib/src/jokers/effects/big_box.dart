import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';

/// Pieces of 5+ cells are drawn 3× as often.
final class BigBox extends JokerEffect {
  const BigBox();

  static const _factor = 3;
  static const _minPieceSize = 5;

  @override
  JokerId get id => .bigbox;

  @override
  JokerId get partner => .heavy;

  @override
  int pieceWeight(Shape shape, int weight) =>
      shape.size >= _minPieceSize ? weight * _factor : weight;
}
