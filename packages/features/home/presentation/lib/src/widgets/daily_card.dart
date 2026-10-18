import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/best_line.dart';
import 'package:home_presentation/src/widgets/home_card.dart';
import 'package:intl/intl.dart';
import 'package:l10n_application/l10n_application.dart';

/// Today's daily run: its day, today's best, a way in, and its leaderboard.
final class DailyCard extends ConsumerWidget {
  const DailyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daily = context.t.home.daily;

    return HomeCard(
      accent: DSColor.accent,
      // Read on tap: the notifier holds nothing, so nothing keeps it alive
      // between taps.
      onTap: () => ref.read(homeProvider.notifier).openDaily(context),
      child: Row(
        spacing: DSSpace.small,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: DSSpace.xxsmall,
              children: [
                const DailyDate(),
                Text(
                  daily.title,
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.white,
                      fontSize: 22,
                      fontWeight: .w600,
                    ),
                  ),
                ),
                Text(
                  daily.subtitle,
                  style: const TextStyle(
                    color: DSColor.textMuted,
                    fontSize: 13,
                  ),
                ),
                const BestLine(mode: .daily),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: .end,
            spacing: DSSpace.xsmall,
            children: [_PlayPill(), LeaderboardButton()],
          ),
        ],
      ),
    );
  }
}

/// The day of today's daily run, in the reader's language. The run's own UTC
/// day, which is the one its pieces and its best belong to.
final class DailyDate extends ConsumerWidget {
  const DailyDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dailyDateProvider);

    return Text(
      DateFormat.MMMMEEEEd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(date),
      style: const TextStyle(
        color: DSColor.accent,
        fontSize: 12,
        fontWeight: .w700,
      ),
    );
  }
}

final class _PlayPill extends StatelessWidget {
  const _PlayPill();

  @override
  Widget build(BuildContext context) => Container(
    padding: const .fromLTRB(
      DSSpace.small,
      DSSpace.xsmall,
      DSSpace.medium,
      DSSpace.xsmall,
    ),
    decoration: const ShapeDecoration(
      color: DSColor.accent,
      shape: StadiumBorder(),
    ),
    child: Row(
      mainAxisSize: .min,
      spacing: DSSpace.xxsmall,
      children: [
        const Icon(Icons.play_arrow_rounded, color: DSColor.primary, size: 22),
        Text(
          context.t.home.daily.play,
          style: DSFont.display(
            const TextStyle(
              color: DSColor.primary,
              fontSize: 17,
              fontWeight: .w700,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Today's leaderboard, a tap target of its own inside the card: tapping it
/// opens the board, not the run.
final class LeaderboardButton extends ConsumerWidget {
  const LeaderboardButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSPressable(
    onTap: () => ref.read(showDailyLeaderboardProvider)(),
    child: Padding(
      // A finger-sized target around a small label.
      padding: const .symmetric(vertical: DSSpace.xsmall),
      child: Row(
        mainAxisSize: .min,
        spacing: DSSpace.xxsmall,
        children: [
          const Icon(
            Icons.leaderboard_rounded,
            color: DSColor.accent,
            size: 18,
          ),
          Text(
            context.t.home.daily.leaderboard,
            style: const TextStyle(
              color: DSColor.accent,
              fontSize: 13,
              fontWeight: .w700,
            ),
          ),
        ],
      ),
    ),
  );
}
