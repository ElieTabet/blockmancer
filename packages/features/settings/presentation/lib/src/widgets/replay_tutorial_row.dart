import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

/// Plays the guided first run again.
final class ReplayTutorialRow extends ConsumerWidget {
  const ReplayTutorialRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorial = context.t.settings.tutorial;

    return DSPressable(
      onTap: () =>
          ref.read(settingsStateProvider.notifier).replayTutorial(context),
      child: SettingsCard(
        child: SettingLabel(title: tutorial.title, subtitle: tutorial.subtitle),
      ),
    );
  }
}
