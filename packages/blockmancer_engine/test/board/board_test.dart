import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';

void main() {
  test('an empty board has 64 empty cells, row-major', () {
    // Given
    final board = Board.empty();

    // When
    final empties = board.emptyCells;

    // Then
    expect(empties, hasLength(64));
    expect(empties[9], const Cell(col: 1, row: 1));
    expect(board.isEmpty, isTrue);
  });

  test('a stone makes the board not empty', () {
    // Given
    final board = boardFrom(['.......S']);

    // When / Then
    expect(board.isEmpty, isFalse);
  });

  test('a row counts its filled cells and stones as occupied', () {
    // Given
    final board = boardFrom(['........', '#S.#....']);

    // When / Then
    expect(board.occupiedInRow(1), 3);
    expect(board.occupiedInRow(0), 0);
  });

  test('reading a cell outside the board is an error', () {
    // Given
    final board = Board.empty();

    // When / Then
    expect(() => board.at(const Cell(col: 8, row: 0)), throwsRangeError);
  });

  test('changing cells leaves the original board untouched', () {
    // Given
    final board = Board.empty();

    // When
    final changed = board.withCells({
      const Cell(col: 0, row: 0): const CellState.stone(),
    });

    // Then
    expect(board.isEmpty, isTrue);
    expect(changed.at(const Cell(col: 0, row: 0)), const CellState.stone());
  });

  test('a column counts its filled cells and stones as occupied', () {
    // Given
    final board = boardFrom(['.#......', '.S......', '........']);

    // When / Then
    expect(board.occupiedInCol(1), 2);
    expect(board.occupiedInCol(0), 0);
  });
}
