import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shop_domain/shop_domain.dart' as shop;

/// Listens to the stores from launch, then re-checks what the player owns,
/// so a reinstall gets Remove ads back without asking.
Future<void> startPurchases(ProviderContainer container) async {
  await container.read(shop.removeAdsProvider.future);
  await container.read(shop.removeAdsProvider.notifier).recheck();
}
