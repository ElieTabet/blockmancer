import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/spellbook_card.dart';
import 'package:l10n_application/l10n_application.dart';

/// Every joker as a collectible card, pair by pair: how much of the
/// collection is held and mastered, and a card per joker.
final class SpellbookWidget extends ConsumerWidget {
  const SpellbookWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The rules' pairs, which never change while the app runs.
    final pairCount = ref.watch(
      jokerCollectionProvider.select((collection) => collection.pairs.length),
    );

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: DSColor.primary,
        // The safe area pads the list inside the scroll view, so the cards
        // scroll under the notch and the home indicator.
        body: CustomScrollView(
          slivers: [
            SliverSafeArea(
              sliver: SliverPadding(
                padding: const .all(DSSpace.medium),
                sliver: SliverList.separated(
                  itemCount: pairCount + 1,
                  itemBuilder: (context, index) => index == 0
                      ? const SpellbookHeader()
                      : JokerPairRow(index: index - 1),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: DSSpace.medium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The title and the way out, then how much of the collection is held.
final class SpellbookHeader extends StatelessWidget {
  const SpellbookHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    spacing: DSSpace.small,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              context.t.home.spellbook.title,
              style: DSFont.display(
                const TextStyle(
                  color: DSColor.white,
                  fontSize: 32,
                  fontWeight: .w700,
                ),
              ),
            ),
          ),
          const SpellbookCloseButton(),
        ],
      ),
      const SpellbookProgress(),
      const SizedBox(height: DSSpace.xsmall),
    ],
  );
}

/// "26 / 26 collected" over a bar, and the pairs mastered.
final class SpellbookProgress extends ConsumerWidget {
  const SpellbookProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:collected, :jokers, :mastered, :pairs) = ref.watch(
      spellbookProgressProvider,
    );
    final spellbook = context.t.home.spellbook;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.xsmall,
      children: [
        Text(
          spellbook.collected(count: collected, total: jokers),
          style: const TextStyle(
            color: DSColor.white,
            fontSize: 15,
            fontWeight: .w700,
          ),
        ),
        ClipRRect(
          borderRadius: .circular(DSCornerRadius.small),
          child: LinearProgressIndicator(
            backgroundColor: DSColor.card,
            color: DSColor.accent,
            minHeight: 8,
            value: jokers == 0 ? 0 : collected / jokers,
          ),
        ),
        Row(
          spacing: DSSpace.xxsmall,
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: DSMasteryColor.gold,
              size: 18,
            ),
            Text(
              spellbook.pairsMastered(count: mastered, total: pairs),
              style: const TextStyle(color: DSColor.textMuted, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

final class SpellbookCloseButton extends ConsumerWidget {
  const SpellbookCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSGameIconButton(
    icon: Icons.close_rounded,
    onTap: () => ref.read(homeProvider.notifier).closeSpellbook(context),
    semanticLabel: context.t.home.spellbook.close,
  );
}

/// Pair [index] side by side, linked by a star that glows once both are gold.
final class JokerPairRow extends ConsumerWidget {
  const JokerPairRow({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pair = ref.watch(
      jokerCollectionProvider.select((collection) => collection.pairs[index]),
    );

    return Row(
      children: [
        Expanded(child: SpellbookCard(joker: pair.first)),
        PairLink(index: index),
        Expanded(child: SpellbookCard(joker: pair.second)),
      ],
    );
  }
}

/// The star line between two partners.
final class PairLink extends ConsumerWidget {
  const PairLink({required this.index, super.key});

  static const _width = 40.0;

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mastered = ref.watch(pairMasteredProvider(index));
    final color = mastered ? DSMasteryColor.gold : DSColor.cardBorder;

    return SizedBox(
      width: _width,
      child: Stack(
        alignment: .center,
        children: [
          SizedBox(
            height: 2,
            width: _width,
            child: ColoredBox(color: color),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (mastered)
                  BoxShadow(
                    color: DSMasteryColor.gold.withValues(alpha: 0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Icon(
              Icons.star_rounded,
              color: mastered ? DSMasteryColor.gold : DSColor.textMuted,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
