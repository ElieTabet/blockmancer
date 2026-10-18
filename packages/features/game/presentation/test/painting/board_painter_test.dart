import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/painting/board_painter.dart';
import 'package:shared_domain/shared_domain.dart';

void main() {
  const size = Size.square(323);

  test('a fog cell is a soft cloud over an empty cell, with no stone bevel, '
      'whatever it hides', () {
    for (final hidesStone in const [false, true]) {
      // Given
      final painter = BoardPainter(
        Board.empty().withCells({
          const Cell(col: 0, row: 0): CellState.fog(hidesStone: hidesStone),
        }),
      );

      // When / Then: the board, 64 cells and no bevel; the cloud's 4 puffs
      expect(
        (Canvas canvas) => painter.paint(canvas, size),
        allOf(
          paintsExactlyCountTimes(#drawRRect, 1 + 64),
          paintsExactlyCountTimes(#drawCircle, fogPuffs.length),
          paints..circle(color: DSGameColor.fog.withValues(alpha: 0.85)),
        ),
        reason: 'hidesStone: $hidesStone',
      );
    }
  });

  test('a stone is a bevelled square, with no cloud', () {
    // Given
    final painter = BoardPainter(
      Board.empty().withCells({const Cell(col: 0, row: 0): const .stone()}),
    );

    // When / Then
    expect(
      (Canvas canvas) => painter.paint(canvas, size),
      allOf(
        paintsExactlyCountTimes(#drawRRect, 1 + 64 + 1),
        paintsExactlyCountTimes(#drawCircle, 0),
      ),
    );
  });

  test('a board about to rise draws its cells a row lower, its frame where it '
      'is', () {
    // Given
    final painter = BoardPainter(Board.empty(), rowShift: 1);

    // When / Then: the frame, then the first cell a row down
    expect(
      (Canvas canvas) => painter.paint(canvas, size),
      paints
        ..rrect()
        ..translate(y: (size.width - 2 * 6 + 3) / Board.size),
    );
  });

  test('a top row the next rise would flood is tinted', () {
    // Given
    final painter = BoardPainter(
      Board.empty().withCells({const Cell(col: 3, row: 0): const .stone()}),
      warnTopRow: true,
    );

    // When / Then: the board, 64 cells, the stone's bevel and 8 tints
    expect(
      (Canvas canvas) => painter.paint(canvas, size),
      paintsExactlyCountTimes(#drawRRect, 1 + 64 + 1 + Board.size),
    );
  });

  test('in Mirror\'s boss, a line runs down the board\'s middle', () {
    // Given
    final painter = BoardPainter(Board.empty(), centreLine: true);

    // When / Then
    expect(
      (Canvas canvas) => painter.paint(canvas, size),
      paints..line(
        p1: Offset(size.width / 2, 6),
        p2: Offset(size.width / 2, size.width - 6),
      ),
    );
  });
}
