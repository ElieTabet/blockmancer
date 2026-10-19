import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_engagement_store.dart';
import '../fake_progression_store.dart';
import '../fakes.dart';

/// The game on 18 October 2026, counting each run end it is told of.
(ProviderContainer, List<String>) _game(FakeBestScores scores) {
  final told = <String>[];
  final container = ProviderContainer(
    overrides: bindProviders(
      adsRemoved: (ref) async => false,
      analyticsSink: (ref) => FakeAnalyticsSink(),
      appVersion: (ref) async => '1.0.0',
      bestScores: (ref) => scores,
      clock: (ref) => FakeClock(DateTime.utc(2026, 10, 18, 9)),
      engagementStore: (ref) => FakeEngagementStore(),
      gameRules: (ref) => const TwoWorldRules(),
      onRunFinished: (ref) =>
          () async => told.add('run finished'),
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

  return (container, told);
}

void main() {
  test("Given yesterday's daily played, When today's ends, Then the reminders "
      'are told and the streak reads 2', () async {
    // Given
    final scores = FakeBestScores()..saved[const .daily(day: 20261017)] = 4000;
    final (container, told) = _game(scores);
    container.listen(dailyStreakProvider, (_, _) {});
    expect(await container.read(dailyStreakProvider.future), 1);

    // When
    await container.read(recordRunEndProvider)(
      const .daily(day: 20261018),
      3500,
    );

    // Then
    expect(told, ['run finished']);
    expect(await container.read(dailyStreakProvider.future), 2);
  });

  test('Given a player who only ever plays world runs, When one ends, Then '
      'the reminders are told and the player counts as having finished a '
      'run', () async {
    // Given
    final (container, told) = _game(FakeBestScores());
    expect(await container.read(hasCompletedRunProvider)(), isFalse);

    // When: the game counts the end beside keeping its best
    final recorded = container.read(recordRunEndProvider)(
      const .world(world: WorldId.gravity),
      2500,
    );
    await container.read(countRunEndProvider)();
    await recorded;

    // Then
    expect(told, ['run finished']);
    expect(await container.read(hasCompletedRunProvider)(), isTrue);
  });

  test(
    'Given a practice run, When it ends, Then the reminders are told',
    () async {
      // Given
      final (container, told) = _game(FakeBestScores());

      // When
      await container.read(recordRunEndProvider)(const .practice(), 2000);

      // Then
      expect(told, ['run finished']);
    },
  );
}
