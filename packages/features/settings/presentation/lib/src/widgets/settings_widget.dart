import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/help_rows.dart';
import 'package:settings_presentation/src/widgets/language_row.dart';
import 'package:settings_presentation/src/widgets/privacy_rows.dart';
import 'package:settings_presentation/src/widgets/purchase_rows.dart';
import 'package:settings_presentation/src/widgets/reset_progress_row.dart';
import 'package:settings_presentation/src/widgets/settings_footer.dart';
import 'package:settings_presentation/src/widgets/settings_group.dart';
import 'package:settings_presentation/src/widgets/test_tools_rows.dart';
import 'package:settings_presentation/src/widgets/toggle_row.dart';

/// What the player can change, in sections of one card each.
final class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) => const AnnotatedRegion(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: DSColor.primary,
      // The safe area pads the content inside the scroll view, so the rows
      // scroll under the notch and the home indicator rather than being cut
      // off at the inset.
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: .all(DSSpace.medium),
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: DSSpace.large,
              children: [
                SettingsHeader(),
                SettingsSection(
                  kind: .game,
                  rows: [
                    ToggleRow(toggle: .sound),
                    ToggleRow(toggle: .haptics),
                    ToggleRow(toggle: .reduceMotion),
                    ToggleRow(toggle: .dailyReminder),
                    LanguageRow(),
                  ],
                ),
                SettingsSection(
                  kind: .purchases,
                  rows: [RemoveAdsRow(), RestorePurchasesRow()],
                ),
                SettingsSection(
                  kind: .help,
                  rows: [
                    HowToPlayRow(),
                    SupportRow(),
                    SendFeedbackRow(),
                    RateRow(),
                  ],
                ),
                PrivacySection(),
                ResetProgressRow(),
                TestersSection(),
                SettingsFooter(),
              ],
            ),
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
