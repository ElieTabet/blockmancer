import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// ×2 mult when the move clears a column.
final class ColumnHunter extends JokerEffect {
  const ColumnHunter();

  static const _factor = 2;

  @override
  JokerId get id => .column;

  @override
  JokerId get partner => .sweep;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.clear.cols.isNotEmpty ? step.multiplyMult(_factor, id) : step;
}
