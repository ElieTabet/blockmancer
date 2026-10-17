import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

enum SettingsToggle { haptics, reduceMotion, sound }

/// A setting that is on or off. Tapping anywhere on the row flips it.
final class ToggleRow extends ConsumerWidget {
  const ToggleRow({required this.toggle, super.key});

  final SettingsToggle toggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = context.t.settings;
    final (title, subtitle) = switch (toggle) {
      .haptics => (settings.haptics, null),
      .reduceMotion => (
        settings.reduceMotion.title,
        settings.reduceMotion.subtitle,
      ),
      .sound => (settings.sound, null),
    };
    final on = ref.watch(switch (toggle) {
      .haptics => hapticsOnProvider,
      .reduceMotion => reduceMotionOnProvider,
      .sound => soundOnProvider,
    });

    // Read on tap: the notifier holds nothing, so nothing keeps it alive
    // between taps.
    void set(bool value) {
      final notifier = ref.read(settingsStateProvider.notifier);

      switch (toggle) {
        case .haptics:
          notifier.setHaptics(value);
        case .reduceMotion:
          notifier.setReduceMotion(value);
        case .sound:
          notifier.setSound(value);
      }
    }

    // One stop for a screen reader: the name, read with the switch's state.
    return MergeSemantics(
      child: DSPressable(
        onTap: () => set(!on),
        child: SettingsCard(
          child: Row(
            spacing: DSSpace.small,
            children: [
              Expanded(
                child: SettingLabel(title: title, subtitle: subtitle),
              ),
              Switch(
                value: on,
                onChanged: set,
                activeThumbColor: DSColor.primary,
                activeTrackColor: DSColor.accent,
                inactiveThumbColor: DSColor.textMuted,
                inactiveTrackColor: DSColor.sheet,
                trackOutlineColor: const WidgetStatePropertyAll(
                  DSColor.cardBorder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
