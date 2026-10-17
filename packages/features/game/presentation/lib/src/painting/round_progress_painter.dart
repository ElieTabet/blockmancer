import 'dart:math' as math;

import 'package:design_system/design_system.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// The round's progress bar: the track, the fill with a glint sweeping along
/// it as it grows, and a swell and glow as it completes. Each part runs off its
/// own animation, so the bar repaints alone, never the card.
final class RoundProgressPainter extends CustomPainter {
  RoundProgressPainter({
    required this.complete,
    required this.fill,
    required this.pulse,
    required this.shine,
  }) : super(repaint: Listenable.merge([complete, fill, pulse, shine]));

  static const _glow = 8.0;
  final _paint = Paint();

  /// The glint's width, as a share of the bar.
  static const _shineWidth = 0.3;
  static const _swell = 0.35;

  /// 0 while the round is short of its target, easing to 1 once it is met.
  final Animation<double> complete;

  /// The filled share of the bar.
  final Animation<double> fill;
  final Animation<double> pulse;
  final Animation<double> shine;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    final swell = math.sin(pulse.value * math.pi);

    canvas
      ..save()
      ..translate(0, size.height / 2)
      ..scale(1, 1 + _swell * swell)
      ..translate(0, -size.height / 2);

    _paint.color = DSColor.cardBorder;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, radius),
      _paint,
    );

    if (fill.value > 0) {
      final filled = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * fill.value, size.height),
        radius,
      );
      final color = Color.lerp(
        DSColor.accent,
        DSColor.positive,
        complete.value,
      )!;

      if (swell > 0) {
        _paint
          ..color = color.withValues(alpha: swell)
          ..maskFilter = MaskFilter.blur(.normal, _glow * swell);
        canvas.drawRRect(filled, _paint);
        _paint.maskFilter = null;
      }

      _paint.color = color;
      canvas.drawRRect(filled, _paint);

      if (shine.isAnimating) _paintShine(canvas, filled, size);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(RoundProgressPainter oldDelegate) =>
      oldDelegate.complete != complete ||
      oldDelegate.fill != fill ||
      oldDelegate.pulse != pulse ||
      oldDelegate.shine != shine;

  void _paintShine(Canvas canvas, RRect filled, Size size) {
    final band = size.width * _shineWidth;
    final rect = Rect.fromLTWH(
      -band + (filled.width + band) * shine.value,
      0,
      band,
      size.height,
    );

    canvas
      ..save()
      ..clipRRect(filled);
    _paint.shader = LinearGradient(
      colors: [
        DSColor.white.withValues(alpha: 0),
        DSColor.white.withValues(alpha: 0.55),
        DSColor.white.withValues(alpha: 0),
      ],
    ).createShader(rect);
    canvas
      ..drawRect(rect, _paint)
      ..restore();
    _paint.shader = null;
  }
}
