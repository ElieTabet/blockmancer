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
}
