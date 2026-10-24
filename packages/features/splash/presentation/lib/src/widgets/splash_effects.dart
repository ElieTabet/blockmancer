import 'dart:math' as math;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:splash_presentation/src/widgets/splash_timeline.dart';

/// Laid out over the logo's square, reaching [reach] logo sizes beyond it on
/// every side, centred on it.
final class _AroundLogo extends StatelessWidget {
  const _AroundLogo({required this.child, required this.reach});

  final Widget child;
  final double reach;

  @override
  Widget build(BuildContext context) => Positioned(
    bottom: -reach * SplashTimeline.logo,
    left: -reach * SplashTimeline.logo,
    right: -reach * SplashTimeline.logo,
    top: -reach * SplashTimeline.logo,
    child: child,
  );
}

/// A soft amber-to-purple glow behind the logo: in from 420 ms, at its peak
/// at 560 ms, easing down to an idle breath while held, out with the exit.
final class SplashGlow extends StatelessWidget {
  const SplashGlow({super.key});

  static final _ease = SplashTimeline.span(560, 1300, curve: Curves.easeInOut);
  static const _idleLevel = 0.45;
  static final _rise = SplashTimeline.span(420, 560, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion != .full) return const SizedBox.shrink();

    return _AroundLogo(
      reach: 0.6,
      child: AnimatedBuilder(
        animation: Listenable.merge([clock.intro, clock.idle, clock.exit]),
        builder: (context, child) {
          final intro = clock.intro.value;
          final breath = clock.intro.isCompleted
              ? 0.1 * math.sin(2 * math.pi * clock.idle.value)
              : 0.0;
          final level =
              _rise.transform(intro) -
              (1 - _idleLevel) * _ease.transform(intro) +
              breath;

          return Opacity(
            opacity: (level * (1 - clock.exit.value)).clamp(0.0, 1.0),
            child: child,
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                DSColor.accent.withValues(alpha: 0.55),
                DSColor.joker.withValues(alpha: 0.18),
                DSColor.joker.withValues(alpha: 0),
              ],
              stops: const [0, 0.55, 1],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sixteen amber rays behind the logo, radially faded: in from 440 to
/// 620 ms, turning slowly until the exit, out with it.
final class SplashRays extends StatelessWidget {
  const SplashRays({super.key});

  static final _fadeIn = SplashTimeline.span(440, 620, curve: Curves.easeOut);
  static final _turning = SplashTimeline.span(440, 1300);

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion != .full) return const SizedBox.shrink();

    return _AroundLogo(
      reach: 0.45,
      child: AnimatedBuilder(
        animation: Listenable.merge([clock.intro, clock.idle, clock.exit]),
        builder: (context, child) {
          final intro = clock.intro.value;
          final held = clock.intro.isCompleted
              ? SplashTimeline.idleRaysTurn * clock.idle.value
              : 0.0;
          final degrees =
              SplashTimeline.raysTurn * _turning.transform(intro) + held;

          return Opacity(
            opacity: _fadeIn.transform(intro) * (1 - clock.exit.value),
            child: Transform.rotate(
              angle: degrees * math.pi / 180,
              child: child,
            ),
          );
        },
        child: const RepaintBoundary(
          child: CustomPaint(painter: _RaysPainter()),
        ),
      ),
    );
  }
}

final class _RaysPainter extends CustomPainter {
  const _RaysPainter();

  static const _count = 16;

  /// Each ray's share of its 22.5° step.
  static const _width = 0.24;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          DSColor.accent.withValues(alpha: 0.42),
          DSColor.accent.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: centre, radius: radius));
    final step = 2 * math.pi / _count;
    final half = step * _width / 2;
    final rays = Path();

    for (var index = 0; index < _count; index++) {
      final angle = step * index;

      rays
        ..moveTo(centre.dx, centre.dy)
        ..lineTo(
          centre.dx + radius * math.cos(angle - half),
          centre.dy + radius * math.sin(angle - half),
        )
        ..lineTo(
          centre.dx + radius * math.cos(angle + half),
          centre.dy + radius * math.sin(angle + half),
        )
        ..close();
    }

    canvas.drawPath(rays, paint);
  }

  @override
  bool shouldRepaint(_RaysPainter oldDelegate) => false;
}

/// Two rings spreading from the logo's centre around the pop, amber then
/// purple, each fading as it grows.
final class SplashRings extends StatelessWidget {
  const SplashRings({super.key});

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion != .full) return const SizedBox.shrink();

    return _AroundLogo(
      reach: 1.0,
      child: IgnorePointer(
        child: CustomPaint(painter: _RingsPainter(clock.intro)),
      ),
    );
  }
}

final class _RingsPainter extends CustomPainter {
  _RingsPainter(this.intro) : super(repaint: intro);

  static const _life = 420.0;
  static const _rings = [
    (from: 450.0, color: DSColor.accent, grow: 2.6, width: 4.0),
    (from: 520.0, color: DSColor.joker, grow: 2.2, width: 3.0),
  ];
  final Animation<double> intro;

  @override
  void paint(Canvas canvas, Size size) {
    final ms = intro.value * SplashTimeline.intro.inMilliseconds;
    final centre = size.center(Offset.zero);

    for (final ring in _rings) {
      final t = (ms - ring.from) / _life;

      if (t <= 0 || t >= 1) continue;

      final eased = Curves.easeOut.transform(t);
      final radius =
          SplashTimeline.logo / 2 * (0.4 + (ring.grow - 0.4) * eased);
      final alpha = 1 - t;

      canvas
        ..drawCircle(
          centre,
          radius,
          Paint()
            ..color = ring.color.withValues(alpha: 0.5 * alpha)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
            ..strokeWidth = ring.width * 2.5
            ..style = .stroke,
        )
        ..drawCircle(
          centre,
          radius,
          Paint()
            ..color = ring.color.withValues(alpha: alpha)
            ..strokeWidth = ring.width
            ..style = .stroke,
        );
    }
  }

  @override
  bool shouldRepaint(_RingsPainter oldDelegate) => intro != oldDelegate.intro;
}

/// A white flash over the whole screen at the pop: up to 0.35 in 30 ms, out
/// over 150 ms.
final class SplashFlash extends StatelessWidget {
  const SplashFlash({super.key});

  static final _down = SplashTimeline.span(500, 650, curve: Curves.easeOut);
  static final _up = SplashTimeline.span(470, 500);

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion != .full) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: clock.intro,
        builder: (context, child) {
          final intro = clock.intro.value;

          return Opacity(
            opacity: 0.35 * (_up.transform(intro) - _down.transform(intro)),
            child: child,
          );
        },
        child: const ColoredBox(color: DSColor.white),
      ),
    );
  }
}

/// The whole scene shaken at the pop: ±4 px, settled by 600 ms.
final class SplashShake extends StatelessWidget {
  const SplashShake({required this.child, super.key});

  static const _amplitude = 4.0;
  static const _from = 470.0;
  static const _to = 600.0;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion != .full) return child;

    return AnimatedBuilder(
      animation: clock.intro,
      builder: (context, child) {
        final ms = clock.intro.value * SplashTimeline.intro.inMilliseconds;
        final t = (ms - _from) / (_to - _from);

        // Always wrapped, still or not: unwrapping would rebuild the scene.
        final damping = t <= 0 || t >= 1 ? 0.0 : _amplitude * (1 - t);

        return Transform.translate(
          offset: Offset(
            damping * math.sin(t * math.pi * 7),
            damping * 0.5 * math.sin(t * math.pi * 5),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
