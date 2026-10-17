import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/language_row.dart';
import 'package:settings_presentation/src/widgets/replay_tutorial_row.dart';
import 'package:settings_presentation/src/widgets/reset_progress_row.dart';
import 'package:settings_presentation/src/widgets/send_feedback_row.dart';
import 'package:settings_presentation/src/widgets/toggle_row.dart';
import 'package:settings_presentation/src/widgets/version_row.dart';

/// What the player can change, one row each.
final class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) => const AnnotatedRegion(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: DSColor.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: .all(DSSpace.medium),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: DSSpace.small,
            children: [
              SettingsHeader(),
              SizedBox(height: DSSpace.xsmall),
              ToggleRow(toggle: .sound),
              ToggleRow(toggle: .haptics),
              ToggleRow(toggle: .reduceMotion),
              LanguageRow(),
              ReplayTutorialRow(),
              SendFeedbackRow(),
              ResetProgressRow(),
              VersionRow(),
            ],
          ),
        ),
      ),
    ),
  );
}

/// The title, and the way out at the top right, where a sheet that slid up
/// is closed from.
final class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          context.t.settings.title,
          style: DSFont.display(
            const TextStyle(
              color: DSColor.white,
              fontSize: 32,
              fontWeight: .w700,
            ),
          ),
        ),
      ),
      const SettingsCloseButton(),
    ],
  );
}

final class SettingsCloseButton extends ConsumerWidget {
  const SettingsCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSGameIconButton(
    icon: Icons.close_rounded,
    onTap: () => ref.read(settingsStateProvider.notifier).close(context),
    semanticLabel: context.t.settings.close,
  );
}
