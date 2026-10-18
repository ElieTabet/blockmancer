import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:shared_domain/shared_domain.dart';

/// In the boss, every piece lands reflected across the board's vertical
/// centre line: a cell dropped on `(row, col)` fills `(row, 7 - col)`, so the
/// piece's place and shape are both mirrored.
final class MirrorRule extends WorldRule {
  const MirrorRule();

  @override
  bool get bossOnly => true;

  @override
  List<Cell>? transformPlacement({
    required Board board,
    required List<Cell> cells,
  }) {
    final mirrored = [for (final cell in cells) mirrorOf(cell)];

    return cellsFit(board, mirrored) ? mirrored : null;
  }

  @override
  List<Cell> previewPlacement({
    required Board board,
    required List<Cell> cells,
  }) => [for (final cell in cells) mirrorOf(cell)];
}
