import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_engagement_store.dart';
import '../fakes.dart';
import '../fake_progression_store.dart';

ProviderContainer _containerAt(
  FakeClock clock, {
  Map<String, String> published = const {},
  BestScores? scores,
}) {
  final container = ProviderContainer(
    overrides: bindProviders(
      adsRemoved: (ref) async => false,
      analyticsSink: (ref) => FakeAnalyticsSink(),
      bestScores: (ref) => scores ?? FakeBestScores(),
      clock: (ref) => clock,
      engagementStore: (ref) => FakeEngagementStore(),
      gameRules: (ref) => const TwoWorldRules(),
      onDailyRunFinished: (ref) => () async {},
      progressionStore: (ref) => FakeProgressionStore(),
      remoteValue: (ref) =>
          (key) => published[key],
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

  return container;
}

/// A profile with Twin, Stonemason and Patience unlocked.
const _profile = Progression(
  jokerStats: {},
  tutorialDone: true,
  unannouncedJokers: {},
  unlockedJokers: {.twin, .stonemason, .patience},
  worlds: {},
);

RunStart _launchAt(String instant, GameLaunch launch, {WorldId? world}) =>
    _containerAt(FakeClock(DateTime.parse(instant))).read(runStartForProvider)(
      launch,
      progression: _profile,
      world: world,
    );

void main() {
  group('the daily run', () {
    test(
      'is the same for two players on the same UTC day, wherever they are',
      () {
        // Given: 10:00 in New York and 01:00 the next morning in Tokyo, both
        // 16 October in UTC
        const newYork = '2026-10-16T10:00:00-05:00';
        const tokyo = '2026-10-17T01:00:00+09:00';

        // When
        final inNewYork = _launchAt(newYork, .daily);
        final inTokyo = _launchAt(tokyo, .daily);

        // Then
        expect(inTokyo, inNewYork);
        expect(inNewYork.mode, const GameMode.daily(day: 20261016));
        expect(inNewYork.seed, 20261016 + 1);
      },
    );

    test('offers every joker, whatever the player has unlocked', () {
      // Given / When
      final daily = _launchAt('2026-10-16T12:00:00Z', .daily);

      // Then
      expect(daily.config.world, WorldId.rubble);
      expect(daily.config.jokerPool, JokerId.values);
    });

    test('changes at midnight UTC', () {
      // Given / When
      final lastSecond = _launchAt('2026-10-16T23:59:59Z', .daily);
      final firstSecond = _launchAt('2026-10-17T00:00:00Z', .daily);

      // Then
      expect(lastSecond.mode, const GameMode.daily(day: 20261016));
      expect(firstSecond.mode, const GameMode.daily(day: 20261017));
      expect(firstSecond.seed, isNot(lastSecond.seed));
    });
  });

  group('a practice run', () {
    test('counts for practice, on a fresh seed each time', () {
      // Given
      final clock = FakeClock(DateTime.utc(2026, 10, 16, 12));
      final startFor = _containerAt(clock).read(runStartForProvider);

      // When
      final first = startFor(.practice, progression: _profile);
      clock.current = clock.current.add(const Duration(microseconds: 1));
      final second = startFor(.practice, progression: _profile);

      // Then
      expect(first.mode, const GameMode.practice());
      expect(second.seed, isNot(first.seed));
    });

    test("is played in the map's first world, offering only what is "
        'unlocked', () {
      // Given / When
      final practice = _launchAt('2026-10-16T12:00:00Z', .practice);

      // Then
      expect(practice.config.world, WorldId.rubble);
      expect(practice.config.jokerPool, [
        JokerId.patience,
        JokerId.stonemason,
        JokerId.twin,
      ]);
    });
  });

  group('a world run', () {
    test('counts for its world, offering only what is unlocked', () {
      // Given / When
      final run = _launchAt('2026-10-16T12:00:00Z', .world, world: .gravity);

      // Then
      expect(run.mode, const GameMode.world(world: .gravity));
      expect(run.config.world, WorldId.gravity);
      expect(run.config.jokerPool, [
        JokerId.patience,
        JokerId.stonemason,
        JokerId.twin,
      ]);
    });

    test("naming no world plays the map's first", () {
      // Given / When
      final run = _launchAt('2026-10-16T12:00:00Z', .world);

      // Then
      expect(run.mode, const GameMode.world(world: .rubble));
      expect(run.config.world, WorldId.rubble);
    });

    test("naming a world that is coming soon plays the map's first instead "
        'of failing', () {
      // Given / When
      final run = _launchAt('2026-10-16T12:00:00Z', .world, world: .fog);

      // Then
      expect(run.mode, const GameMode.world(world: .rubble));
      expect(run.config.world, WorldId.rubble);
    });
  });

  test('the tutorial counts as practice, never as today’s run', () {
    // Given / When
    final tutorial = _launchAt('2026-10-16T12:00:00Z', .tutorial);

    // Then
    expect(tutorial.mode, const GameMode.practice());
  });

  test("today's daily date is the UTC day the daily is played on", () {
    // Given: 01:00 on 17 October in Tokyo, still 16 October in UTC
    final container = _containerAt(
      FakeClock(DateTime.parse('2026-10-17T01:00:00+09:00')),
    );

    // When
    final date = container.read(todaysDailyDateProvider);

    // Then
    expect(date, DateTime.utc(2026, 10, 16));
  });

  group("today's daily best", () {
    test('is read for the UTC day it is', () async {
      // Given
      final scores = FakeBestScores()
        ..saved[const GameMode.daily(day: 20261016)] = 2400;
      final container = _containerAt(
        FakeClock(DateTime.parse('2026-10-17T01:00:00+09:00')),
        scores: scores,
      );

      // When
      final best = await container.read(todaysDailyBestProvider.future);

      // Then
      expect(best, 2400);
    });

    test('starts afresh when the next UTC day begins', () async {
      // Given: watched a tenth of a second before midnight
      final scores = FakeBestScores()
        ..saved[const GameMode.daily(day: 20261016)] = 2400;
      final clock = FakeClock(DateTime.utc(2026, 10, 16, 23, 59, 59, 900));
      final container = _containerAt(clock, scores: scores);
      container.listen(todaysDailyBestProvider, (_, _) {});
      expect(await container.read(todaysDailyBestProvider.future), 2400);

      // When
      clock.current = DateTime.utc(2026, 10, 17);
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Then
      expect(await container.read(todaysDailyBestProvider.future), isNull);
    });
  });

  test('a new best refreshes what is shown for its mode', () async {
    // Given
    final scores = FakeBestScores();
    final container = _containerAt(
      FakeClock(DateTime.utc(2026, 10, 16, 12)),
      scores: scores,
    );
    container.listen(todaysDailyBestProvider, (_, _) {});
    expect(await container.read(todaysDailyBestProvider.future), isNull);

    // When
    await container.read(recordRunEndProvider)(
      const GameMode.daily(day: 20261016),
      1800,
    );

    // Then
    expect(await container.read(todaysDailyBestProvider.future), 1800);
  });

  test('Given a boss target published, When the next daily and practice runs '
      'start, Then both play it', () {
    // Given
    final startFor = _containerAt(
      FakeClock(DateTime.utc(2026, 10, 17, 12)),
      published: {'boss_target_rubble': '4100'},
    ).read(runStartForProvider);

    // When
    final daily = startFor(.daily, progression: _profile);
    final practice = startFor(.practice, progression: _profile);

    // Then
    expect(daily.config.rounds.last.target, 4100);
    expect(practice.config.rounds.last.target, 4100);
  });
}
