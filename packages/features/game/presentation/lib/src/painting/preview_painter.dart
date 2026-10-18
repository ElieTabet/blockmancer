import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:game_presentation/src/notifiers/drag_preview.br.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:shared_domain/shared_domain.dart';

/// The drag shadow over the board: the piece's colour where it fits, red where
/// it collides, an outline on the lines it would clear, and in Mirror's boss
/// an outline under the finger, where the piece is held but won't land.
final class PreviewPainter extends CustomPainter {
  const PreviewPainter(this.drag);

  static const _cellRadius = Radius.circular(6);
  static const _heldAlpha = 0.7;
  static const _outlineWidth = 2.0;
  static const _shadowAlpha = 0.6;
  static const _strayAlpha = 0.45;

  final DragPreview? drag;

  @override
  void paint(Canvas canvas, Size size) {
    final drag = this.drag;

    if (drag == null) return;

    final geometry = BoardGeometry(size.shortestSide);
    final preview = drag.preview;
    final colour = DSGameColor.pieces[drag.colorIndex];

    for (final cell in drag.held) {
      _outline(
        canvas,
        geometry,
        cell,
        DSColor.white.withValues(alpha: _heldAlpha),
      );
    }

    for (final cell in _clearingCells(preview)) {
      _outline(canvas, geometry, cell, DSGameColor.clearingOutline);
    }

    for (final cell in preview.cells) {
      final rect = RRect.fromRectAndRadius(
        geometry.cellRect(cell),
        _cellRadius,
      );

      if (preview.fits) {
        canvas.drawRRect(
          rect,
          Paint()..color = colour.withValues(alpha: _shadowAlpha),
        );
        _outline(canvas, geometry, cell, colour);
      } else {
        final fill = preview.colliding.contains(cell)
            ? DSGameColor.collision
            : DSGameColor.collision.withValues(alpha: _strayAlpha);
        canvas.drawRRect(rect, Paint()..color = fill);
        _outline(canvas, geometry, cell, DSGameColor.collisionOutline);
      }
    }
  }

  @override
  bool shouldRepaint(PreviewPainter oldDelegate) => oldDelegate.drag != drag;

  Iterable<Cell> _clearingCells(PlacementPreview preview) => {
    for (final row in preview.clearingRows)
      for (var col = 0; col < Board.size; col++) Cell(col: col, row: row),
    for (final col in preview.clearingCols)
      for (var row = 0; row < Board.size; row++) Cell(col: col, row: row),
  }.where((cell) => !preview.cells.contains(cell));

  void _outline(Canvas canvas, BoardGeometry geometry, Cell cell, Color color) {
    final rect = geometry.cellRect(cell).deflate(_outlineWidth / 2);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, _cellRadius),
      Paint()
        ..color = color
        ..style = .stroke
        ..strokeWidth = _outlineWidth,
    );
  }
}
