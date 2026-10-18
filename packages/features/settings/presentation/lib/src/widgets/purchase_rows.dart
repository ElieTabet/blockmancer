import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_presentation/src/providers_di.br.dart';
import 'package:settings_presentation/src/widgets/settings_group.dart';

/// Remove ads with the price the store shows this player, never one of ours;
/// once owned, a row that says so and can't be bought again.
final class RemoveAdsRow extends ConsumerWidget {
  const RemoveAdsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final removeAds = context.t.settings.removeAds;

    if (ref.watch(removeAdsOwnedProvider)) {
      return SettingsRow(
        semanticLabel: removeAds.ownedLabel,
        title: removeAds.owned,
        trailing: const Icon(Icons.check_rounded, color: DSColor.positive),
      );
    }

    final price = ref.watch(
      removeAdsPriceProvider.select((price) => price.value),
    );

    return SettingsRow(
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
      semanticLabel: price == null
          ? removeAds.title
          : removeAds.withPrice(price: price),
      title: removeAds.title,
      trailing: price == null
          ? null
          : Text(
              price,
              style: const TextStyle(
                color: DSColor.accent,
                fontSize: 16,
                fontWeight: .w700,
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

    return SettingsRow(
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
      title: restore.title,
    );
  }
}
