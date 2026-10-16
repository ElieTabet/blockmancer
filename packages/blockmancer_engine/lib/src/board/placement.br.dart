import 'package:shared_domain/shared_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'placement.br.freezed.dart';

/// What clearing the full lines of a board did.
@freezed
abstract class ClearResult with _$ClearResult {
  const factory ClearResult({
    required Board board,

    /// Distinct cells, row-major: where a row and a column cross, the shared
    /// cell is here once.
    required List<Cell> cells,
    required List<int> cols,
    required List<int> rows,
    required int stonesCleared,
  }) = _ClearResult;

  const ClearResult._();

  bool get clearedAny => lineCount > 0;

  int get lineCount => rows.length + cols.length;
}

/// Whether [shape] anchored at [anchor] lands inside the board on empty cells
/// only. Stones block like any filled cell.
bool fits(Board board, Shape shape, {required Cell anchor}) =>
    shape.cells.every((offset) {
      final cell = anchor + offset;

      return board.contains(cell) && board.at(cell) is EmptyCell;
    });

bool fitsAnywhere(Board board, Shape shape) => [
  for (var row = 0; row < Board.size; row++)
    for (var col = 0; col < Board.size; col++) Cell(col: col, row: row),
].any((anchor) => fits(board, shape, anchor: anchor));

/// Fills the cells under [shape]; the caller has checked [fits].
Board placeShape(Board board, Shape shape, {required Cell anchor}) =>
    board.withCells({
      for (final offset in shape.cells)
        anchor + offset: .filled(colorIndex: shape.colorIndex),
    });

/// Where a stone may land: empty cells that wouldn't complete a line, so a
/// stone never fills a line that the next, unrelated move would then be
/// credited with clearing. Any empty cell when every one would.
List<Cell> stoneCells(Board board) {
  final empties = board.emptyCells;
  final safe = [
    for (final cell in empties)
      if (board.occupiedInRow(cell.row) < Board.size - 1 &&
          board.occupiedInCol(cell.col) < Board.size - 1)
        cell,
  ];

  return safe.isEmpty ? empties : safe;
}

/// Clears every full row and column at once, stones included.
ClearResult resolveClears(Board board) {
  final rows = board.fullRows;
  final cols = board.fullCols;

  final cleared = <Cell>{
    for (final row in rows)
      for (var col = 0; col < Board.size; col++) Cell(col: col, row: row),
    for (final col in cols)
      for (var row = 0; row < Board.size; row++) Cell(col: col, row: row),
  };

  final cells = cleared.toList()
    ..sort((a, b) => a.row != b.row ? a.row - b.row : a.col - b.col);

  return ClearResult(
    board: board.withCells({for (final cell in cells) cell: const .empty()}),
    cells: cells,
    cols: cols,
    rows: rows,
    stonesCleared: cells.where((cell) => board.at(cell) is StoneCell).length,
  );
}
