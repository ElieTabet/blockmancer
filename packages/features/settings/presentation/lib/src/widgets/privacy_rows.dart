import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/notifiers/settings_state_notifier.br.dart';
import 'package:settings_presentation/src/widgets/settings_group.dart';

/// The consent form reopened, only where the law asks for it, then the
/// privacy policy and the legal notice on the studio's site.
final class PrivacySection extends ConsumerWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSection(
    kind: .privacy,
    rows: [
      if (ref.watch(privacyChoicesRequiredProvider)) const PrivacyChoicesRow(),
      const PrivacyPolicyRow(),
      const LegalNoticeRow(),
    ],
  );
}

final class PrivacyChoicesRow extends ConsumerWidget {
  const PrivacyChoicesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    link: .inApp,
    onTap: () => ref.read(settingsStateProvider.notifier).showPrivacyChoices(),
    title: context.t.settings.privacyChoices,
  );
}

final class PrivacyPolicyRow extends ConsumerWidget {
  const PrivacyPolicyRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    link: .outside,
    onTap: () => ref.read(settingsStateProvider.notifier).openPrivacyPolicy(),
    title: context.t.settings.privacyPolicy,
  );
}

final class LegalNoticeRow extends ConsumerWidget {
  const LegalNoticeRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    link: .outside,
    onTap: () => ref.read(settingsStateProvider.notifier).openLegalNotice(),
    title: context.t.settings.legalNotice,
  );
}
