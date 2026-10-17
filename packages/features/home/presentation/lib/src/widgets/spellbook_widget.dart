import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/spellbook_card.dart';
import 'package:l10n_application/l10n_application.dart';

/// Every joker, pair by pair: what the unlocked ones do and how they played,
/// and how to unlock the rest.
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
                      const SizedBox(height: DSSpace.small),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The title, how many jokers are unlocked, and the way out.
final class SpellbookHeader extends StatelessWidget {
  const SpellbookHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: .start,
          spacing: DSSpace.xxxsmall,
          children: [
            Text(
              context.t.home.spellbook.title,
              style: DSFont.display(
                const TextStyle(
                  color: DSColor.white,
                  fontSize: 32,
                  fontWeight: .w700,
                ),
              ),
            ),
            const SpellbookProgress(),
          ],
        ),
      ),
      const SpellbookCloseButton(),
    ],
  );
}

final class SpellbookProgress extends ConsumerWidget {
  const SpellbookProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:total, :unlocked) = ref.watch(spellbookProgressProvider);

    return Text(
      context.t.home.spellbook.progress(total: total, unlocked: unlocked),
      style: const TextStyle(color: DSColor.textMuted, fontSize: 14),
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

/// Pair [index] side by side, linked by a star.
final class JokerPairRow extends ConsumerWidget {
  const JokerPairRow({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pair = ref.watch(
      jokerCollectionProvider.select((collection) => collection.pairs[index]),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: SpellbookCard(joker: pair.first)),
          const PairLink(),
          Expanded(child: SpellbookCard(joker: pair.second)),
        ],
      ),
    );
  }
}

/// The star line that joins two partners.
final class PairLink extends StatelessWidget {
  const PairLink({super.key});

  static const _width = 22.0;

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: _width,
    child: Stack(
      alignment: .center,
      children: [
        SizedBox(
          height: 2,
          width: _width,
          child: ColoredBox(color: DSColor.accent),
        ),
        Icon(Icons.star_rounded, color: DSColor.accent, size: 18),
      ],
    ),
  );
}
