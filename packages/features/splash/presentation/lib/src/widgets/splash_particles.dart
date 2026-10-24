import 'dart:math' as math;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:splash_presentation/src/widgets/splash_timeline.dart';

/// The burst at the pop: small cubes in the logo's colours flying out with
/// gravity, spin and a fade, and sparkles twinkling around the logo. One
/// painter in its own layer.
final class SplashParticles extends StatelessWidget {
  const SplashParticles({super.key});

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion != .full) return const SizedBox.shrink();

    return Positioned(
      bottom: -SplashTimeline.logo,
      left: -SplashTimeline.logo,
      right: -SplashTimeline.logo,
      top: -SplashTimeline.logo,
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(painter: _BurstPainter(clock.burst)),
        ),
      ),
    );
  }
}

typedef _Cube = ({
  double angle,
  Color color,
  double delay,
  double size,
  double speed,
  double spin,
});

typedef _Sparkle = ({
  double angle,
  Color color,
  double distance,
  double size,
  double start,
});

final class _BurstPainter extends CustomPainter {
  _BurstPainter(this.burst) : super(repaint: burst);

  static final _cubes = _seededCubes();

  /// Logical pixels per second squared, pulling the cubes down.
  static const _gravity = 900.0;
  static const _life = 1.0;
  static final _sparkles = _seededSparkles();
  static const _twinkle = 350.0;

  /// Its own clock, from the pop, so the cubes finish their flight even when
  /// the splash leaves, or holds, before they land.
  final Animation<double> burst;

  @override
  void paint(Canvas canvas, Size size) {
    final ms = burst.value * SplashTimeline.burst.inMilliseconds;
    final centre = size.center(Offset.zero);

    for (final cube in _cubes) {
      final t = (ms - cube.delay) / 1000;

      if (t <= 0 || t >= _life) continue;

      final position =
          centre +
          Offset(math.cos(cube.angle), math.sin(cube.angle)) * cube.speed * t +
          Offset(0, _gravity * t * t / 2);
      final fade = 1 - math.pow(t / _life, 2).toDouble();

      _drawCube(canvas, cube, position, cube.spin * t, fade);
    }

    for (final sparkle in _sparkles) {
      final t = (ms - sparkle.start) / _twinkle;

      if (t <= 0 || t >= 1) continue;

      final position =
          centre +
          Offset(math.cos(sparkle.angle), math.sin(sparkle.angle)) *
              sparkle.distance;

      _drawSparkle(canvas, sparkle, position, math.sin(math.pi * t));
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => burst != oldDelegate.burst;

  static void _drawCube(
    Canvas canvas,
    _Cube cube,
    Offset at,
    double turn,
    double alpha,
  ) {
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, height: cube.size, width: cube.size),
      Radius.circular(cube.size * 0.25),
    );

    canvas
      ..save()
      ..translate(at.dx, at.dy)
      ..rotate(turn)
      ..drawRRect(body, Paint()..color = cube.color.withValues(alpha: alpha))
      ..clipRRect(body)
      ..drawRect(
        Rect.fromLTWH(body.left, body.top, body.width, body.height * 0.35),
        Paint()
          ..color = Color.lerp(
            cube.color,
            DSColor.white,
            0.45,
          )!.withValues(alpha: alpha),
      )
      ..restore();
  }

  static void _drawSparkle(
    Canvas canvas,
    _Sparkle sparkle,
    Offset at,
    double grow,
  ) {
    final reach = sparkle.size * grow;
    final waist = reach * 0.25;
    final star = Path()
      ..moveTo(at.dx, at.dy - reach)
      ..lineTo(at.dx + waist, at.dy - waist)
      ..lineTo(at.dx + reach, at.dy)
      ..lineTo(at.dx + waist, at.dy + waist)
      ..lineTo(at.dx, at.dy + reach)
      ..lineTo(at.dx - waist, at.dy + waist)
      ..lineTo(at.dx - reach, at.dy)
      ..lineTo(at.dx - waist, at.dy - waist)
      ..close();

    canvas.drawPath(
      star,
      Paint()..color = sparkle.color.withValues(alpha: grow),
    );
  }

  /// A fixed seed: every launch, and every test, draws the same burst.
  static List<_Cube> _seededCubes() {
    final random = math.Random(1024);
    const colours = [
      DSLogoColor.blue,
      DSLogoColor.red,
      DSColor.joker,
      DSColor.accent,
    ];
    const count = 26;

    return [
      for (var index = 0; index < count; index++)
        (
          angle:
              2 * math.pi * index / count + (random.nextDouble() - 0.5) * 0.4,
          color: colours[index % colours.length],
          delay: random.nextDouble() * 60,
          size: 7 + random.nextDouble() * 7,
          speed: 260 + random.nextDouble() * 260,
          spin: (random.nextDouble() * 2 - 1) * 7,
        ),
    ];
  }

  static List<_Sparkle> _seededSparkles() {
    final random = math.Random(256);
    const colours = [DSMasteryColor.gold, DSColor.jokerInk];
    const count = 12;

    return [
      for (var index = 0; index < count; index++)
        (
          angle:
              2 * math.pi * index / count + (random.nextDouble() - 0.5) * 0.5,
          color: colours[index % colours.length],
          distance: SplashTimeline.logo * (0.5 + random.nextDouble() * 0.35),
          size: 6 + random.nextDouble() * 7,
          start: random.nextDouble() * 320,
        ),
    ];
  }
}
