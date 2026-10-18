import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shop_domain/src/contracts/entitlement_store.dart';
import 'package:shop_domain/src/providers_di.br.dart' as di;

part 'providers.br.g.dart';

// shop_domain — public providers exposed by this layer.

/// Remove ads' price for this player, or null while the store can't say.
@riverpod
Future<String?> removeAdsPrice(Ref ref) =>
    ref.watch(di.priceOfProvider)(ref.watch(di.removeAdsProductIdProvider));

List<Override> bindProviders({
  required AnalyticsSink Function(Ref ref) analyticsSink,
  required di.BuyProductFun Function(Ref ref) buyProduct,
  required EntitlementStore Function(Ref ref) entitlementStore,
  required di.PriceOfFun Function(Ref ref) priceOf,
  required di.PurchaseUpdatesFun Function(Ref ref) purchaseUpdates,
  required String Function(Ref ref) removeAdsProductId,
  required di.RestorePurchasesFun Function(Ref ref) restorePurchases,
}) => [
  di.analyticsSinkProvider.overrideWith(analyticsSink),
  di.buyProductProvider.overrideWith(buyProduct),
  di.entitlementStoreProvider.overrideWith(entitlementStore),
  di.priceOfProvider.overrideWith(priceOf),
  di.purchaseUpdatesProvider.overrideWith(purchaseUpdates),
  di.removeAdsProductIdProvider.overrideWith(removeAdsProductId),
  di.restorePurchasesProvider.overrideWith(restorePurchases),
];
