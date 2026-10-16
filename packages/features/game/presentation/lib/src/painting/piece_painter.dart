import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_domain/shared_domain.dart';

/// One piece, its top-left at the canvas origin, in cells of [cellSize] spaced
/// [gap] apart.
final class PiecePainter extends CustomPainter {
  const PiecePainter({
    required this.cellSize,
    required this.gap,
    required this.shape,
    this.opacity = 1,
  });

  final double cellSize;
  final double gap;
  final double opacity;
  final Shape shape;

  static Size sizeOf(
    Shape shape, {
    required double cellSize,
    required double gap,
  }) => Size(
    shape.width * (cellSize + gap) - gap,
    shape.height * (cellSize + gap) - gap,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DSGameColor.pieces[shape.colorIndex].withValues(alpha: opacity);
    final radius = Radius.circular(cellSize / 4);

    for (final cell in shape.cells) {
      final rect = Rect.fromLTWH(
        cell.col * (cellSize + gap),
        cell.row * (cellSize + gap),
        cellSize,
        cellSize,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
    }
  }

  @override
  bool shouldRepaint(PiecePainter oldDelegate) =>
      oldDelegate.shape.id != shape.id ||
      oldDelegate.cellSize != cellSize ||
      oldDelegate.gap != gap ||
      oldDelegate.opacity != opacity;
}
