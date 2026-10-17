import 'package:ads/ads.dart';
import 'package:test/test.dart';

void main() {
  test('every reward is granted until an ad network is wired in', () async {
    // Given / When
    final granted = await const RewardedAds().show();

    // Then
    expect(granted, isTrue);
  });
}
