import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

final class LanguageRow extends StatelessWidget {
  const LanguageRow({super.key});

  @override
  Widget build(BuildContext context) => SettingsCard(
    child: Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [
        SettingLabel(title: context.t.settings.language.title),
        const LanguageChoice(),
      ],
    ),
  );
}

/// System, English or French. Empty until the stored choice is known.
final class LanguageChoice extends ConsumerWidget {
  const LanguageChoice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(
      appLanguageProvider.select((language) => language.value),
    );

    if (language == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final names = context.t.settings.language;

    return Theme(
      // The scheme's primary is the brand's dark ground, which a selected
      // segment would vanish into on this screen.
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          onPrimary: DSColor.primary,
          primary: DSColor.accent,
        ),
      ),
      child: DSSegmentedButton<AppLanguage>(
        onSelected: (language) =>
            ref.read(settingsStateProvider.notifier).setLanguage(language),
        segments: {.system: names.system, .en: names.en, .fr: names.fr},
        selected: language,
      ),
    );
  }
}
