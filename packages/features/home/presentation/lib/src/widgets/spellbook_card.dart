import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/joker_sheet.dart';
import 'package:home_presentation/src/widgets/joker_text.dart';
import 'package:home_presentation/src/widgets/points_text.dart';
import 'package:home_presentation/src/widgets/unlock_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// One joker of the collection: in full once unlocked, a silhouette with the
/// way to unlock it until then. A tap opens it in a sheet.
final class SpellbookCard extends ConsumerWidget {
  const SpellbookCard({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(jokerOwnedProvider(joker));

    return DSPressable(
      onTap: () => showJokerSheet(context, joker: joker),
      pressedScale: 0.97,
      child: unlocked
          ? UnlockedJokerCard(joker: joker)
          : LockedJokerCard(joker: joker),
    );
  }
}

final class UnlockedJokerCard extends ConsumerWidget {
  const UnlockedJokerCard({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:traySize, :tuning) = ref.watch(jokerTuningProvider);
    final partner = ref.watch(jokerPartnerProvider(joker));

    return Container(
      padding: const .all(DSSpace.small),
      decoration: ShapeDecoration(
        color: DSColor.jokerSurface,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(DSCornerRadius.large),
          side: const BorderSide(color: DSColor.joker, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: DSSpace.xxsmall,
        children: [
          Text(
            jokerName(context, joker),
            style: DSFont.display(
              const TextStyle(
                color: DSColor.jokerInk,
                fontSize: 16,
                fontWeight: .w600,
              ),
            ),
          ),
          Text(
            jokerDescription(context, joker, tuning, traySize: traySize),
            style: const TextStyle(color: DSColor.textMuted, fontSize: 12),
          ),
          Text(
            context.t.home.spellbook.partner(name: jokerName(context, partner)),
            style: const TextStyle(
              color: DSColor.accent,
              fontSize: 12,
              fontWeight: .w600,
            ),
          ),
          const Spacer(),
          JokerStatLines(joker: joker),
        ],
      ),
    );
  }
}

/// A locked joker's silhouette, and how to unlock it.
final class LockedJokerCard extends ConsumerWidget {
  const LockedJokerCard({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlock = ref.watch(jokerUnlockProvider(joker));

    return Container(
      padding: const .all(DSSpace.small),
      decoration: ShapeDecoration(
        color: DSColor.card,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(DSCornerRadius.large),
          side: const BorderSide(color: DSColor.cardBorder, width: 2),
        ),
      ),
      child: Column(
        mainAxisAlignment: .center,
        spacing: DSSpace.xsmall,
        children: [
          const JokerSilhouette(),
          Text(
            unlockText(context, unlock),
            textAlign: .center,
            style: const TextStyle(
              color: DSColor.white,
              fontSize: 13,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// A joker card's shape with no face: what a locked joker shows.
final class JokerSilhouette extends StatelessWidget {
  const JokerSilhouette({this.size = 56, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size * 0.78,
    height: size,
    decoration: BoxDecoration(
      color: DSColor.primaryDark,
      borderRadius: .circular(DSCornerRadius.medium),
      border: Border.all(color: DSColor.cardBorder, width: 2),
    ),
    child: Icon(
      Icons.lock_rounded,
      color: DSColor.textMuted,
      size: size * 0.4,
      semanticLabel: context.t.home.spellbook.locked,
    ),
  );
}

/// A joker's three stats, one line each.
final class JokerStatLines extends ConsumerWidget {
  const JokerStatLines({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(jokerStatsProvider(joker));
    final spellbook = context.t.home.spellbook;

    return Column(
      spacing: DSSpace.xxxsmall,
      children: [
        StatLine(label: spellbook.picked, value: '${stats.timesPicked}'),
        StatLine(label: spellbook.wins, value: '${stats.runsWon}'),
        StatLine(
          label: spellbook.best,
          value: pointsText(context, stats.bestRunTotal),
        ),
      ],
    );
  }
}

final class StatLine extends StatelessWidget {
  const StatLine({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: const TextStyle(color: DSColor.textMuted, fontSize: 12),
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          color: DSColor.white,
          fontSize: 12,
          fontWeight: .w700,
        ),
      ),
    ],
  );
}
