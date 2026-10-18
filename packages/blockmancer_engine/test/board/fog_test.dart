import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../play_move.dart';

void main() {
  final single = shapeCatalog[0];

  test('fog blocks a piece like a stone, whatever it hides', () {
    // Given
    final board = boardFrom(['FH......']);

    // When / Then
    expect(fits(board, single, anchor: topLeft), isFalse);
    expect(fits(board, single, anchor: const Cell(col: 1, row: 0)), isFalse);
    expect(fits(board, single, anchor: const Cell(col: 2, row: 0)), isTrue);
  });

  test('fog counts as occupied in its row and its column', () {
    // Given
    final board = boardFrom(['F.H.....']);

    // When / Then
    expect(board.occupiedInRow(0), 2);
    expect(board.occupiedInCol(0), 1);
    expect(board.isEmpty, isFalse);
  });

  test('a line with fog in it is full, and clears with the fog', () {
    // Given
    final board = boardFrom(['###F##F#', 'F.......']);

    // When
    final result = resolveClears(board);

    // Then
    expect(result.rows, [0]);
    expect(result.board, boardFrom(['........', 'F.......']));
  });

  test('a stone hidden under fog goes with its line, uncounted', () {
    // Given
    final board = boardFrom(['##S##H##']);

    // When
    final result = resolveClears(board);

    // Then: only the stone that was seen counts
    expect(result.stonesCleared, 1);
    expect(result.board.isEmpty, isTrue);
  });

  test('Full House counts fog as occupied', () {
    // Given / When: 8 filled cells once the piece lands and 5 fog cells make
    // 13, so 2 blocks of 6
    final score = playMove(
      ['#######.', 'FFFFF...'],
      at: topRight,
      jokers: const [.fullhouse],
      shape: 0,
    );

    // Then
    expect(score.mult, 1 + 2);
  });
}
