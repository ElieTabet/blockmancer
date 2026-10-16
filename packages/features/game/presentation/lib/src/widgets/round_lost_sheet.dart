import 'package:shared_domain/shared_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/game_palette.dart';
import 'package:game_presentation/src/widgets/game_button.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:l10n_application/l10n_application.dart';

/// A lost round: revive while the run allows it, or end the run.
final class RoundLostSheet extends ConsumerWidget {
  const RoundLostSheet({super.key});

  static const _lostColor = Color(0xFFFF8A96);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (reason, score, target, canRevive) = ref.watch(
      gameProvider.select(
        (state) => (
          switch (state.run.phase) {
            RoundLostPhase(:final reason) => reason,
            _ => null,
          },
          state.run.score,
          state.run.round.target,
          state.run.canRevive,
        ),
      ),
    );
    final lost = context.t.game.lost;
    final notifier = ref.read(gameProvider.notifier);

    return Column(
      spacing: DSSpace.small,
      children: [
        SheetTitle(
          reason == .noRoom ? lost.noRoom : lost.outOfPieces,
          color: _lostColor,
        ),
        Text(
          lost.progress(score: score, target: target),
          style: const TextStyle(color: GamePalette.muted, fontSize: 14),
        ),
        if (canRevive)
          GameButton(label: lost.revive, onPressed: notifier.revive),
        TextButton(
          onPressed: notifier.endRun,
          child: Text(
            lost.endRun,
            style: const TextStyle(
              color: GamePalette.muted,
              fontSize: 14,
              fontWeight: .w700,
            ),
          ),
        ),
      ],
    );
  }
}
