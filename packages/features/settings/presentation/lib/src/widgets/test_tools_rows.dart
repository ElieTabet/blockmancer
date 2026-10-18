import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/providers_di.br.dart';
import 'package:settings_presentation/src/widgets/settings_group.dart';

/// The testers' rows, in a test build only: last, so a release build loses
/// nothing but them.
final class TestersSection extends ConsumerWidget {
  const TestersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(showsTestToolsProvider)) return const SizedBox.shrink();

    return const SettingsSection(
      kind: .testers,
      rows: [ShareTestStatsRow(), TestCrashRow()],
    );
  }
}

/// Opens the share sheet with the testers' play stats, pointing from this row
/// on an iPad. When the sheet doesn't open, says so.
final class ShareTestStatsRow extends ConsumerWidget {
  const ShareTestStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testStats = context.t.settings.testStats;

    return SettingsRow(
      link: .outside,
      onTap: () async {
        final box = context.findRenderObject() as RenderBox?;
        final origin = box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size;
        final opened = await ref
            .read(settingsStateProvider.notifier)
            .shareTestStats(origin: origin);

        if (opened || !context.mounted) return;

        await DSPopup.showError(
          context,
          title: testStats.unavailableTitle,
          message: testStats.unavailableMessage,
          buttonLabel: testStats.ok,
        );
      },
      title: testStats.title,
    );
  }
}

/// Crashes the app, to check that crash reports reach Crashlytics.
final class TestCrashRow extends ConsumerWidget {
  const TestCrashRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    onTap: ref.read(crashForTestProvider),
    title: context.t.settings.testCrash,
    titleColor: DSColor.negative,
  );
}
