import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.prismChipsPerPair] chips for each filled cell or stone whose
/// mirror cell is one too, counted once the move has cleared; fog never
/// counts.
final class Prism extends JokerEffect {
  const Prism();

  @override
  JokerId get id => .prism;

  @override
  JokerId get partner => .symmetry;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) {
    final board = move.clear.board;
    final mirrored =
        [
              for (var row = 0; row < Board.size; row++)
                for (var col = 0; col < Board.size; col++)
                  Cell(col: col, row: row),
            ]
            .where(
              (cell) =>
                  isSolid(board.at(cell)) && isSolid(board.at(mirrorOf(cell))),
            )
            .length;

    return mirrored > 0
        ? step.addChips(mirrored * move.tuning.prismChipsPerPair, id)
        : step;
  }
}
