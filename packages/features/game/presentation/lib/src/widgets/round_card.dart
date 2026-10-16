import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/game_palette.dart';
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
      color: GamePalette.card,
      borderRadius: .circular(DSCornerRadius.large),
    ),
    child: const Column(
      spacing: DSSpace.xxsmall,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [RoundTitle(), RoundScore()],
        ),
        RoundProgress(),
        RoundStatus(),
      ],
    ),
  );
}

final class RoundTitle extends ConsumerWidget {
  const RoundTitle({super.key});

  static const _bossColor = Color(0xFFFF6B7A);
  static const _roundColor = Color(0xFF5EC8FF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (index, count, isBoss) = ref.watch(
      gameProvider.select(
        (state) => (
          state.run.roundIndex + 1,
          state.run.config.rounds.length,
          state.run.round.isBoss,
        ),
      ),
    );
    final round = context.t.game.round;

    return Text(
      isBoss
          ? round.boss(count: count, index: index)
          : round.regular(count: count, index: index),
      style: TextStyle(
        color: isBoss ? _bossColor : _roundColor,
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
    final (score, target) = ref.watch(
      gameProvider.select((state) => (state.run.score, state.run.round.target)),
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$score ',
            style: DSFont.display(
              const TextStyle(
                color: DSColor.white,
                fontSize: 18,
                fontWeight: .w700,
              ),
            ),
          ),
          TextSpan(text: context.t.game.round.target(target: target)),
        ],
      ),
      style: const TextStyle(color: GamePalette.muted, fontSize: 13),
    );
  }
}

final class RoundProgress extends ConsumerWidget {
  const RoundProgress({super.key});

  static const _height = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(
      gameProvider.select(
        (state) => (state.run.score / state.run.round.target).clamp(0.0, 1.0),
      ),
    );

    return ClipRRect(
      borderRadius: .circular(_height / 2),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: _height,
        backgroundColor: GamePalette.cardBorder,
        color: DSColor.accent,
      ),
    );
  }
}

final class RoundStatus extends ConsumerWidget {
  const RoundStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (pieces, streak, storedMult) = ref.watch(
      gameProvider.select(
        (state) =>
            (state.run.piecesRemaining, state.run.streak, state.run.storedMult),
      ),
    );
    final round = context.t.game.round;

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          round.piecesLeft(count: pieces),
          style: const TextStyle(color: GamePalette.muted, fontSize: 12),
        ),
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
