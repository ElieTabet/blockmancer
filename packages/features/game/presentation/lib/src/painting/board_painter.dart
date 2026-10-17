import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:shared_domain/shared_domain.dart';

Color cellColor(CellState state) => switch (state) {
  EmptyCell() => DSGameColor.emptyCell,
  FilledCell(:final colorIndex) => DSGameColor.pieces[colorIndex],
  StoneCell() => DSGameColor.stone,
};

/// The board and what is on it.
final class BoardPainter extends CustomPainter {
  const BoardPainter(this.board);

  static const _boardRadius = Radius.circular(16);
  static const _cellRadius = Radius.circular(6);

  /// The stone bevel's width, as a share of the cell.
  static const _stoneBevel = 0.18;

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
        final rect = geometry.cellRect(cell);

        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, _cellRadius),
          Paint()..color = cellColor(board.at(cell)),
        );

        if (board.at(cell) is StoneCell) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              rect.deflate(rect.width * _stoneBevel),
              _cellRadius / 2,
            ),
            Paint()..color = DSGameColor.stoneFace,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => oldDelegate.board != board;
}
