import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shop_domain/src/contracts/entitlement_store.dart';

part 'providers_di.br.g.dart';

// shop_domain — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

@riverpod
AnalyticsSink analyticsSink(Ref ref) => throw UnimplementedError(
  'analyticsSinkProvider must be overridden by the composition layer',
);

/// Opens the store's sheet for a product; false when it couldn't open.
typedef BuyProductFun = Future<bool> Function(String productId);

@riverpod
BuyProductFun buyProduct(Ref ref) => throw UnimplementedError(
  'buyProductProvider must be overridden by the composition layer',
);

@riverpod
EntitlementStore entitlementStore(Ref ref) => throw UnimplementedError(
  'entitlementStoreProvider must be overridden by the composition layer',
);

/// A product's price as the store shows it, or null while unreachable.
typedef PriceOfFun = Future<String?> Function(String productId);

@riverpod
PriceOfFun priceOf(Ref ref) => throw UnimplementedError(
  'priceOfProvider must be overridden by the composition layer',
);

/// What the store reports, from launch on: each update, in order.
typedef PurchaseUpdatesFun = Stream<PurchaseUpdate> Function();

@riverpod
PurchaseUpdatesFun purchaseUpdates(Ref ref) => throw UnimplementedError(
  'purchaseUpdatesProvider must be overridden by the composition layer',
);

/// Asks the store for what the player owns; each arrives as restored.
typedef RestorePurchasesFun = Future<void> Function();

@riverpod
RestorePurchasesFun restorePurchases(Ref ref) => throw UnimplementedError(
  'restorePurchasesProvider must be overridden by the composition layer',
);
