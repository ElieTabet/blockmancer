import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/points_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

enum _Star { bossBeaten, noRevive, scoreThreshold }

/// The world's three stars, each with what earns it, the ones this run earned
/// popping in. Only a world run earns stars, so only its end shows them.
final class RunStars extends ConsumerWidget {
  const RunStars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shown = ref.watch(
      gameProvider.select((state) => state.progress != null),
    );

    if (!shown) return const SizedBox.shrink();

    return const Column(
      crossAxisAlignment: .start,
      spacing: DSSpace.xxsmall,
      children: [
        _StarLine(star: .bossBeaten),
        _StarLine(star: .noRevive),
        _StarLine(star: .scoreThreshold),
      ],
    );
  }
}

final class _StarLine extends ConsumerStatefulWidget {
  const _StarLine({required this.star});

  final _Star star;

  @override
  ConsumerState<_StarLine> createState() => _StarLineState();
}

class _StarLineState extends ConsumerState<_StarLine>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: _pops,
    value: 1,
  );
  static const _pops = Duration(milliseconds: 900);
  // One pop after the other, in the stars' order.
  late final _scale =
      TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.35), weight: 60),
            TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 40),
          ])
          .chain(
            CurveTween(
              curve: Interval(
                widget.star.index * 0.25,
                widget.star.index * 0.25 + 0.5,
                curve: Curves.easeOut,
              ),
            ),
          )
          .animate(_controller);

  @override
  void initState() {
    super.initState();

    ref.listenManual(
      gameProvider.select((state) => _holds(state.progress?.newStars)),
      (_, isNew) {
        if (isNew && !ref.read(reduceMotionProvider)) {
          _controller.forward(from: 0);
        }
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (earned, isNew, threshold) = ref.watch(
      gameProvider.select(
        (state) => (
          _holds(state.progress?.stars),
          _holds(state.progress?.newStars),
          state.run.config.starThreshold,
        ),
      ),
    );
    final stars = context.t.game.end.stars;
    final color = isNew
        ? DSColor.accent
        : earned
        ? DSColor.white
        : DSColor.textMuted;

    return Row(
      spacing: DSSpace.xsmall,
      children: [
        ScaleTransition(
          scale: _scale,
          child: Icon(
            earned ? Icons.star_rounded : Icons.star_outline_rounded,
            color: color,
            size: 22,
            semanticLabel: isNew
                ? stars.newStar
                : earned
                ? stars.earned
                : stars.missing,
          ),
        ),
        Expanded(
          child: Text(switch (widget.star) {
            .bossBeaten => stars.bossBeaten,
            .noRevive => stars.noRevive,
            .scoreThreshold => stars.threshold(
              points: pointsText(context, threshold),
            ),
          }, style: TextStyle(color: color, fontSize: 14, fontWeight: .w600)),
        ),
      ],
    );
  }

  bool _holds(WorldStars? stars) =>
      stars != null &&
      switch (widget.star) {
        .bossBeaten => stars.bossBeaten,
        .noRevive => stars.noRevive,
        .scoreThreshold => stars.scoreThreshold,
      };
}
