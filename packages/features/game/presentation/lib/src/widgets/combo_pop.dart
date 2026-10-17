import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:l10n_application/l10n_application.dart';

/// "Combo ×N" popping over the board on a long streak, then fading. It plays
/// on past its beat: the score counts up beside it.
final class ComboPop extends ConsumerStatefulWidget {
  const ComboPop({super.key});

  @override
  ConsumerState<ComboPop> createState() => _ComboPopState();
}

class _ComboPopState extends ConsumerState<ComboPop>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: _shown);
  late final _opacity = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 45),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
  ]).animate(_controller);
  late final _scale = Tween(begin: 0.6, end: 1.0)
      .chain(
        CurveTween(curve: const Interval(0, 0.3, curve: Curves.easeOutBack)),
      )
      .animate(_controller);
  static const _shown = Duration(milliseconds: 700);
  int? _streak;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      playbackProvider.select(
        (playback) => switch (playback.beat) {
          ComboBeat(:final streak) => (playback.step, streak),
          _ => null,
        },
      ),
      (_, next) {
        if (next == null) return;

        setState(() => _streak = next.$2);
        _controller.forward(from: 0);
      },
    );

    final streak = _streak;

    if (streak == null) return const SizedBox.shrink();

    final text = RepaintBoundary(
      child: Text(
        context.t.game.round.combo(streak: streak),
        style: DSFont.display(
          const TextStyle(
            color: DSColor.accent,
            fontSize: 40,
            fontWeight: .w700,
            shadows: [Shadow(blurRadius: 12)],
          ),
        ),
      ),
    );

    return IgnorePointer(
      child: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: ref.watch(reduceMotionProvider)
              ? text
              : ScaleTransition(scale: _scale, child: text),
        ),
      ),
    );
  }
}
