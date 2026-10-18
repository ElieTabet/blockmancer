/// What the player owns, kept on this device so it holds offline; the store
/// re-confirms it at launch.
abstract interface class EntitlementStore {
  Future<bool> adsRemoved();

  Future<void> keepAdsRemoved();
}
