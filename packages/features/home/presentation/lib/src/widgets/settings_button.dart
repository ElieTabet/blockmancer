import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:l10n_application/l10n_application.dart';

/// Opens Settings. A gear and no text: its label is read to a screen reader
/// only.
final class SettingsButton extends ConsumerWidget {
  const SettingsButton({super.key});

  static const _iconSize = 28.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSPressable(
    onTap: () => ref.read(homeProvider.notifier).openSettings(context),
    semanticLabel: context.t.home.settings,
    child: const SizedBox.square(
      dimension: kMinInteractiveDimension,
      child: Icon(
        Icons.settings_rounded,
        color: DSColor.textMuted,
        size: _iconSize,
      ),
    ),
  );
}
