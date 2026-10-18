import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases/src/package_name.dart';
import 'package:purchases/src/purchases.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

/// [Purchases] over the App Store and Google Play (`in_app_purchase`, StoreKit
/// 2 on iOS). Every purchase the store hands over is acknowledged
/// (`completePurchase`), or the store would refund it.
final class StorePurchases implements Purchases {
  StorePurchases({InAppPurchase? store}) : _injected = store;

  final InAppPurchase? _injected;
  final _products = <String, ProductDetails>{};
  StreamController<PurchaseUpdate>? _updates;

  InAppPurchase get _store => _injected ?? InAppPurchase.instance;

  @override
  Stream<PurchaseUpdate> get updates => (_updates ??= _listen()).stream;

  @override
  Future<bool> buy(String productId) async {
    try {
      final product = await _product(productId);

      if (product == null) return false;

      return await _store.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
    } catch (error, stackTrace) {
      _log('Opening the purchase of $productId failed', error, stackTrace);

      return false;
    }
  }

  @override
  Future<String?> priceOf(String productId) async =>
      (await _product(productId))?.price;

  @override
  Future<void> restore() async {
    try {
      if (!await _store.isAvailable()) return;

      await _store.restorePurchases();
    } catch (error, stackTrace) {
      _log('Restoring the purchases failed', error, stackTrace);
    }
  }

  StreamController<PurchaseUpdate> _listen() {
    final updates = StreamController<PurchaseUpdate>.broadcast();

    _store.purchaseStream.listen(
      (purchases) async {
        for (final purchase in purchases) {
          updates.add(_updateOf(purchase));

          if (purchase.pendingCompletePurchase) {
            try {
              await _store.completePurchase(purchase);
            } catch (error, stackTrace) {
              _log(
                'Acknowledging ${purchase.productID} failed',
                error,
                stackTrace,
              );
            }
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) =>
          _log('The purchase stream failed', error, stackTrace),
    );

    return updates;
  }

  Future<ProductDetails?> _product(String productId) async {
    final known = _products[productId];

    if (known != null) return known;

    try {
      if (!await _store.isAvailable()) return null;

      final response = await _store.queryProductDetails({productId});

      for (final product in response.productDetails) {
        _products[product.id] = product;
      }

      return _products[productId];
    } catch (error, stackTrace) {
      _log('Reading $productId from the store failed', error, stackTrace);

      return null;
    }
  }

  static PurchaseUpdate _updateOf(PurchaseDetails purchase) => (
    code: purchase.error?.code,
    outcome: switch (purchase.status) {
      PurchaseStatus.canceled => PurchaseOutcome.canceled,
      PurchaseStatus.error => PurchaseOutcome.failed,
      PurchaseStatus.pending => PurchaseOutcome.pending,
      PurchaseStatus.purchased => PurchaseOutcome.purchased,
      PurchaseStatus.restored => PurchaseOutcome.restored,
    },
    productId: purchase.productID,
  );

  static void _log(String message, Object error, StackTrace stackTrace) =>
      Timber.e(
        tag: packageName,
        logMessage: message,
        exception: error,
        stackTrace: stackTrace,
      );
}
