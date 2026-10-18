import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:shared_domain/shared_domain.dart';

/// In the boss, a piece falls straight down from where it is dropped, as one
/// rigid shape, until one more row would leave the board or hit a filled cell
/// or a stone. A drop point it doesn't fit at is not a placement.
final class GravityRule extends WorldRule {
  const GravityRule();

  @override
  bool get bossOnly => true;

  @override
  List<Cell>? transformPlacement({
    required Board board,
    required List<Cell> cells,
  }) {
    if (!cellsFit(board, cells)) return null;

    var landing = cells;

    while (true) {
      final lower = [
        for (final cell in landing) Cell(col: cell.col, row: cell.row + 1),
      ];

      if (!cellsFit(board, lower)) return landing;

      landing = lower;
    }
  }
}
