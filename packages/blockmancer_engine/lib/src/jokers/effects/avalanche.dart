import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.avalancheChipsPerCell] chips for every filled cell left in
/// the [JokerTuning.avalancheRows] bottom rows once the move's lines have
/// cleared. Stones don't count:
/// the joker rewards what the player stacked.
final class Avalanche extends JokerEffect {
  const Avalanche();

  @override
  JokerId get id => .avalanche;

  @override
  JokerId get partner => .anchor;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) {
    final filled = move.clear.board.cells
        .skip((Board.size - move.tuning.avalancheRows) * Board.size)
        .whereType<FilledCell>()
        .length;

    return filled > 0
        ? step.addChips(move.tuning.avalancheChipsPerCell * filled, id)
        : step;
  }
}
