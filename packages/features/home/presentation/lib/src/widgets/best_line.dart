import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/points_text.dart';
import 'package:l10n_application/l10n_application.dart';

enum HomeMode { daily, practice }

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
        home.best(points: pointsText(context, points)),
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
