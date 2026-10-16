import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:test/test.dart';

import '../board_picture.dart';

void main() {
  final single = shapeCatalog[0];
  final square = shapeCatalog[9];
  final horizontalFive = shapeCatalog[17];

  group('fits', () {
    test('a piece on empty cells inside the board fits', () {
      // Given
      final board = Board.empty();

      // When
      final result = fits(board, square, const Cell(col: 6, row: 6));

      // Then
      expect(result, isTrue);
    });

    test('a piece hanging off the right edge does not fit', () {
      // Given
      final board = Board.empty();

      // When
      final result = fits(board, horizontalFive, const Cell(col: 4, row: 0));

      // Then
      expect(result, isFalse);
    });

    test('a piece anchored above the board does not fit', () {
      // Given
      final board = Board.empty();

      // When
      final result = fits(board, single, const Cell(col: 0, row: -1));

      // Then
      expect(result, isFalse);
    });

    test('a piece overlapping a filled cell does not fit', () {
      // Given
      final board = boardFrom(['.#......']);

      // When
      final result = fits(board, square, const Cell(col: 0, row: 0));

      // Then
      expect(result, isFalse);
    });

    test('a stone blocks a piece like a filled cell', () {
      // Given
      final board = boardFrom(['S.......']);

      // When
      final result = fits(board, single, const Cell(col: 0, row: 0));

      // Then
      expect(result, isFalse);
    });

    test(
      'a piece fits around a cell its bounding box covers but it does not',
      () {
        // Given: shape 9 is the L missing its top-left cell
        final board = boardFrom(['#.......']);

        // When
        final result = fits(board, shapeCatalog[8], const Cell(col: 0, row: 0));

        // Then
        expect(result, isTrue);
      },
    );
  });

  group('fitsAnywhere', () {
    test('a piece with no room anywhere does not fit', () {
      // Given: every row has a gap of one cell only
      final board = boardFrom(List.filled(8, '#######.'));

      // When
      final result = fitsAnywhere(board, square);

      // Then
      expect(result, isFalse);
    });

    test('a piece with one spot left fits', () {
      // Given
      final board = boardFrom(List.filled(8, '#######.'));

      // When
      final result = fitsAnywhere(board, single);

      // Then
      expect(result, isTrue);
    });
  });

  group('placeShape', () {
    test('placing fills exactly the piece cells with its colour', () {
      // Given
      final board = Board.empty();

      // When
      final placed = placeShape(
        board,
        shapeCatalog[8],
        const Cell(col: 2, row: 3),
      );

      // Then
      const colour = CellState.filled(colorIndex: 8);
      expect(placed.at(const Cell(col: 3, row: 3)), colour);
      expect(placed.at(const Cell(col: 2, row: 4)), colour);
      expect(placed.at(const Cell(col: 3, row: 4)), colour);
      expect(placed.at(const Cell(col: 2, row: 3)), const CellState.empty());
      expect(placed.emptyCells, hasLength(Board.cellCount - 3));
    });
  });

  group('resolveClears', () {
    test('a board with no full line clears nothing', () {
      // Given
      final board = boardFrom(['#######.']);

      // When
      final result = resolveClears(board);

      // Then
      expect(result.clearedAny, isFalse);
      expect(result.board, board);
    });

    test('a full row clears its 8 cells', () {
      // Given
      final board = boardFrom(['........', '########', '#.......']);

      // When
      final result = resolveClears(board);

      // Then
      expect(result.rows, [1]);
      expect(result.cols, isEmpty);
      expect(result.cells, hasLength(8));
      expect(result.board, boardFrom(['........', '........', '#.......']));
    });

    test('a full column clears its 8 cells', () {
      // Given
      final board = boardFrom(List.filled(8, '..#.....'));

      // When
      final result = resolveClears(board);

      // Then
      expect(result.cols, [2]);
      expect(result.rows, isEmpty);
      expect(result.cells, hasLength(8));
      expect(result.board.isEmpty, isTrue);
    });

    test('a row and a column crossing count their shared cell once', () {
      // Given
      final board = boardFrom([
        '#.......',
        '#.......',
        '########',
        '#.......',
        '#.......',
        '#.......',
        '#.......',
        '#.......',
      ]);

      // When
      final result = resolveClears(board);

      // Then
      expect(result.lineCount, 2);
      expect(result.cells, hasLength(15));
      expect(result.board.isEmpty, isTrue);
    });

    test('stones in a cleared line are removed and counted', () {
      // Given
      final board = boardFrom(['##S##S##', 'S.......']);

      // When
      final result = resolveClears(board);

      // Then
      expect(result.stonesCleared, 2);
      expect(result.board, boardFrom(['........', 'S.......']));
    });
  });
}
