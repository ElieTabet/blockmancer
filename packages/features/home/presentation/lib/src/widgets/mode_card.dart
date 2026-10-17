import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:intl/intl.dart';
import 'package:l10n_application/l10n_application.dart';

enum HomeMode {
  daily,
  practice,

  /// The run saved on this device.
  resume,
}

/// One way to play, with its best on this device. Tapping it opens that run.
final class ModeCard extends ConsumerWidget {
  const ModeCard({required this.mode, super.key});

  final HomeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = context.t.home;
    final (title, subtitle) = switch (mode) {
      .daily => (home.daily.title, home.daily.subtitle),
      .practice => (home.practice.title, home.practice.subtitle),
      .resume => (home.resume.title, home.resume.subtitle),
    };
    final accent = switch (mode) {
      .daily => DSColor.accent,
      .practice => DSColor.white,
      .resume => DSColor.joker,
    };

    return DSPressable(
      // Read on tap: the notifier holds nothing, so nothing keeps it alive
      // between taps.
      onTap: () {
        final notifier = ref.read(homeProvider.notifier);

        switch (mode) {
          case .daily:
            notifier.openDaily(context);
          case .practice:
            notifier.openPractice(context);
          case .resume:
            notifier.openContinue(context);
        }
      },
      child: Container(
        padding: const .all(DSSpace.medium),
        decoration: ShapeDecoration(
          color: DSColor.card,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(DSCornerRadius.large),
            side: BorderSide(
              color: mode == .practice ? DSColor.cardBorder : accent,
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
            Icon(Icons.play_arrow_rounded, color: accent, size: 36),
          ],
        ),
      ),
    );
  }
}

/// The mode's best, or that it hasn't been played. Empty while it is read,
/// and for a saved run, which has none of its own.
final class BestLine extends ConsumerWidget {
  const BestLine({required this.mode, super.key});

  final HomeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = switch (mode) {
      .daily => dailyBestProvider,
      .practice => practiceBestProvider,
      .resume => null,
    };

    if (provider == null) return const SizedBox.shrink();

    final best = ref.watch(provider);
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

/// The saved run, when there is one to pick up.
final class ContinueCard extends ConsumerWidget {
  const ContinueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSavedRun = ref.watch(
      hasSavedRunProvider.select((saved) => saved.value ?? false),
    );

    // Its own gap below, so nothing is left behind when it's gone.
    return hasSavedRun
        ? const Padding(
            padding: .only(bottom: DSSpace.small),
            child: ModeCard(mode: .resume),
          )
        : const SizedBox.shrink();
  }
}
