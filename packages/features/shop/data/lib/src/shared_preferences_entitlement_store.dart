import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_domain/shop_domain.dart';

/// [EntitlementStore] under one key on the device.
final class SharedPreferencesEntitlementStore implements EntitlementStore {
  const SharedPreferencesEntitlementStore();

  static const _key = 'purchases.removeAds';

  @override
  Future<bool> adsRemoved() async =>
      (await SharedPreferences.getInstance()).getBool(_key) ?? false;

  @override
  Future<void> keepAdsRemoved() async =>
      (await SharedPreferences.getInstance()).setBool(_key, true);
}
