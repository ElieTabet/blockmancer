import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/providers_di.br.dart';
import 'package:settings_presentation/src/widgets/settings_card.dart';

/// Remove ads, with the price the store shows this player; once owned, a
/// thank-you that can't be bought again.
final class RemoveAdsRow extends ConsumerWidget {
  const RemoveAdsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final removeAds = context.t.settings.removeAds;

    if (ref.watch(removeAdsOwnedProvider)) {
      return SettingsCard(
        child: SettingLabel(
          title: removeAds.owned,
          subtitle: removeAds.ownedSubtitle,
        ),
      );
    }

    final price = ref.watch(
      removeAdsPriceProvider.select((price) => price.value),
    );

    return DSPressable(
      onTap: () async {
        final opened = await ref.read(buyRemoveAdsProvider)();

        if (opened || !context.mounted) return;

        await DSPopup.showError(
          context,
          title: removeAds.unavailableTitle,
          message: removeAds.unavailableMessage,
          buttonLabel: removeAds.ok,
        );
      },
      child: SettingsCard(
        child: SettingLabel(
          title: removeAds.title,
          subtitle: price == null
              ? removeAds.subtitleNoPrice
              : removeAds.subtitle(price: price),
        ),
      ),
    );
  }
}

/// Restores what the player bought before (Apple requires it), and says
/// whether anything was found.
final class RestorePurchasesRow extends ConsumerWidget {
  const RestorePurchasesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restore = context.t.settings.restore;

    return DSPressable(
      onTap: () async {
        final restored = await ref.read(restorePurchasesProvider)();

        if (!context.mounted) return;

        await DSPopup.showInfo(
          context,
          title: restored ? restore.restoredTitle : restore.noneTitle,
          message: restored ? restore.restoredMessage : restore.noneMessage,
          buttonLabel: restore.ok,
        );
      },
      child: SettingsCard(
        child: SettingLabel(title: restore.title, subtitle: restore.subtitle),
      ),
    );
  }
}
