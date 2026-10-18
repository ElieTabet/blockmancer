import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';

/// "Blockmancer 1.0.0 (2)": the build the player runs, to quote in a report.
/// Empty until read.
final class SettingsFooter extends ConsumerWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(
      appDetailsProvider.select(
        (details) => switch (details.value) {
          final details? => (build: details.build, version: details.version),
          null => null,
        },
      ),
    );

    if (details == null) return const SizedBox.shrink();

    return Text(
      context.t.settings.footer(build: details.build, version: details.version),
      textAlign: .center,
      style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
    );
  }
}
