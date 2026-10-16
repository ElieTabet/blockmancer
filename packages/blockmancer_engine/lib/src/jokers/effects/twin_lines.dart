import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

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
      move.clear.lineCount >= _minLines ? step.multiplyMult(_factor, id) : step;
}
