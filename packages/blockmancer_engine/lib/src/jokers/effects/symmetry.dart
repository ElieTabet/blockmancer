import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.symmetryMult] mult when the clear leaves the board
/// left-right symmetric and not empty: filled cells and stones mirror each
/// other, colour aside, and any fog breaks the symmetry.
final class Symmetry extends JokerEffect {
  const Symmetry();

  @override
  JokerId get id => .symmetry;

  @override
  JokerId get partner => .prism;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) {
    final board = move.clear.board;
    final symmetric =
        !board.isEmpty &&
        board.cells.every((cell) => cell is! FogCell) &&
        [
          for (var row = 0; row < Board.size; row++)
            for (var col = 0; col < Board.size ~/ 2; col++)
              Cell(col: col, row: row),
        ].every(
          (cell) =>
              isSolid(board.at(cell)) == isSolid(board.at(mirrorOf(cell))),
        );

    return symmetric ? step.addMult(move.tuning.symmetryMult, id) : step;
  }
}
