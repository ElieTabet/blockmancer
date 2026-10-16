import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';

/// ×3 mult when 2 or more lines clear at once.
final class TwinLines extends JokerEffect {
  const TwinLines();

  static const _factor = 3;
  static const _minLines = 2;

  @override
  JokerId get id => .twin;

  @override
  JokerId get partner => .patience;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.clear.lineCount >= _minLines ? step.multiplyMult(id, _factor) : step;
}
