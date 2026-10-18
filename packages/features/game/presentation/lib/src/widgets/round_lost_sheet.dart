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

/// The revive, and what it does. With Remove ads it is simply "Revive";
/// otherwise it costs a rewarded ad, and while none is loaded it says so and
/// can't be tapped, rather than tapped for nothing.
final class ReviveButton extends ConsumerWidget {
  const ReviveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Until the entitlement is read, the ad is assumed: never a free revive
    // shown and then taken back.
    final needsAd = ref.watch(
      reviveNeedsAdProvider.select((needsAd) => needsAd.value ?? true),
    );
    final adReady = ref.watch(
      rewardedAdReadyProvider.select((ready) => ready.value ?? false),
    );
    final lost = context.t.game.lost;
    final revive = ref.read(gameProvider.notifier).revive;

    return Column(
      spacing: DSSpace.xxsmall,
      children: [
        if (!needsAd)
          GameButton(label: lost.revive, onPressed: revive)
        else if (adReady)
          GameButton(
            icon: Icons.smart_display_rounded,
            label: lost.watchAdToRevive,
            onPressed: revive,
          )
        else
          GameButton(label: lost.reviveUnavailable, onPressed: null),
        const ReviveEffect(),
      ],
    );
  }
}

/// What a revive does: the rows it empties and the pieces it adds.
final class ReviveEffect extends ConsumerWidget {
  const ReviveEffect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (rows, pieces) = ref.watch(
      gameProvider.select(
        (state) => (state.run.config.reviveRows, state.run.config.revivePieces),
      ),
    );

    return Text(
      context.t.game.lost.reviveEffect(pieces: pieces, rows: rows),
      style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
    );
  }
}
