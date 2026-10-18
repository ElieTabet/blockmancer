import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';

/// "Blockmancer 1.0.0": the version the player runs, without the build (the
/// feedback email carries that). Empty until read.
final class SettingsFooter extends ConsumerWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(
      appDetailsProvider.select((details) => details.value?.version),
    );

    if (version == null) return const SizedBox.shrink();

    return Text(
      context.t.settings.footer(version: version),
      textAlign: .center,
      style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
    );
  }
}
