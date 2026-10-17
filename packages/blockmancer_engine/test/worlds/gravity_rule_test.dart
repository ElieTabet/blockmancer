import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:blockmancer_engine/src/worlds/gravity_rule.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';

void main() {
  const gravity = GravityRule();
  final single = shapeCatalog[0];
  final square = shapeCatalog[9];
  final smallL = shapeCatalog[5];

  test('a piece dropped on an empty board falls to the bottom', () {
    // Given
    final board = Board.empty();

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 2, row: 0),
      board: board,
      shape: square,
    );

    // Then
    expect(landing, const Cell(col: 2, row: 6));
  });

  test('a piece already on the bottom row stays where it is dropped', () {
    // Given
    final board = Board.empty();

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 5, row: 7),
      board: board,
      shape: single,
    );

    // Then
    expect(landing, const Cell(col: 5, row: 7));
  });

  test('a piece lands on the first filled cell under any of its columns', () {
    // Given: a ledge under the square's right column only
    final board = boardFrom(['........', '........', '........', '...#....']);

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 2, row: 0),
      board: board,
      shape: square,
    );

    // Then: it rests on the ledge, its left column hanging over empty cells
    expect(landing, const Cell(col: 2, row: 1));
  });

  test(
    'a piece lands on an overhang, the empty cells under it out of reach',
    () {
      // Given: a ledge on row 3 with nothing under it
      final board = boardFrom(['........', '........', '........', '..###...']);

      // When
      final landing = gravity.transformAnchor(
        anchor: const Cell(col: 3, row: 0),
        board: board,
        shape: single,
      );

      // Then
      expect(landing, const Cell(col: 3, row: 2));
    },
  );

  test('an L stops on its foot though its upright could fall further', () {
    // Given: a block under the right cell of the L's foot, column 0 empty
    final board = boardFrom([
      '........',
      '........',
      '........',
      '........',
      '........',
      '.#......',
    ]);

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 0, row: 0),
      board: board,
      shape: smallL,
    );

    // Then
    expect(landing, const Cell(col: 0, row: 3));
  });

  test('a piece lands on a stone as on a filled cell', () {
    // Given
    final board = boardFrom([
      '........',
      '........',
      '........',
      '........',
      '....S...',
    ]);

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 4, row: 0),
      board: board,
      shape: single,
    );

    // Then
    expect(landing, const Cell(col: 4, row: 3));
  });

  test('a piece does not fall through a gap narrower than itself', () {
    // Given: a hole one cell wide in row 4
    final board = boardFrom([
      '........',
      '........',
      '........',
      '........',
      '###.####',
    ]);

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 3, row: 0),
      board: board,
      shape: square,
    );

    // Then
    expect(landing, const Cell(col: 3, row: 2));
  });

  test('a piece cannot be dropped in a column full to the top', () {
    // Given
    final board = boardFrom([
      '..#.....',
      '..#.....',
      '..#.....',
      '..#.....',
      '..#.....',
      '..#.....',
      '..#.....',
      '..#.....',
    ]);

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 2, row: 0),
      board: board,
      shape: single,
    );

    // Then
    expect(landing, isNull);
  });

  test('a piece hanging off the board cannot be dropped', () {
    // Given
    final board = Board.empty();

    // When
    final landing = gravity.transformAnchor(
      anchor: const Cell(col: 7, row: 0),
      board: board,
      shape: square,
    );

    // Then
    expect(landing, isNull);
  });

  test('holds in the boss round only', () {
    expect(gravity.bossOnly, isTrue);
  });
}
