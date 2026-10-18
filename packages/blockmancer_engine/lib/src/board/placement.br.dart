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

    /// Stones and fog the move took off the board, in its lines (fog counted
    /// whatever it hid) and beside them (Lantern): what Ember reads.
    @Default(0) int obstaclesCleared,

    /// Cells taken off the board beside the cleared lines, row-major.
    @Default([]) List<Cell> removed,
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
    placeCells(board, [
      for (final offset in shape.cells) anchor + offset,
    ], colorIndex: shape.colorIndex);

/// Fills [cells] in [colorIndex]; the caller has checked they are empty.
Board placeCells(Board board, List<Cell> cells, {required int colorIndex}) =>
    board.withCells({
      for (final cell in cells) cell: .filled(colorIndex: colorIndex),
    });

/// Whether every one of [cells] is on the board and empty.
bool cellsFit(Board board, List<Cell> cells) =>
    cells.every((cell) => board.contains(cell) && board.at(cell) is EmptyCell);

/// The top-left corner of [cells]' bounding box.
Cell topLeftOf(List<Cell> cells) => Cell(
  col: cells.map((cell) => cell.col).reduce((a, b) => a < b ? a : b),
  row: cells.map((cell) => cell.row).reduce((a, b) => a < b ? a : b),
);

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

/// Clears every full row and column at once, stones and fog included; a fog
/// cell's hidden stone goes with it, uncounted, since it was never seen.
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
    obstaclesCleared: cells.where((cell) => _isObstacle(board.at(cell))).length,
  );
}

bool _isObstacle(CellState cell) => cell is StoneCell || cell is FogCell;

/// The cells sharing a side with [cell], on the board or not.
List<Cell> orthogonalNeighbours(Cell cell) => [
  Cell(col: cell.col, row: cell.row - 1),
  Cell(col: cell.col - 1, row: cell.row),
  Cell(col: cell.col + 1, row: cell.row),
  Cell(col: cell.col, row: cell.row + 1),
];

/// Takes the stones and fog beside [clear]'s lines off the board too.
ClearResult clearObstaclesBeside(ClearResult clear) {
  final lines = clear.cells.toSet();
  final beside = {
    for (final cell in clear.cells)
      for (final neighbour in orthogonalNeighbours(cell))
        if (clear.board.contains(neighbour) &&
            !lines.contains(neighbour) &&
            _isObstacle(clear.board.at(neighbour)))
          neighbour,
  }.toList()..sort((a, b) => a.row != b.row ? a.row - b.row : a.col - b.col);

  if (beside.isEmpty) return clear;

  return clear.copyWith(
    board: clear.board.withCells({
      for (final cell in beside) cell: const .empty(),
    }),
    obstaclesCleared: clear.obstaclesCleared + beside.length,
    removed: [...clear.removed, ...beside],
  );
}
