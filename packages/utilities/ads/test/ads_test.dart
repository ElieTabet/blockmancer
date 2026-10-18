import 'package:ads/ads.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_domain/shared_domain.dart';

void main() {
  test('without a consent form, no ads may be requested', () async {
    expect(await const NoConsent().gather(), (
      canRequestAds: false,
      privacyOptionsRequired: false,
    ));
    expect(await const NoConsent().adsAllowed(), isFalse);
  });

  test('with no ads, none is ever ready, and asking for one fails', () async {
    expect(const NoAds().isReady, isFalse);
    expect(await const NoAds().readiness.first, isFalse);
    expect(await const NoAds().show(), const AdFailed(code: 'no_ads'));
  });
}
