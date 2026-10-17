import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/home_card.dart';
import 'package:l10n_application/l10n_application.dart';

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
            child: _ResumeCard(),
          )
        : const SizedBox.shrink();
  }
}

final class _ResumeCard extends ConsumerWidget {
  const _ResumeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = context.t.home.resume;

    return HomeCard(
      accent: DSColor.joker,
      onTap: () => ref.read(homeProvider.notifier).openContinue(context),
      child: Row(
        spacing: DSSpace.small,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: DSSpace.xxsmall,
              children: [
                Text(
                  resume.title,
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.white,
                      fontSize: 22,
                      fontWeight: .w600,
                    ),
                  ),
                ),
                Text(
                  resume.subtitle,
                  style: const TextStyle(
                    color: DSColor.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.play_arrow_rounded, color: DSColor.joker, size: 36),
        ],
      ),
    );
  }
}
