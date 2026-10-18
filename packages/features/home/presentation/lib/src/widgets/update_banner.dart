import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/home_card.dart';
import 'package:l10n_application/l10n_application.dart';

/// A newer version, when one is out: a tap opens the store, "Not now" closes
/// the banner for that version.
final class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offered = ref.watch(
      updateOfferProvider.select((offer) => offer.value != null),
    );

    // Its own gap below, so nothing is left behind when it's gone.
    return offered
        ? const Padding(
            padding: .only(bottom: DSSpace.small),
            child: _OfferCard(),
          )
        : const SizedBox.shrink();
  }
}

final class _OfferCard extends ConsumerWidget {
  const _OfferCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = context.t.update.banner;

    return HomeCard(
      accent: DSColor.accent,
      onTap: () => ref.read(openStoreListingProvider)(),
      child: Row(
        spacing: DSSpace.small,
        children: [
          Expanded(
            child: Text(
              banner.title,
              style: DSFont.display(
                const TextStyle(
                  color: DSColor.white,
                  fontSize: 18,
                  fontWeight: .w600,
                ),
              ),
            ),
          ),
          DSPressable(
            onTap: () => ref.read(dismissUpdateOfferProvider)(),
            child: Padding(
              padding: const .all(DSSpace.xsmall),
              child: Text(
                banner.close,
                style: const TextStyle(color: DSColor.textMuted, fontSize: 14),
              ),
            ),
          ),
          Text(
            banner.button,
            style: const TextStyle(
              color: DSColor.accent,
              fontSize: 16,
              fontWeight: .w700,
            ),
          ),
        ],
      ),
    );
  }
}
