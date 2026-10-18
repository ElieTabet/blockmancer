import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_group.dart';

/// Starts the player over, alone on its card, once they have read what goes
/// and confirmed it.
final class ResetProgressRow extends ConsumerWidget {
  const ResetProgressRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reset = context.t.settings.reset;

    return SettingsGroup(
      rows: [
        SettingsRow(
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
          title: reset.title,
          titleColor: DSColor.negative,
        ),
      ],
    );
  }
}
