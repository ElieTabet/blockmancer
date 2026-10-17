import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

/// Starts the player over, once they have confirmed it.
final class ResetProgressRow extends ConsumerWidget {
  const ResetProgressRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reset = context.t.settings.reset;

    return DSPressable(
      onTap: () async {
        final confirmed = await DSPopup.showConfirm(
          context,
          title: reset.confirmTitle,
          message: reset.confirmMessage,
          confirmLabel: reset.confirm,
          cancelLabel: reset.cancel,
          isDestructive: true,
        );

        if (!confirmed || !context.mounted) return;

        await ref.read(settingsStateProvider.notifier).resetProgress();
      },
      child: SettingsCard(
        child: SettingLabel(
          title: reset.title,
          color: DSColor.negative,
          subtitle: reset.subtitle,
        ),
      ),
    );
  }
}
