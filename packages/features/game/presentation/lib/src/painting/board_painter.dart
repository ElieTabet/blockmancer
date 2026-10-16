import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:shared_domain/shared_domain.dart';

/// The board and what is on it.
final class BoardPainter extends CustomPainter {
  const BoardPainter(this.board);

  static const _boardRadius = Radius.circular(16);
  static const _cellRadius = Radius.circular(6);

  final Board board;

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = BoardGeometry(size.shortestSide);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & Size.square(geometry.side),
        _boardRadius,
      ),
      Paint()..color = DSGameColor.boardBackground,
    );

    for (var row = 0; row < Board.size; row++) {
      for (var col = 0; col < Board.size; col++) {
        final cell = Cell(col: col, row: row);
        final color = switch (board.at(cell)) {
          EmptyCell() => DSGameColor.emptyCell,
          FilledCell(:final colorIndex) => DSGameColor.pieces[colorIndex],
          StoneCell() => DSGameColor.stone,
        };

        canvas.drawRRect(
          RRect.fromRectAndRadius(geometry.cellRect(cell), _cellRadius),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => oldDelegate.board != board;
}
