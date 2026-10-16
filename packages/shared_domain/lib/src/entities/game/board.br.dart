import 'package:shared_domain/src/entities/game/cell.br.dart';
import 'package:shared_domain/src/entities/game/cell_state.br.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board.br.freezed.dart';

/// The 8×8 grid, row-major.
@freezed
abstract class Board with _$Board {
  const factory Board({required List<CellState> cells}) = _Board;

  const Board._();

  factory Board.empty() => Board(cells: List.filled(cellCount, const .empty()));

  static const cellCount = size * size;
  static const size = 8;

  /// Every empty cell, row-major — the order the stone streams index into.
  List<Cell> get emptyCells => [
    for (var index = 0; index < cellCount; index++)
      if (cells[index] is EmptyCell) _cellAt(index),
  ];

  List<int> get fullCols => [
    for (var col = 0; col < size; col++)
      if (_isFull([
        for (var row = 0; row < size; row++) Cell(col: col, row: row),
      ]))
        col,
  ];

  List<int> get fullRows => [
    for (var row = 0; row < size; row++)
      if (_isFull([
        for (var col = 0; col < size; col++) Cell(col: col, row: row),
      ]))
        row,
  ];

  bool get isEmpty => cells.every((cell) => cell is EmptyCell);

  CellState at(Cell cell) => cells[_indexOf(cell)];

  bool contains(Cell cell) =>
      cell.row >= 0 && cell.row < size && cell.col >= 0 && cell.col < size;

  int occupiedInCol(int col) => [
    for (var row = 0; row < size; row++) Cell(col: col, row: row),
  ].where((cell) => at(cell) is! EmptyCell).length;

  int occupiedInRow(int row) => [
    for (var col = 0; col < size; col++) Cell(col: col, row: row),
  ].where((cell) => at(cell) is! EmptyCell).length;

  Board withCells(Map<Cell, CellState> changes) {
    final next = [...cells];

    for (final MapEntry(key: cell, value: state) in changes.entries) {
      next[_indexOf(cell)] = state;
    }

    return Board(cells: next);
  }

  static Cell _cellAt(int index) => Cell(col: index % size, row: index ~/ size);

  int _indexOf(Cell cell) {
    if (!contains(cell)) throw RangeError('$cell is outside the board');

    return cell.row * size + cell.col;
  }

  bool _isFull(List<Cell> line) => line.every((cell) => at(cell) is! EmptyCell);
}
