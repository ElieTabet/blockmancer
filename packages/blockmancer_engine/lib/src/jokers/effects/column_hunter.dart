import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// ×[JokerTuning.columnFactor] mult when the move clears a column.
final class ColumnHunter extends JokerEffect {
  const ColumnHunter();

  @override
  JokerId get id => .column;

  @override
  JokerId get partner => .sweep;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.clear.cols.isNotEmpty
      ? step.multiplyMult(move.tuning.columnFactor, id)
      : step;
}
