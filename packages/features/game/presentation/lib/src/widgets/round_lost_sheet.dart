import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/widgets/game_button.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/points_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// A lost round: revive while the run allows it, or end the run.
final class RoundLostSheet extends ConsumerWidget {
  const RoundLostSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(gameRulesProvider);
    final (reason, score, target, canRevive) = ref.watch(
      gameProvider.select(
        (state) => (
          switch (state.run.phase) {
            RoundLostPhase(:final reason) => reason,
            _ => null,
          },
          state.run.score,
          state.run.round.target,
          rules.canRevive(state.run),
        ),
      ),
    );
    final lost = context.t.game.lost;
    final notifier = ref.read(gameProvider.notifier);

    return Column(
      spacing: DSSpace.small,
      children: [
        SheetTitle(switch (reason) {
          .flooded => lost.flooded,
          .noRoom => lost.noRoom,
          .outOfPieces || null => lost.outOfPieces,
        }, color: DSColor.negative),
        Text(
          lost.progress(
            score: pointsText(context, score),
            target: pointsText(context, target),
          ),
          style: const TextStyle(color: DSColor.textMuted, fontSize: 14),
        ),
        if (canRevive) const ReviveButton(),
        TextButton(
          onPressed: notifier.endRun,
          child: Text(
            lost.endRun,
            style: const TextStyle(
              color: DSColor.textMuted,
              fontSize: 14,
              fontWeight: .w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// The revive, for the rewarded ad it costs: while none is loaded, it says so
/// and can't be tapped, rather than tapped for nothing.
final class ReviveButton extends ConsumerWidget {
  const ReviveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (rows, pieces) = ref.watch(
      gameProvider.select(
        (state) => (state.run.config.reviveRows, state.run.config.revivePieces),
      ),
    );
    final adReady = ref.watch(
      rewardedAdReadyProvider.select((ready) => ready.value ?? false),
    );
    final lost = context.t.game.lost;

    return GameButton(
      label: adReady
          ? lost.revive(pieces: pieces, rows: rows)
          : lost.reviveUnavailable,
      onPressed: adReady ? ref.read(gameProvider.notifier).revive : null,
    );
  }
}
