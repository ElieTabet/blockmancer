import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

/// Opens a mail draft to the team. With no mail app, shows the address to
/// write to instead.
final class SendFeedbackRow extends ConsumerWidget {
  const SendFeedbackRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedback = context.t.settings.feedback;

    return DSPressable(
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
      child: SettingsCard(
        child: SettingLabel(title: feedback.title, subtitle: feedback.subtitle),
      ),
    );
  }
}
