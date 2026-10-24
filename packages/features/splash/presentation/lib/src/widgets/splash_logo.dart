import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:assets/assets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:splash_presentation/src/widgets/splash_timeline.dart';

/// The logo: held as the native screen drew it, then a squash, a pop, an
/// overshoot and a settle about the cube's base, a shine across it, and the
/// exit's grow-and-fade. Under reduce motion it only fades out.
final class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  /// The cube's base, which the logo squashes onto and springs from.
  static const _origin = Alignment(0, 0.44);

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion != .full) {
      return FadeTransition(
        opacity: ReverseAnimation(clock.exit),
        child: const _Shined(shine: false),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([clock.intro, clock.exit]),
      builder: (context, child) {
        final pose = _poseAt(
          clock.intro.value * SplashTimeline.intro.inMilliseconds,
        );
        final leaving = Curves.easeIn.transform(clock.exit.value);
        final grow = 1 + 0.25 * leaving;

        return Opacity(
          opacity: 1 - leaving,
          child: Transform(
            alignment: _origin,
            transform: Matrix4.identity()
              ..translateByDouble(0, pose.dy * SplashTimeline.logo, 0, 1)
              ..rotateZ(pose.turn * math.pi / 180)
              ..scaleByDouble(pose.sx * grow, pose.sy * grow, 1, 1),
            child: child,
          ),
        );
      },
      child: const _Shined(shine: true),
    );
  }
}

typedef _Pose = ({double dy, double sx, double sy, double turn});

const _rest = (dy: 0.0, sx: 1.0, sy: 1.0, turn: 0.0);

/// The pose at each key moment, and the curve into it.
const _keys = <(double, _Pose, Curve)>[
  (150, _rest, Curves.linear),
  (300, (dy: 0.04, sx: 1.06, sy: 0.88, turn: 0.0), Curves.easeOut),
  (470, (dy: -0.06, sx: 1.12, sy: 1.16, turn: -4.0), Curves.easeOut),
  (600, (dy: 0.0, sx: 0.97, sy: 0.99, turn: 1.5), Curves.easeInOut),
  (700, _rest, Curves.easeInOut),
];

_Pose _poseAt(double ms) {
  if (ms <= _keys.first.$1 || ms >= _keys.last.$1) return _rest;

  for (var index = 1; index < _keys.length; index++) {
    final (end, to, curve) = _keys[index];

    if (ms > end) continue;

    final (start, from, _) = _keys[index - 1];
    final t = curve.transform((ms - start) / (end - start));

    return (
      dy: lerpDouble(from.dy, to.dy, t)!,
      sx: lerpDouble(from.sx, to.sx, t)!,
      sy: lerpDouble(from.sy, to.sy, t)!,
      turn: lerpDouble(from.turn, to.turn, t)!,
    );
  }

  return _rest;
}

/// The logo with the shine sweeping across it, in the logo's own pixels only
/// (`srcATop`), never the background around it.
final class _Shined extends StatelessWidget {
  const _Shined({required this.shine});

  static final _sweep = SplashTimeline.span(760, 1100, curve: Curves.easeInOut);
  final bool shine;

  @override
  Widget build(BuildContext context) {
    const logo = _Logo();

    if (!shine) return logo;

    final intro = SplashClock.of(context).intro;

    return AnimatedBuilder(
      animation: intro,
      builder: (context, child) => ShaderMask(
        blendMode: .srcATop,
        shaderCallback: (bounds) => _bandAt(
          -0.3 + 1.6 * _sweep.transform(intro.value),
        ).createShader(bounds),
        child: child,
      ),
      child: logo,
    );
  }

  static LinearGradient _bandAt(double at) => LinearGradient(
    begin: .topLeft,
    end: .bottomRight,
    colors: [
      DSColor.white.withValues(alpha: 0),
      DSColor.white.withValues(alpha: 0.6),
      DSColor.white.withValues(alpha: 0),
    ],
    stops: [
      (at - 0.12).clamp(0.0, 1.0),
      at.clamp(0.0, 1.0),
      (at + 0.12).clamp(0.0, 1.0),
    ],
  );
}

final class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) => Assets.images.logo.image(
    width: SplashTimeline.logo,
    height: SplashTimeline.logo,
    errorBuilder: (context, error, stackTrace) =>
        const SizedBox.square(dimension: SplashTimeline.logo),
  );
}
