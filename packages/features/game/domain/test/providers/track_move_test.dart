import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fake_engagement_store.dart';
import '../fakes.dart';

void main() {
  late FakeAnalyticsSink sink;
  late ProviderContainer container;

  setUp(() {
    sink = FakeAnalyticsSink();
    container = ProviderContainer(
      overrides: bindProviders(
        adsRemoved: (ref) async => false,
        analyticsSink: (ref) => sink,
        bestScores: (ref) => FakeBestScores(),
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 17, 12)),
        engagementStore: (ref) => FakeEngagementStore(),
        gameRules: (ref) => const TwoWorldRules(),
        onDailyRunFinished: (ref) => () async {},
        progressionStore: (ref) => FakeProgressionStore(),
        remoteValue: (ref) =>
            (_) => null,
        runStore: (ref) => FakeRunStore(),
        appVersion: (ref) async => '1.0.0',
        requestReview: (ref) => () async {},
        sessionHadError: (ref) =>
            () => false,
        showInterstitial: (ref) =>
            () async => const AdResult.failed(code: 'no_ads'),
        submitBestScore: (ref) => (_) async {},
        submitDailyScore: (ref) => (_) async {},
      ),
    );
    addTearDown(container.dispose);
  });

  test('a move is counted in the sink composition binds', () {
    // When
    container.read(
      trackMoveProvider,
    )(const .practice(), runIn(const .playing()), (
      runIn(const .pickingJoker(offers: [])),
      const [GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 300)],
    ));

    // Then
    expect(sink.logged, const [
      AnalyticsEvent.roundEnd(round: 1, score: 300, won: true),
    ]);
  });

  test('a revive is counted with what paid for it', () {
    // When
    container.read(trackReviveProvider)(.ad);
    container.read(trackReviveProvider)(.owned);

    // Then
    expect(sink.logged, const [
      AnalyticsEvent.revive(source: .ad),
      AnalyticsEvent.revive(source: .owned),
    ]);
  });

  test("a run's end is counted in the sink composition binds", () {
    // When
    container.read(trackRunEndProvider)(
      runIn(const .over(), runTotal: 1200),
      null,
    );

    // Then
    expect(sink.logged, const [
      AnalyticsEvent.runEnd(starsEarned: 0, total: 1200, won: false),
    ]);
  });
}
