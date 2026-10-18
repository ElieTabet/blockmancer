import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:shared_domain/shared_domain.dart';

/// The puffs a fog cell's cloud is drawn from: each centre's offset from the
/// cell's centre and its radius, as shares of the cell.
const fogPuffs = [
  (-0.18, 0.08, 0.22),
  (0.02, -0.08, 0.27),
  (0.2, 0.06, 0.21),
  (0.0, 0.14, 0.24),
];

Color cellColor(CellState state) => switch (state) {
  EmptyCell() => DSGameColor.emptyCell,
  FilledCell(:final colorIndex) => DSGameColor.pieces[colorIndex],
  StoneCell() => DSGameColor.stone,
  FogCell() => DSGameColor.fog,
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

        final state = board.at(cell);

        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, _cellRadius),
          Paint()
            ..color = state is FogCell
                ? DSGameColor.emptyCell
                : cellColor(state),
        );

        if (state is FogCell) _cloud(canvas, rect);

        if (state is StoneCell) {
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

  /// A soft cloud over the empty cell: round where a stone is square and
  /// bevelled, so fog never reads as one.
  void _cloud(Canvas canvas, Rect rect) {
    final paint = Paint()..color = DSGameColor.fog.withValues(alpha: 0.85);

    for (final (dx, dy, size) in fogPuffs) {
      canvas.drawCircle(
        rect.center + Offset(dx * rect.width, dy * rect.height),
        rect.width * size,
        paint,
      );
    }
  }
}
