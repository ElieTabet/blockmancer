import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';

import '../fakes.dart';

ProviderContainer _containerAt(FakeClock clock, {BestScores? scores}) {
  final container = ProviderContainer(
    overrides: bindProviders(
      bestScores: (ref) => scores ?? FakeBestScores(),
      clock: (ref) => clock,
      gameRules: (ref) => const DailySeedRules(),
      runStore: (ref) => FakeRunStore(),
    ),
  );
  addTearDown(container.dispose);

  return container;
}

RunStart _launchAt(String instant, GameLaunch launch) => _containerAt(
  FakeClock(DateTime.parse(instant)),
).read(runStartForProvider)(launch);

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
      final first = startFor(.practice);
      clock.current = clock.current.add(const Duration(microseconds: 1));
      final second = startFor(.practice);

      // Then
      expect(first.mode, const GameMode.practice());
      expect(second.seed, isNot(first.seed));
    });
  });

  test('the tutorial counts as practice, never as today’s run', () {
    // Given / When
    final tutorial = _launchAt('2026-10-16T12:00:00Z', .tutorial);

    // Then
    expect(tutorial.mode, const GameMode.practice());
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
}
