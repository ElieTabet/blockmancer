import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_engagement_store.dart';
import '../fake_progression_store.dart';
import '../fakes.dart';

ProviderContainer _game({required bool adsRemoved}) {
  final container = ProviderContainer(
    overrides: bindProviders(
      adsRemoved: (ref) async => adsRemoved,
      analyticsSink: (ref) => FakeAnalyticsSink(),
      appVersion: (ref) async => '1.0.0',
      bestScores: (ref) => FakeBestScores(),
      clock: (ref) => FakeClock(DateTime.utc(2026, 10, 18)),
      engagementStore: (ref) => FakeEngagementStore(),
      gameRules: (ref) => const TwoWorldRules(),
      onRunFinished: (ref) => () async {},
      progressionStore: (ref) => FakeProgressionStore(),
      remoteValue: (ref) =>
          (_) => null,
      requestReview: (ref) => () async {},
      runStore: (ref) => FakeRunStore(),
      sessionHadError: (ref) =>
          () => false,
      showInterstitial: (ref) =>
          () async => const AdResult.closed(),
      submitBestScore: (ref) => (_) async {},
      submitDailyScore: (ref) => (_) async {},
    ),
  );
  addTearDown(container.dispose);

  return container;
}

void main() {
  test('Given Remove ads not bought, When a revive is weighed, Then it costs '
      'a rewarded ad', () async {
    expect(
      await _game(adsRemoved: false).read(reviveNeedsAdProvider.future),
      isTrue,
    );
  });

  test('Given Remove ads bought, When a revive is weighed, Then it needs no '
      'ad', () async {
    expect(
      await _game(adsRemoved: true).read(reviveNeedsAdProvider.future),
      isFalse,
    );
  });
}
