import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_engagement_store.dart';
import '../fake_progression_store.dart';
import '../fakes.dart';

/// Each board's submissions, in order.
typedef _Boards = ({List<int> best, List<int> daily});

(ProviderContainer, _Boards) _game() {
  final boards = (best: <int>[], daily: <int>[]);
  final container = ProviderContainer(
    overrides: bindProviders(
      adsRemoved: (ref) async => false,
      analyticsSink: (ref) => FakeAnalyticsSink(),
      appVersion: (ref) async => '1.0.0',
      bestScores: (ref) => FakeBestScores(),
      clock: (ref) => FakeClock(DateTime.utc(2026, 10, 18)),
      engagementStore: (ref) => FakeEngagementStore(),
      gameRules: (ref) => const TwoWorldRules(),
      progressionStore: (ref) => FakeProgressionStore(),
      remoteValue: (ref) =>
          (_) => null,
      requestReview: (ref) => () async {},
      runStore: (ref) => FakeRunStore(),
      sessionHadError: (ref) =>
          () => false,
      showInterstitial: (ref) =>
          () async => const AdResult.closed(),
      submitBestScore: (ref) =>
          (score) async => boards.best.add(score),
      submitDailyScore: (ref) =>
          (score) async => boards.daily.add(score),
    ),
  );
  addTearDown(container.dispose);

  return (container, boards);
}

void main() {
  test('Given a daily run that ended, When its total is submitted, Then it '
      "goes to the day's board and the all-time one", () async {
    // Given
    final (container, boards) = _game();

    // When
    await container.read(submitRunScoreProvider)(
      const .daily(day: 20261018),
      9200,
    );

    // Then
    expect(boards.daily, [9200]);
    expect(boards.best, [9200]);
  });

  test('Given a world run and a practice run that ended, When their totals '
      'are submitted, Then only the all-time board hears of them', () async {
    // Given
    final (container, boards) = _game();
    final submit = container.read(submitRunScoreProvider);

    // When
    await submit(const .world(world: WorldId.gravity), 7400);
    await submit(const .practice(), 3100);

    // Then
    expect(boards.best, [7400, 3100]);
    expect(boards.daily, isEmpty);
  });

  test('Given a daily run that scored nothing, When its total is submitted, '
      'Then no board hears of it', () async {
    // Given
    final (container, boards) = _game();

    // When
    await container.read(submitRunScoreProvider)(
      const .daily(day: 20261018),
      0,
    );

    // Then
    expect(boards.best, isEmpty);
    expect(boards.daily, isEmpty);
  });
}
