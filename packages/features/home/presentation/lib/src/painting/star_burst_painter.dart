import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';

/// Short rays flying out of a star as it fills, fading as they go.
final class StarBurstPainter extends CustomPainter {
  StarBurstPainter({required this.progress});

  final _paint = Paint()
    ..strokeCap = .round
    ..strokeWidth = 2;
  static const _rays = 8;

  /// From 0, the star filling, to 1, the rays gone.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final center = size.center(Offset.zero);
    final reach = size.shortestSide * (0.4 + 0.5 * progress);
    final length = size.shortestSide * 0.18 * (1 - progress);

    _paint.color = DSColor.accent.withValues(alpha: 1 - progress);

    for (var ray = 0; ray < _rays; ray++) {
      final direction = Offset.fromDirection(ray * 2 * pi / _rays);
      canvas.drawLine(
        center + direction * reach,
        center + direction * (reach + length),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(StarBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
