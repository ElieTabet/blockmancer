import 'dart:math' as math;

import 'package:design_system/design_system.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:shared_domain/shared_domain.dart';

/// The cells the tutorial's coach points at, in amber. They pulse twice as
/// [pulse] runs, then stay lit, so nothing keeps animating while the player
/// reads.
final class HintPainter extends CustomPainter {
  HintPainter({required this.cells, required this.pulse})
    : super(repaint: pulse);

  static const _cellRadius = Radius.circular(6);
  static const _fillAlpha = 0.35;
  static const _outlineWidth = 2.5;
  static const _pulses = 2;
  final List<Cell> cells;
  final Animation<double> pulse;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;

    final geometry = BoardGeometry(size.shortestSide);
    final glow = 0.5 + 0.5 * math.cos(pulse.value * 2 * math.pi * _pulses);

    for (final cell in cells) {
      final rect = geometry.cellRect(cell);

      canvas
        ..drawRRect(
          RRect.fromRectAndRadius(rect, _cellRadius),
          Paint()..color = DSColor.accent.withValues(alpha: _fillAlpha * glow),
        )
        ..drawRRect(
          RRect.fromRectAndRadius(rect.deflate(_outlineWidth / 2), _cellRadius),
          Paint()
            ..color = DSColor.accent
            ..style = .stroke
            ..strokeWidth = _outlineWidth,
        );
    }
  }

  @override
  bool shouldRepaint(HintPainter oldDelegate) =>
      oldDelegate.cells != cells || oldDelegate.pulse != pulse;
}
