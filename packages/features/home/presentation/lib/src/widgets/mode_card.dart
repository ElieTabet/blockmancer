import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:intl/intl.dart';
import 'package:l10n_application/l10n_application.dart';

enum HomeMode { daily, practice }

/// One way to play, with its best on this device. Tapping it starts that run.
final class ModeCard extends ConsumerWidget {
  const ModeCard({required this.mode, super.key});

  final HomeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = context.t.home;
    final (title, subtitle) = switch (mode) {
      .daily => (home.daily.title, home.daily.subtitle),
      .practice => (home.practice.title, home.practice.subtitle),
    };
    final isDaily = mode == .daily;

    return Material(
      color: DSColor.card,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(DSCornerRadius.large),
        side: BorderSide(
          color: isDaily ? DSColor.accent : DSColor.cardBorder,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: .circular(DSCornerRadius.large),
        onTap: () {
          final notifier = ref.read(homeProvider.notifier);

          isDaily
              ? notifier.openDaily(context)
              : notifier.openPractice(context);
        },
        child: Padding(
          padding: const .all(DSSpace.medium),
          child: Row(
            spacing: DSSpace.small,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: DSSpace.xxsmall,
                  children: [
                    Text(
                      title,
                      style: DSFont.display(
                        const TextStyle(
                          color: DSColor.white,
                          fontSize: 22,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: DSColor.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    BestLine(mode: mode),
                  ],
                ),
              ),
              Icon(
                Icons.play_arrow_rounded,
                color: isDaily ? DSColor.accent : DSColor.white,
                size: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The mode's best, or that it hasn't been played. Empty while it is read.
final class BestLine extends ConsumerWidget {
  const BestLine({required this.mode, super.key});

  final HomeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final best = ref.watch(switch (mode) {
      .daily => dailyBestProvider,
      .practice => practiceBestProvider,
    });
    final home = context.t.home;

    return switch (best) {
      AsyncData(value: final points?) => Text(
        home.best(
          points: NumberFormat.decimalPattern(
            Localizations.localeOf(context).toLanguageTag(),
          ).format(points),
        ),
        style: const TextStyle(
          color: DSColor.accent,
          fontSize: 13,
          fontWeight: .w700,
        ),
      ),
      AsyncData() || AsyncError() => Text(
        home.noBest,
        style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
      ),
      AsyncLoading() => const SizedBox.shrink(),
    };
  }
}
