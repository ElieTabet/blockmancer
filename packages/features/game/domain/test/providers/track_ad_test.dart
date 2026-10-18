import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_engagement_store.dart';
import '../fake_progression_store.dart';
import '../fakes.dart';

void main() {
  test('Given each ad result, When it is tracked, Then Analytics hears what '
      'it came to', () {
    // Given
    final analytics = FakeAnalyticsSink();
    final container = ProviderContainer(
      overrides: bindProviders(
        adsRemoved: (ref) async => false,
        analyticsSink: (ref) => analytics,
        bestScores: (ref) => FakeBestScores(),
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 18)),
        engagementStore: (ref) => FakeEngagementStore(),
        gameRules: (ref) => const TwoWorldRules(),
        progressionStore: (ref) => FakeProgressionStore(),
        remoteValue: (ref) =>
            (_) => null,
        runStore: (ref) => FakeRunStore(),
        appVersion: (ref) async => '1.0.0',
        requestReview: (ref) => () async {},
        sessionHadError: (ref) =>
            () => false,
        showInterstitial: (ref) =>
            () async => const AdResult.closed(),
      ),
    );
    addTearDown(container.dispose);
    final trackAd = container.read(trackAdProvider);

    // When
    trackAd(.interstitial, const .closed());
    trackAd(.rewarded, const .earned());
    trackAd(.rewarded, const .failed(code: '3'));

    // Then
    expect(analytics.logged, const [
      AnalyticsEvent.adShown(kind: .interstitial),
      AnalyticsEvent.adShown(kind: .rewarded),
      AnalyticsEvent.adRewardEarned(),
      AnalyticsEvent.adFailed(code: '3', kind: .rewarded),
    ]);
  });
}
