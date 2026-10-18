import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_data/shop_data.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Given nothing bought, Then ads are on; once kept, they stay off '
      'across launches', () async {
    expect(
      await const SharedPreferencesEntitlementStore().adsRemoved(),
      isFalse,
    );

    await const SharedPreferencesEntitlementStore().keepAdsRemoved();

    expect(
      await const SharedPreferencesEntitlementStore().adsRemoved(),
      isTrue,
    );
  });
}
