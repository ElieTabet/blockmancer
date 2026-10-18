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
      ),
    );
    addTearDown(container.dispose);
  });

  test('a move is counted in the sink composition binds', () {
    // When
    container.read(trackMoveProvider)(
      const .practice(),
      runIn(const .roundLost(reason: .noRoom)),
      (
        runIn(const .playing()),
        const [
          GameEvent.revived(rows: [0, 1]),
        ],
      ),
    );

    // Then
    expect(sink.logged, const [AnalyticsEvent.revive()]);
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
