import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/game_button.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/points_text.dart';
import 'package:game_presentation/src/widgets/run_stars.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// The run's result against this device's best.
final class RunEndSheet extends ConsumerWidget {
  const RunEndSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (won, roundNumber, reachedBoss, total, jokers) = ref.watch(
      gameProvider.select(
        (state) => (
          state.run.phase is WonPhase,
          state.run.roundIndex + 1,
          state.run.round.isBoss,
          state.run.runTotal,
          state.run.jokers,
        ),
      ),
    );
    final end = context.t.game.end;

    final label = won
        ? end.won
        : reachedBoss
        ? end.overBoss
        : end.overRound(index: roundNumber);

    return Column(
      crossAxisAlignment: .start,
      spacing: DSSpace.small,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: DSColor.info,
            fontSize: 12,
            fontWeight: .w700,
            letterSpacing: 1.6,
          ),
        ),
        SheetTitle(end.total(total: pointsText(context, total))),
        const _BestLine(),
        const RunStars(),
        Text(
          end.build(
            jokers: jokers.isEmpty ? end.noJokers : jokerNames(context, jokers),
          ),
          style: const TextStyle(color: DSColor.textMuted, fontSize: 12),
        ),
        GameButton(
          label: end.retry,
          onPressed: ref.read(gameProvider.notifier).retry,
        ),
        const _ReviewMoment(),
      ],
    );
  }
}

/// Draws nothing: once the sheet is in and its new stars have popped, tells
/// the game the run's end has finished celebrating, the one moment a rating
/// may be asked for.
final class _ReviewMoment extends ConsumerStatefulWidget {
  const _ReviewMoment();

  @override
  ConsumerState<_ReviewMoment> createState() => _ReviewMomentState();
}

class _ReviewMomentState extends ConsumerState<_ReviewMoment> {
  Timer? _settled;

  @override
  void initState() {
    super.initState();

    final game = ref.read(gameProvider);
    final newStars = game.progress?.newStars;
    final starsPop =
        newStars != null &&
        (newStars.bossBeaten || newStars.noRevive || newStars.scoreThreshold) &&
        !ref.read(reduceMotionProvider);
    _settled = Timer(
      sheetEntrance + (starsPop ? RunStars.celebration : Duration.zero),
      () => unawaited(ref.read(gameProvider.notifier).celebrated()),
    );
  }

  @override
  void dispose() {
    _settled?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// The mode's best, or that this run is it. Empty while the best is read.
final class _BestLine extends ConsumerWidget {
  const _BestLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(gameProvider.select((state) => state.record));
    final end = context.t.game.end;

    if (record == null) return const SizedBox.shrink();

    return Text(
      record.isNewBest
          ? end.newBest
          : end.best(points: pointsText(context, record.best)),
      style: TextStyle(
        color: record.isNewBest ? DSColor.accent : DSColor.textMuted,
        fontSize: 14,
        fontWeight: .w700,
      ),
    );
  }
}
