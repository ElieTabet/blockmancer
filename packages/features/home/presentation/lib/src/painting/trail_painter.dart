import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:home_presentation/src/painting/map_geometry.dart';

/// A dashed trail curving from each world's badge to the next, amber as far
/// as the player has walked it.
final class TrailPainter extends CustomPainter {
  TrailPainter({required this.count, required this.walked, this.drawn = 1});

  static const _dash = 10.0;
  static const _gap = 8.0;
  final _paint = Paint()
    ..strokeCap = .round
    ..strokeWidth = 5
    ..style = .stroke;

  final int count;

  /// How much of the last leg walked is amber yet, from 0 to 1: the leg into
  /// a world just opened draws in.
  final double drawn;

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

      final drawing = leg == walked - 1 && drawn < 1;

      _paint.color = leg < walked && !drawing
          ? DSColor.accent
          : DSColor.cardBorder;
      canvas.drawPath(_dashed(path), _paint);

      if (drawing && drawn > 0) {
        _paint.color = DSColor.accent;
        canvas.drawPath(_dashed(_start(path, drawn)), _paint);
      }
    }
  }

  /// The first [share] of [path]'s length.
  Path _start(Path path, double share) {
    final start = Path();

    for (final metric in path.computeMetrics()) {
      start.addPath(metric.extractPath(0, metric.length * share), Offset.zero);
    }

    return start;
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
      oldDelegate.count != count ||
      oldDelegate.drawn != drawn ||
      oldDelegate.walked != walked;
}
