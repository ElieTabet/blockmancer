import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// The starting pick, and the pick after every round but the boss.
final class JokerOfferSheet extends ConsumerWidget {
  const JokerOfferSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(
      gameProvider.select(
        (state) => switch (state.run.phase) {
          PickingJokerPhase(:final offers) => offers,
          _ => const <JokerId>[],
        },
      ),
    );

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [
        const _OfferHeading(),
        const _BuildLine(),
        for (final id in offers) JokerOfferCard(id: id),
      ],
    );
  }
}

final class _OfferHeading extends ConsumerWidget {
  const _OfferHeading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (isStart, saverBonus, nextIndex, nextTarget, nextIsBoss) = ref.watch(
      gameProvider.select((state) {
        // Still selected for a frame after the last pick, when the next round
        // has started and pickIndex is past the final round.
        final next = state.run.config.rounds.elementAtOrNull(
          state.run.pickIndex,
        );

        return (
          state.run.pickIndex == 0,
          state.lastEvents.whereType<RoundWon>().firstOrNull?.bonus ?? 0,
          state.run.pickIndex + 1,
          next?.target ?? 0,
          next?.isBoss ?? false,
        );
      }),
    );
    final offers = context.t.game.offers;

    final title = isStart
        ? offers.startTitle
        : [
            offers.roundTitle,
            if (saverBonus > 0) offers.saverBonus(points: saverBonus),
          ].join(' ');

    final subtitle = isStart
        ? offers.startSubtitle
        : nextIsBoss
        ? offers.nextBoss(target: nextTarget)
        : offers.nextRound(index: nextIndex, target: nextTarget);

    return Column(
      crossAxisAlignment: .start,
      spacing: DSSpace.xxsmall,
      children: [
        SheetTitle(title),
        Text(
          subtitle,
          style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}

final class _BuildLine extends ConsumerWidget {
  const _BuildLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokers = ref.watch(gameProvider.select((state) => state.run.jokers));

    if (jokers.isEmpty) return const SizedBox.shrink();

    return Text(
      context.t.game.offers.build(jokers: jokerNames(context, jokers)),
      style: const TextStyle(color: DSColor.textMuted, fontSize: 12),
    );
  }
}

/// One offered joker. Amber when taking it completes a pair.
final class JokerOfferCard extends ConsumerWidget {
  const JokerOfferCard({required this.id, super.key});

  final JokerId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partner = ref.watch(gameRulesProvider).partnerOf(id);
    final completesPair = ref.watch(
      gameProvider.select((state) => state.run.jokers.contains(partner)),
    );
    final text = jokerText(context, id);
    final offers = context.t.game.offers;
    final partnerName = jokerText(context, partner).name;

    return DSPressable(
      onTap: () => ref.read(gameProvider.notifier).pickJoker(id),
      child: Container(
        padding: const .all(DSSpace.small),
        decoration: ShapeDecoration(
          color: DSColor.jokerSurface,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(DSCornerRadius.large),
            side: BorderSide(
              color: completesPair ? DSColor.accent : DSColor.joker,
              width: 2,
            ),
          ),
        ),
        child: Row(
          spacing: DSSpace.small,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: DSSpace.xxxsmall,
                children: [
                  Text(
                    text.name,
                    style: DSFont.display(
                      const TextStyle(
                        color: DSColor.jokerInk,
                        fontSize: 17,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                  Text(
                    text.description,
                    style: const TextStyle(
                      color: DSColor.textMuted,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    completesPair
                        ? offers.completesPair(joker: partnerName)
                        : offers.pairsWith(joker: partnerName),
                    style: TextStyle(
                      color: completesPair ? DSColor.accent : DSColor.textMuted,
                      fontSize: 12,
                      fontWeight: .w700,
                    ),
                  ),
                ],
              ),
            ),
            _TakeLabel(label: offers.take),
          ],
        ),
      ),
    );
  }
}

final class _TakeLabel extends StatelessWidget {
  const _TakeLabel({required this.label});

  static const _height = 36.0;

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    height: _height,
    padding: const .symmetric(horizontal: DSSpace.small),
    alignment: .center,
    decoration: BoxDecoration(
      color: DSColor.joker,
      borderRadius: .circular(DSCornerRadius.intermediate),
    ),
    child: Text(
      label,
      style: const TextStyle(color: DSColor.primary, fontWeight: .w700),
    ),
  );
}
