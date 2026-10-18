import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/providers_di.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

/// Opens the app's store page, where a rating is always welcome.
final class RateRow extends ConsumerWidget {
  const RateRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rate = context.t.settings.rate;

    return DSPressable(
      onTap: () => ref.read(rateAppProvider)(),
      child: SettingsCard(
        child: SettingLabel(title: rate.title, subtitle: rate.subtitle),
      ),
    );
  }
}
