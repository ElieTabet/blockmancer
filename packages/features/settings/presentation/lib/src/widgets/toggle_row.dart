import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';

enum SettingsToggle { dailyReminder, haptics, reduceMotion, sound }

/// A setting that is on or off. Tapping anywhere on the row flips it.
final class ToggleRow extends ConsumerWidget {
  const ToggleRow({required this.toggle, super.key});

  final SettingsToggle toggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = context.t.settings;
    final title = switch (toggle) {
      .dailyReminder => settings.dailyReminder,
      .haptics => settings.haptics,
      .reduceMotion => settings.reduceMotion,
      .sound => settings.sound,
    };
    final on = ref.watch(switch (toggle) {
      .dailyReminder => dailyReminderOnProvider,
      .haptics => hapticsOnProvider,
      .reduceMotion => reduceMotionOnProvider,
      .sound => soundOnProvider,
    });

    // Read on tap: the notifier holds nothing, so nothing keeps it alive
    // between taps.
    void set(bool value) {
      final notifier = ref.read(settingsStateProvider.notifier);

      switch (toggle) {
        case .dailyReminder:
          notifier.setDailyReminder(value);
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
        pressedScale: 0.98,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const .symmetric(
              horizontal: DSSpace.medium,
              vertical: DSSpace.xxsmall,
            ),
            child: Row(
              spacing: DSSpace.small,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: DSColor.white,
                      fontSize: 16,
                      fontWeight: .w600,
                    ),
                  ),
                ),
                Switch(
                  value: on,
                  onChanged: set,
                  // The whole row is the target, so the switch needn't pad
                  // itself to one: the row keeps the others' height.
                  materialTapTargetSize: .shrinkWrap,
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
      ),
    );
  }
}
