import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';

/// Pieces of [JokerTuning.bigBoxMinPieceSize]+ cells are drawn
/// [JokerTuning.bigBoxFactor]× as often.
final class BigBox extends JokerEffect {
  const BigBox();

  @override
  JokerId get id => .bigbox;

  @override
  JokerKind get kind => .drawWeight;

  @override
  JokerId get partner => .heavy;

  @override
  int pieceWeight(Shape shape, JokerTuning tuning, int weight) =>
      shape.size >= tuning.bigBoxMinPieceSize
      ? weight * tuning.bigBoxFactor
      : weight;
}
