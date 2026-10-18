import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

/// The privacy rows: the consent form reopened, only where the law asks for
/// it, then the privacy policy and support on the studio's site.
final class PrivacyRows extends ConsumerWidget {
  const PrivacyRows({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choicesRequired = ref.watch(privacyChoicesRequiredProvider);

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [
        if (choicesRequired) const PrivacyChoicesRow(),
        const PrivacyPolicyRow(),
        const SupportRow(),
      ],
    );
  }
}

final class PrivacyChoicesRow extends ConsumerWidget {
  const PrivacyChoicesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choices = context.t.settings.privacyChoices;

    return DSPressable(
      onTap: () =>
          ref.read(settingsStateProvider.notifier).showPrivacyChoices(),
      child: SettingsCard(
        child: SettingLabel(title: choices.title, subtitle: choices.subtitle),
      ),
    );
  }
}

final class PrivacyPolicyRow extends ConsumerWidget {
  const PrivacyPolicyRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = context.t.settings.privacyPolicy;

    return DSPressable(
      onTap: () => ref.read(settingsStateProvider.notifier).openPrivacyPolicy(),
      child: SettingsCard(
        child: SettingLabel(title: policy.title, subtitle: policy.subtitle),
      ),
    );
  }
}

final class SupportRow extends ConsumerWidget {
  const SupportRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final support = context.t.settings.support;

    return DSPressable(
      onTap: () => ref.read(settingsStateProvider.notifier).openSupport(),
      child: SettingsCard(
        child: SettingLabel(title: support.title, subtitle: support.subtitle),
      ),
    );
  }
}
