import 'dart:ui' show lerpDouble;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:splash_presentation/src/widgets/splash_timeline.dart';

/// "BLOCKMANCER" under the logo, "MANCER" in amber: each letter drops in
/// with a bounce, one after the other, then the word fades out moving down
/// as the splash leaves. Under reduce motion it fades in, then out.
final class SplashWordmark extends StatelessWidget {
  const SplashWordmark({super.key});

  static const _amber = 'MANCER';
  static const _light = 'BLOCK';

  @override
  Widget build(BuildContext context) {
    final clock = SplashClock.of(context);

    if (clock.motion == .waiting) return const SizedBox.shrink();

    final still = clock.motion == .still;
    final letters = [
      for (final (index, letter) in _light.split('').indexed)
        _Letter(index: index, letter: letter, still: still),
      for (final (index, letter) in _amber.split('').indexed)
        _Letter(
          amber: true,
          index: _light.length + index,
          letter: letter,
          still: still,
        ),
    ];

    return Positioned(
      left: -SplashTimeline.logo,
      right: -SplashTimeline.logo,
      // Just under the starburst, which leaves a margin inside the square.
      top: SplashTimeline.logo * 0.9,
      child: AnimatedBuilder(
        animation: Listenable.merge([clock.intro, clock.exit]),
        builder: (context, child) {
          final leaving = still
              ? clock.exit.value
              : Curves.easeIn.transform(
                  (clock.exit.value / 0.8).clamp(0.0, 1.0),
                );
          // Under reduce motion, faded in from the start rather than dropped.
          final arriving = still ? clock.intro.value : 1.0;

          return Opacity(
            opacity: arriving * (1 - leaving),
            child: Transform.translate(
              offset: Offset(0, still ? 0 : 8 * leaving),
              child: child,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: letters,
        ),
      ),
    );
  }
}

final class _Letter extends StatelessWidget {
  const _Letter({
    required this.index,
    required this.letter,
    required this.still,
    this.amber = false,
  });

  static const _drop = 280.0;
  static const _first = 620.0;
  static const _gap = 38.0;
  final bool amber;
  final int index;
  final String letter;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      letter,
      style: DSFont.display(
        TextStyle(
          color: amber ? DSColor.accent : DSColor.white,
          fontSize: 38,
          fontWeight: .w700,
          height: 1,
          letterSpacing: 1,
          shadows: [
            Shadow(
              color: DSColor.primaryDark.withValues(alpha: 0.8),
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );

    if (still) return text;

    final intro = SplashClock.of(context).intro;
    final start = _first + _gap * index;

    return AnimatedBuilder(
      animation: intro,
      builder: (context, child) {
        final t =
            ((intro.value * SplashTimeline.intro.inMilliseconds - start) /
                    _drop)
                .clamp(0.0, 1.0);
        final (dy, scale) = _dropAt(t);

        return Opacity(
          opacity: (t / 0.35).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: text,
    );
  }

  /// From −26 px at 0.6 to +4 px at 1.08, then settled.
  static (double, double) _dropAt(double t) {
    if (t < 0.6) {
      final eased = Curves.easeOut.transform(t / 0.6);

      return (lerpDouble(-26, 4, eased)!, lerpDouble(0.6, 1.08, eased)!);
    }

    final eased = Curves.easeInOut.transform((t - 0.6) / 0.4);

    return (lerpDouble(4, 0, eased)!, lerpDouble(1.08, 1, eased)!);
  }
}
