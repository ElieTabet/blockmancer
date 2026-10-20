import 'package:shared_domain/shared_domain.dart';

/// The stores' in-app purchases, behind a contract naming no vendor.
abstract interface class Purchases {
  /// What the store reports, as it reports it: buys, restores (the player's
  /// and the launch's), failures. Listened to from launch, so none is missed.
  Stream<PurchaseUpdate> get updates;

  /// Opens the store's sheet for [productId]; what comes of it arrives on
  /// [updates]. False when the store couldn't open it. Never throws.
  Future<bool> buy(String productId);

  /// [productId]'s price as the store shows it to this player (`$3.99`,
  /// `3,99 €`), or null while the store can't be reached. Never throws.
  Future<String?> priceOf(String productId);

  /// Checks at launch what this player owns, where the store can without
  /// asking them anything: Google Play does; the App Store would ask for the
  /// Apple Account's password, so on iOS a restore is the player's to ask
  /// for. What is found arrives on [updates] as restored. Never throws.
  Future<void> recheckQuietly();

  /// Asks the store for every non-consumable this player owns; each arrives
  /// on [updates] as restored. False when the store couldn't be reached.
  /// Never throws.
  Future<bool> restore();
}

/// No store: tests, and builds without one.
final class NoPurchases implements Purchases {
  const NoPurchases();

  @override
  Stream<PurchaseUpdate> get updates => const Stream.empty();

  @override
  Future<bool> buy(String productId) async => false;

  @override
  Future<String?> priceOf(String productId) async => null;

  @override
  Future<void> recheckQuietly() async {}

  @override
  Future<bool> restore() async => false;
}
