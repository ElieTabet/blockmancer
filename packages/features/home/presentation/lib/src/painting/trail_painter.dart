import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:home_presentation/src/painting/map_geometry.dart';

/// A dashed trail curving from each world's badge to the next, amber as far
/// as the player has walked it.
final class TrailPainter extends CustomPainter {
  TrailPainter({required this.count, required this.walked});

  static const _dash = 10.0;
  static const _gap = 8.0;
  final _paint = Paint()
    ..strokeCap = .round
    ..strokeWidth = 5
    ..style = .stroke;

  final int count;

  /// The legs walked, from the first world's.
  final int walked;

  @override
  void paint(Canvas canvas, Size size) {
    for (var leg = 0; leg + 1 < count; leg++) {
      final from = MapGeometry.badgeCenterOf(leg, width: size.width);
      final to = MapGeometry.badgeCenterOf(leg + 1, width: size.width);
      // Out of a badge's side and down into the next from above, so it never
      // crosses the name and stars under a badge.
      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..cubicTo(to.dx, from.dy, to.dx, from.dy, to.dx, to.dy);

      _paint.color = leg < walked ? DSColor.accent : DSColor.cardBorder;
      canvas.drawPath(_dashed(path), _paint);
    }
  }

  Path _dashed(Path path) {
    final dashes = Path();

    for (final metric in path.computeMetrics()) {
      for (var at = 0.0; at < metric.length; at += _dash + _gap) {
        dashes.addPath(metric.extractPath(at, at + _dash), Offset.zero);
      }
    }

    return dashes;
  }

  @override
  bool shouldRepaint(TrailPainter oldDelegate) =>
      oldDelegate.count != count || oldDelegate.walked != walked;
}
