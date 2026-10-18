import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/providers_di.br.dart';
import 'package:settings_presentation/src/widgets/settings_group.dart';

/// Plays the guided first run again.
final class HowToPlayRow extends ConsumerWidget {
  const HowToPlayRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    link: .inApp,
    onTap: () =>
        ref.read(settingsStateProvider.notifier).replayTutorial(context),
    title: context.t.settings.tutorial,
  );
}

final class SupportRow extends ConsumerWidget {
  const SupportRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    link: .outside,
    onTap: () => ref.read(settingsStateProvider.notifier).openSupport(),
    title: context.t.settings.support,
  );
}

/// Opens a mail draft to the team. With no mail app, shows the address to
/// write to instead.
final class SendFeedbackRow extends ConsumerWidget {
  const SendFeedbackRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedback = context.t.settings.feedback;

    return SettingsRow(
      link: .outside,
      onTap: () async {
        final opened = await ref
            .read(settingsStateProvider.notifier)
            .sendFeedback();

        if (opened || !context.mounted) return;

        await DSPopup.showError(
          context,
          title: feedback.unavailableTitle,
          message: feedback.unavailableMessage(address: feedbackAddress),
          buttonLabel: feedback.ok,
        );
      },
      title: feedback.title,
    );
  }
}

/// Opens the app's store page, where a rating is always welcome.
final class RateRow extends ConsumerWidget {
  const RateRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    link: .outside,
    onTap: () => ref.read(rateAppProvider)(),
    title: context.t.settings.rate,
  );
}
