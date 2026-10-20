import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shop_domain/src/package_name.dart';
import 'package:shop_domain/src/providers_di.br.dart' as di;
import 'package:timber/timber.dart';

part 'remove_ads_notifier.br.g.dart';

/// Whether the player owns Remove ads (the one product: interstitials gone
/// for good; the rewarded revive stays): kept on the device, and confirmed by
/// every purchase or restore the store reports, from launch on. Nothing ever
/// takes it back (a refund is the store's to handle).
@Riverpod(keepAlive: true)
class RemoveAdsNotifier extends _$RemoveAdsNotifier {
  /// Set from a buy until the store reports how it went.
  Timer? _buying;

  /// How long a buy the store never reports on holds back the next one.
  static const _buyingAtMost = Duration(minutes: 5);

  /// How long a restore waits for the store to report what it found.
  static const _restoreWait = Duration(seconds: 3);

  Completer<void>? _restoring;

  @override
  Future<bool> build() async {
    final updates = ref.watch(di.purchaseUpdatesProvider)().listen(_onUpdate);
    ref
      ..onDispose(updates.cancel)
      ..onDispose(_doneBuying);

    try {
      return await ref.watch(di.entitlementStoreProvider).adsRemoved();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The entitlement could not be read; ads stay on',
        exception: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  /// Opens the store's sheet; false when it couldn't open. What comes of it
  /// arrives as an update. Until it has, another tap asks nothing: the store
  /// would put up a second sheet.
  Future<bool> buy() async {
    if (_buying != null) return true;

    _buying = Timer(_buyingAtMost, _doneBuying);
    final product = ref.read(di.removeAdsProductIdProvider);
    final sink = ref.read(di.analyticsSinkProvider)
      ..log(.purchaseStarted(product: product));
    final opened = await ref.read(di.buyProductProvider)(product);

    if (!opened) {
      _doneBuying();
      sink.log(.purchaseFailed(code: 'unavailable', product: product));
    }

    return opened;
  }

  /// The launch's re-check: the store reports what the player owns, quietly
  /// (it isn't the player's restore, so it counts as none).
  Future<void> recheck() => ref.read(di.restorePurchasesProvider)();

  /// The player's restore (Settings): whether Remove ads is owned once the
  /// store has reported, or [_restoreWait] has passed. Null for a tap while
  /// one is under way: the store isn't asked twice, and the first tap's
  /// answer is the one to show.
  Future<bool?> restore() async {
    if (_restoring != null) return null;

    final restoring = _restoring = Completer<void>();

    try {
      await ref.read(di.restorePurchasesProvider)();
      await restoring.future.timeout(_restoreWait, onTimeout: () {});
    } finally {
      _restoring = null;
    }

    return await future;
  }

  Future<void> _onUpdate(PurchaseUpdate update) async {
    final product = ref.read(di.removeAdsProductIdProvider);

    if (update.productId != product) return;

    _doneBuying();
    final sink = ref.read(di.analyticsSinkProvider);

    switch (update.outcome) {
      case .purchased:
        sink.log(.purchaseCompleted(product: product));
        await _keep();
      case .restored:
        if (_restoring != null) {
          sink.log(.purchaseRestored(product: product));
        }
        await _keep();

        // The store may report several restored purchases for one restore.
        if (_restoring case final restoring? when !restoring.isCompleted) {
          restoring.complete();
        }
      case .canceled:
        sink.log(.purchaseFailed(code: 'canceled', product: product));
      case .failed:
        sink.log(
          .purchaseFailed(code: update.code ?? 'failed', product: product),
        );
      case .pending:
        break;
    }
  }

  void _doneBuying() {
    _buying?.cancel();
    _buying = null;
  }

  Future<void> _keep() async {
    state = const AsyncData(true);

    try {
      await ref.read(di.entitlementStoreProvider).keepAdsRemoved();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Keeping the entitlement failed; it holds this session',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
