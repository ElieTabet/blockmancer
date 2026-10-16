import 'package:shared_domain/shared_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/game_palette.dart';
import 'package:l10n_application/l10n_application.dart';

final class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              context.t.game.title,
              style: DSFont.display(
                const TextStyle(
                  color: DSColor.white,
                  fontSize: 26,
                  fontWeight: .w600,
                ),
              ),
            ),
            Text(
              context.t.game.subtitle,
              style: const TextStyle(color: GamePalette.muted, fontSize: 12),
            ),
          ],
        ),
      ),
      const RunTotalChip(),
    ],
  );
}

/// The run total, the round in play included.
final class RunTotalChip extends ConsumerWidget {
  const RunTotalChip({super.key});

  static const _height = 34.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(
      gameProvider.select(
        (state) => switch (state.run.phase) {
          PlayingPhase() ||
          RoundLostPhase() => state.run.runTotal + state.run.score,
          _ => state.run.runTotal,
        },
      ),
    );

    return Container(
      height: _height,
      padding: const .symmetric(horizontal: DSSpace.small),
      alignment: .center,
      decoration: BoxDecoration(
        color: GamePalette.sheet,
        borderRadius: .circular(_height / 2),
      ),
      child: Text(
        context.t.game.runTotal(total: total),
        style: const TextStyle(
          color: DSColor.white,
          fontSize: 13,
          fontWeight: .w700,
        ),
      ),
    );
  }
}
