import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/round_progress_painter.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/points_text.dart';
import 'package:game_presentation/src/widgets/world_text.dart';
import 'package:l10n_application/l10n_application.dart';

/// The round in play: which one, the score against its target, and how many
/// pieces are left.
final class RoundCard extends StatelessWidget {
  const RoundCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const .symmetric(
      horizontal: DSSpace.small,
      vertical: DSSpace.xsmall,
    ),
    decoration: BoxDecoration(
      color: DSColor.card,
      borderRadius: .circular(DSCornerRadius.large),
    ),
    child: const Column(
      spacing: DSSpace.xxsmall,
      children: [
        Row(
          spacing: DSSpace.xsmall,
          children: [
            Expanded(child: RoundTitle()),
            RoundScore(),
          ],
        ),
        RoundProgress(),
        RoundStatus(),
      ],
    ),
  );
}

final class RoundTitle extends ConsumerWidget {
  const RoundTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (index, count, isBoss, world) = ref.watch(
      gameProvider.select(
        (state) => (
          state.run.roundIndex + 1,
          state.run.config.rounds.length,
          state.run.round.isBoss,
          state.run.config.world,
        ),
      ),
    );
    final round = context.t.game.round;

    return Text(
      maxLines: 1,
      overflow: .ellipsis,
      isBoss
          ? round.boss(world: worldName(context, world))
          : round.regular(count: count, index: index),
      style: TextStyle(
        color: isBoss ? DSGameColor.bossRound : DSGameColor.regularRound,
        fontSize: 14,
        fontWeight: .w700,
      ),
    );
  }
}

final class RoundScore extends ConsumerWidget {
  const RoundScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:countUp, :score, :target) = ref.watch(roundScoreShownProvider);

    // The begin is only read on the first build: after that, a new score is
    // counted up to from the one on screen, over its landing.
    return RepaintBoundary(
      child: TweenAnimationBuilder(
        tween: IntTween(begin: score, end: score),
        curve: Curves.easeOutCubic,
        duration: countUp,
        builder: (context, shown, _) => Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${pointsText(context, shown)} ',
                style: DSFont.display(
                  const TextStyle(
                    color: DSColor.white,
                    fontSize: 18,
                    fontWeight: .w700,
                  ),
                ),
              ),
              TextSpan(
                text: context.t.game.round.target(
                  target: pointsText(context, target),
                ),
              ),
            ],
          ),
          style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
        ),
      ),
    );
  }
}

/// The round score against its target. It fills as a move's points land, in
/// step with the score counting up, with a glint along the growing fill, and
/// swells and turns as the target is met.
final class RoundProgress extends ConsumerStatefulWidget {
  const RoundProgress({super.key});

  @override
  ConsumerState<RoundProgress> createState() => _RoundProgressState();
}

typedef _Progress = (double fraction, Duration countUp);

class _RoundProgressState extends ConsumerState<RoundProgress>
    with TickerProviderStateMixin {
  late final _complete = AnimationController(vsync: this, duration: _turning);
  late final _fill = AnimationController(vsync: this);
  static const _height = 8.0;
  late final _pulse = AnimationController(vsync: this, duration: _pulsing);
  static const _pulsing = Duration(milliseconds: 450);
  late final _shine = AnimationController(vsync: this);

  /// What the fill is heading for, which it may not have reached yet.
  var _target = 0.0;
  static const _turning = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _target = ref.read(roundScoreShownProvider.select(_progressOf)).$1;
    _fill.value = _target;
    _complete.value = _target >= 1 ? 1 : 0;
  }

  @override
  void dispose() {
    _complete.dispose();
    _fill.dispose();
    _pulse.dispose();
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      roundScoreShownProvider.select(_progressOf),
      (_, next) => _moveTo(next),
    );

    return RepaintBoundary(
      child: SizedBox(
        height: _height,
        width: double.infinity,
        child: CustomPaint(
          painter: RoundProgressPainter(
            complete: _complete,
            fill: _fill,
            pulse: _pulse,
            shine: _shine,
          ),
        ),
      ),
    );
  }

  void _celebrate() {
    if (!mounted) return;

    _complete.forward();

    if (!ref.read(reduceMotionProvider)) _pulse.forward(from: 0);
  }

  void _moveTo(_Progress progress) {
    final (fraction, countUp) = progress;

    if (fraction == _target) return;

    final completes = fraction >= 1 && _target < 1;
    final grows = fraction > _target && countUp > .zero;

    _target = fraction;

    if (!grows) {
      _fill.value = fraction;
      _complete.value = fraction >= 1 ? 1 : 0;

      return;
    }

    final filled = _fill.animateTo(
      fraction,
      curve: Curves.easeOutCubic,
      duration: countUp,
    );

    if (!ref.read(reduceMotionProvider)) {
      _shine
        ..duration = countUp * 1.5
        ..forward(from: 0);
    }

    if (completes) filled.whenCompleteOrCancel(_celebrate);
  }

  static _Progress _progressOf(RoundScoreShown shown) =>
      ((shown.score / shown.target).clamp(0.0, 1.0), shown.countUp);
}

final class RoundStatus extends ConsumerWidget {
  const RoundStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieces = ref.watch(
      gameProvider.select((state) => state.run.piecesRemaining),
    );
    // Held with the score: the streak a move builds shows once it has landed.
    final (streak, storedMult) = ref.watch(
      shownRunProvider.select((run) => (run.streak, run.storedMult)),
    );
    final round = context.t.game.round;

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          round.piecesLeft(count: pieces),
          style: const TextStyle(color: DSColor.textMuted, fontSize: 12),
        ),
        const TideCountdown(),
        Text(
          [
            if (streak > 1) round.combo(streak: streak),
            if (storedMult > 0) round.storedMult(mult: storedMult),
          ].join(' · '),
          style: const TextStyle(
            color: DSColor.accent,
            fontSize: 12,
            fontWeight: .w700,
          ),
        ),
      ],
    );
  }
}

/// In Tide's boss, how many pieces are left in the tray before the tide
/// rises; nothing in any other round.
final class TideCountdown extends ConsumerWidget {
  const TideCountdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inTray = ref.watch(
      gameProvider.select(
        (state) => state.run.config.world == .tide && state.run.round.isBoss
            ? state.run.tray.whereType<int>().length
            : null,
      ),
    );

    if (inTray == null) return const SizedBox.shrink();

    return Text(
      context.t.game.round.tideIn(count: inTray),
      style: const TextStyle(
        color: DSColor.negative,
        fontSize: 12,
        fontWeight: .w700,
      ),
    );
  }
}
