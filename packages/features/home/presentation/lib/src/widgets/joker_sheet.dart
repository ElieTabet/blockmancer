import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/entities/joker_mastery.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/joker_emblem.dart';
import 'package:home_presentation/src/widgets/joker_text.dart';
import 'package:home_presentation/src/widgets/points_text.dart';
import 'package:home_presentation/src/widgets/spellbook_card.dart';
import 'package:home_presentation/src/widgets/unlock_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// Opens [joker] in full over the Spellbook.
Future<void> showJokerSheet(BuildContext context, {required JokerId joker}) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DSColor.sheet,
      barrierColor: DSColor.scrim,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: Radius.circular(28)),
      ),
      builder: (context) => JokerSheet(joker: joker),
    );

/// One joker in full: its card, kind, effect, partner, stats and mastery once
/// unlocked; how to unlock it until then. Its partner opens in its place.
final class JokerSheet extends StatefulWidget {
  const JokerSheet({required this.joker, super.key});

  final JokerId joker;

  @override
  State<JokerSheet> createState() => _JokerSheetState();
}

final class _JokerSheetState extends State<JokerSheet> {
  late var _joker = widget.joker;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const .all(DSSpace.large),
    child: AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      child: JokerDetails(
        key: ValueKey(_joker),
        joker: _joker,
        onPartner: (partner) => setState(() => _joker = partner),
      ),
    ),
  );
}

final class JokerDetails extends ConsumerWidget {
  const JokerDetails({required this.joker, required this.onPartner, super.key});

  final JokerId joker;
  final ValueChanged<JokerId> onPartner;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(jokerOwnedProvider(joker))
      ? UnlockedJokerDetails(joker: joker, onPartner: onPartner)
      : LockedJokerDetails(joker: joker);
}

final class UnlockedJokerDetails extends ConsumerWidget {
  const UnlockedJokerDetails({
    required this.joker,
    required this.onPartner,
    super.key,
  });

  static const _cardWidth = 140.0;

  final JokerId joker;
  final ValueChanged<JokerId> onPartner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:traySize, :tuning) = ref.watch(jokerTuningProvider);
    final partner = ref.watch(jokerPartnerProvider(joker));
    final spellbook = context.t.home.spellbook;

    return Column(
      spacing: DSSpace.small,
      children: [
        JokerCardFace(joker: joker, width: _cardWidth),
        Text(
          jokerName(context, joker),
          textAlign: .center,
          style: DSFont.display(
            const TextStyle(
              color: DSColor.white,
              fontSize: 26,
              fontWeight: .w600,
            ),
          ),
        ),
        JokerKindChip(joker: joker),
        HighlightedNumbers(
          jokerDescription(context, joker, tuning, traySize: traySize),
        ),
        const SizedBox(height: DSSpace.xsmall),
        MasteryProgress(joker: joker),
        SheetSection(
          title: spellbook.statsTitle,
          child: JokerStatLines(joker: joker),
        ),
        SheetSection(
          title: spellbook.partnerTitle,
          child: PartnerTile(joker: partner, onTap: () => onPartner(partner)),
        ),
      ],
    );
  }
}

final class LockedJokerDetails extends ConsumerWidget {
  const LockedJokerDetails({required this.joker, super.key});

  static const _cardWidth = 140.0;

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlock = ref.watch(jokerUnlockProvider(joker));

    return Column(
      spacing: DSSpace.small,
      children: [
        const LockedCardFace(width: _cardWidth),
        Text(
          context.t.home.spellbook.locked,
          style: DSFont.display(
            const TextStyle(
              color: DSColor.textMuted,
              fontSize: 26,
              fontWeight: .w600,
            ),
          ),
        ),
        Text(
          unlockText(context, unlock),
          textAlign: .center,
          style: const TextStyle(
            color: DSColor.white,
            fontSize: 16,
            fontWeight: .w600,
          ),
        ),
      ],
    );
  }
}

/// What the joker does to a score, in its frame's colour.
final class JokerKindChip extends ConsumerWidget {
  const JokerKindChip({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kind = ref.watch(jokerKindProvider(joker));
    final frame = jokerFrameOf(kind);

    return Container(
      padding: const .symmetric(
        horizontal: DSSpace.small,
        vertical: DSSpace.xxsmall,
      ),
      decoration: BoxDecoration(
        color: frame.surface,
        borderRadius: .circular(DSCornerRadius.large),
        border: Border.all(color: frame.edge),
      ),
      child: Text(
        jokerKindName(context, kind),
        style: TextStyle(color: frame.edge, fontSize: 13, fontWeight: .w700),
      ),
    );
  }
}

/// [text] with its numbers picked out, so "×2" and "+500" read at a glance.
final class HighlightedNumbers extends StatelessWidget {
  const HighlightedNumbers(this.text, {super.key});

  // A sign, then digits with the separators a locale puts in them.
  static final _number = RegExp('[+×]?\\d+(?:[.,\\u202F\\u00A0]\\d+)*');

  final String text;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    var start = 0;

    for (final match in _number.allMatches(text)) {
      spans
        ..add(TextSpan(text: text.substring(start, match.start)))
        ..add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(color: DSColor.accent, fontWeight: .w800),
          ),
        );
      start = match.end;
    }

    spans.add(TextSpan(text: text.substring(start)));

    return Text.rich(
      TextSpan(children: spans),
      textAlign: .center,
      style: const TextStyle(color: DSColor.white, fontSize: 16, height: 1.35),
    );
  }
}

/// The joker's tier, and the wins to the next one; "fully mastered" at gold.
final class MasteryProgress extends ConsumerWidget {
  const MasteryProgress({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(jokerTierProvider(joker));
    final wins = ref.watch(
      jokerStatsProvider(joker).select((stats) => stats.runsWon),
    );
    final next = nextMasteryTier(tier, ref.watch(masteryThresholdsProvider));
    final spellbook = context.t.home.spellbook;
    final line = switch (next) {
      null => spellbook.mastered,
      (tier: .bronze, wins: final target) => spellbook.toBronze(
        target: target,
        wins: wins,
      ),
      (tier: .silver, wins: final target) => spellbook.toSilver(
        target: target,
        wins: wins,
      ),
      (tier: _, wins: final target) => spellbook.toGold(
        target: target,
        wins: wins,
      ),
    };

    return Column(
      spacing: DSSpace.xsmall,
      children: [
        Row(
          mainAxisAlignment: .center,
          spacing: DSSpace.xsmall,
          children: [
            MasteryDots(joker: joker, size: 12),
            Text(
              masteryTierName(context, tier),
              style: const TextStyle(
                color: DSColor.white,
                fontSize: 15,
                fontWeight: .w700,
              ),
            ),
          ],
        ),
        Text(
          line,
          style: const TextStyle(color: DSColor.textMuted, fontSize: 14),
        ),
        if (next != null)
          ClipRRect(
            borderRadius: .circular(DSCornerRadius.small),
            child: LinearProgressIndicator(
              backgroundColor: DSColor.card,
              color: DSColor.accent,
              minHeight: 6,
              value: (wins / next.wins).clamp(0, 1),
            ),
          ),
      ],
    );
  }
}

/// A titled block of the sheet.
final class SheetSection extends StatelessWidget {
  const SheetSection({required this.child, required this.title, super.key});

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    spacing: DSSpace.xsmall,
    children: [
      const SizedBox(height: DSSpace.xsmall),
      Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: DSColor.textMuted,
          fontSize: 12,
          fontWeight: .w700,
          letterSpacing: 0.8,
        ),
      ),
      child,
    ],
  );
}

/// The partner, small: a tap opens it in this sheet's place.
final class PartnerTile extends ConsumerWidget {
  const PartnerTile({required this.joker, required this.onTap, super.key});

  static const _cardWidth = 56.0;

  final JokerId joker;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(jokerOwnedProvider(joker));
    final name = unlocked
        ? jokerName(context, joker)
        : context.t.home.spellbook.unknownName;

    return DSPressable(
      onTap: onTap,
      pressedScale: 0.97,
      semanticLabel: name,
      child: ExcludeSemantics(
        child: Row(
          spacing: DSSpace.small,
          children: [
            if (unlocked)
              JokerCardFace(joker: joker, width: _cardWidth)
            else
              const LockedCardFace(width: _cardWidth),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: DSColor.white,
                  fontSize: 16,
                  fontWeight: .w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: DSColor.textMuted),
          ],
        ),
      ),
    );
  }
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
      spacing: DSSpace.xxsmall,
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
          style: const TextStyle(color: DSColor.textMuted, fontSize: 14),
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          color: DSColor.white,
          fontSize: 14,
          fontWeight: .w700,
        ),
      ),
    ],
  );
}
