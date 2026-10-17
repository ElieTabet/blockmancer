import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/game_button.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/points_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// The run's result against this device's best. No ranking yet: leaderboards
/// come in a later phase.
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
      ],
    );
  }
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
