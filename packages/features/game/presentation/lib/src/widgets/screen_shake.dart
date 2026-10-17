import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';

/// Shakes [child] sideways when a beat sets off a shake. Reduce motion never
/// sees one: `beatsFor` leaves them out.
final class ScreenShake extends ConsumerStatefulWidget {
  const ScreenShake({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ScreenShake> createState() => _ScreenShakeState();
}

class _ScreenShakeState extends ConsumerState<ScreenShake>
    with SingleTickerProviderStateMixin {
  var _amplitude = 0.0;
  late final _controller = AnimationController(vsync: this);

  static const _light = (amplitude: 4.0, duration: Duration(milliseconds: 250));
  static const _strong = (
    amplitude: 10.0,
    duration: Duration(milliseconds: 450),
  );

  /// Half-swings over a whole shake, whatever its length.
  static const _swings = 7;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      playbackProvider.select(
        (playback) => (
          playback.step,
          switch (playback.beat) {
            ClearingBeat(:final shake) ||
            LandingBeat(:final shake) ||
            PlacingBeat(:final shake) => shake,
            _ => Shake.none,
          },
        ),
      ),
      (_, next) => _shake(next.$2),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final offset =
            _amplitude *
            (1 - progress) *
            math.sin(progress * _swings * math.pi);

        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      // Moves a painted layer rather than repainting the screen every frame.
      child: RepaintBoundary(child: widget.child),
    );
  }

  void _shake(Shake shake) {
    final strength = switch (shake) {
      .light => _light,
      .none => null,
      .strong => _strong,
    };

    if (strength == null) return;

    _amplitude = strength.amplitude;
    _controller
      ..duration = strength.duration
      ..forward(from: 0);
  }
}
