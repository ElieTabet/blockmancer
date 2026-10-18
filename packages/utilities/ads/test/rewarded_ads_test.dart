import 'package:ads/ads.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every reward is granted until the rewarded ad is wired in', () async {
    // Given / When
    final granted = await const RewardedAds().show();

    // Then
    expect(granted, isTrue);
  });

  test('without a consent form, no ads may be requested', () async {
    expect(await const NoConsent().gather(), (
      canRequestAds: false,
      privacyOptionsRequired: false,
    ));
  });
}
