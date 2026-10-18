import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/providers_di.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';
import 'package:settings_presentation/src/widgets/share_test_stats_row.dart';

/// The testers' rows, in a test build only: last, so a release build loses
/// nothing but them.
final class TestToolsRows extends ConsumerWidget {
  const TestToolsRows({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(showsTestToolsProvider)) return const SizedBox.shrink();

    return const Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [ShareTestStatsRow(), TestCrashRow()],
    );
  }
}

/// Crashes the app, to check that crash reports reach Crashlytics.
final class TestCrashRow extends ConsumerWidget {
  const TestCrashRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testCrash = context.t.settings.testCrash;

    return DSPressable(
      onTap: ref.read(crashForTestProvider),
      child: SettingsCard(
        child: SettingLabel(
          title: testCrash.title,
          subtitle: testCrash.subtitle,
        ),
      ),
    );
  }
}
