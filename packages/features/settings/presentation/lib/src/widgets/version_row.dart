import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

/// The build the player runs, to quote in a report. Read-only.
final class VersionRow extends StatelessWidget {
  const VersionRow({super.key});

  @override
  Widget build(BuildContext context) => SettingsCard(
    child: Row(
      spacing: DSSpace.small,
      children: [
        Expanded(child: SettingLabel(title: context.t.settings.version)),
        const VersionValue(),
      ],
    ),
  );
}

/// "1.0.0 (2)": the version, then the build. Empty until both are read.
final class VersionValue extends ConsumerWidget {
  const VersionValue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(
      appDetailsProvider.select((details) => details.value),
    );

    if (details == null) return const SizedBox.shrink();

    return Text(
      '${details.version} (${details.build})',
      style: const TextStyle(color: DSColor.textMuted, fontSize: 16),
    );
  }
}
