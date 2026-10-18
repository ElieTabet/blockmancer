import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/entities/run_events.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fakes.dart';

const _offers = [JokerId.twin, JokerId.combo, JokerId.saver];
const _noStars = WorldStars(
  bossBeaten: false,
  noRevive: false,
  scoreThreshold: false,
);

void main() {
  group('a move counts', () {
    test("a fresh run's starting pick as the run's start and a pick", () {
      // Given: a daily run waiting for its starting joker
      final before = runIn(
        const .pickingJoker(offers: _offers),
      ).copyWith(pickIndex: 0);
      final after = runIn(
        const .playing(),
      ).copyWith(jokers: const [.twin], pickIndex: 1);

      // When
      final events = runEventsOf(const .daily(day: 20261017), before, (
        after,
        const [],
      ));

      // Then
      expect(events, const [
        AnalyticsEvent.runStart(mode: .daily, world: .rubble),
        AnalyticsEvent.jokerPick(id: .twin, offered: _offers),
      ]);
    });

    test("a later pick as a pick alone", () {
      // Given: a world run after its second round
      final before = runIn(
        const .pickingJoker(offers: _offers),
      ).copyWith(jokers: const [.patience], pickIndex: 2);
      final after = before.copyWith(
        jokers: const [.patience, .saver],
        phase: const .playing(),
      );

      // When
      final events = runEventsOf(const .world(world: .rubble), before, (
        after,
        const [],
      ));

      // Then
      expect(events, const [
        AnalyticsEvent.jokerPick(id: .saver, offered: _offers),
      ]);
    });

    test('a won round as its end, numbered from 1', () {
      // Given / When
      final events = runEventsOf(const .practice(), runIn(const .playing()), (
        runIn(const .pickingJoker(offers: _offers)),
        const [GameEvent.roundWon(bonus: 0, roundIndex: 1, score: 540)],
      ));

      // Then
      expect(events, const [
        AnalyticsEvent.roundEnd(round: 2, score: 540, won: true),
      ]);
    });

    test('a revive is not counted from the move, nor the lost round it plays '
        'on as an end', () {
      // Given / When
      final events = runEventsOf(
        const .practice(),
        runIn(const .roundLost(reason: .noRoom)),
        (
          runIn(const .playing()),
          const [
            GameEvent.revived(rows: [0, 1]),
          ],
        ),
      );

      // Then: trackRevive counts it, with what paid for it
      expect(events, isEmpty);
    });

    test('a lost round given up as its end, with the score it had', () {
      // Given: round 1 lost with 40 points
      final before = runIn(const .roundLost(reason: .outOfPieces));

      // When
      final events = runEventsOf(const .practice(), before, (
        runIn(const .over(), runTotal: 40),
        const [GameEvent.runOver(total: 40)],
      ));

      // Then
      expect(events, const [
        AnalyticsEvent.roundEnd(round: 1, score: 40, won: false),
      ]);
    });

    test('nothing for a piece placed mid-round', () {
      // Given / When
      final events = runEventsOf(const .practice(), runIn(const .playing()), (
        runIn(const .playing()),
        const [],
      ));

      // Then
      expect(events, isEmpty);
    });
  });

  group("a run's end counts", () {
    test('its total, its win, its new stars and the world it opened', () {
      // Given: Rubble's boss beaten with no revive
      const change = ProgressionChange(
        newStars: WorldStars(
          bossBeaten: true,
          noRevive: true,
          scoreThreshold: false,
        ),
        progression: Progression(
          jokerStats: {},
          tutorialDone: true,
          unannouncedJokers: {},
          unlockedJokers: {},
          worlds: {},
        ),
        stars: _noStars,
        unlockedJokers: [],
        unlockedWorld: .gravity,
      );

      // When
      final events = runEndEventsOf(
        runIn(const .won(), runTotal: 6400),
        change,
      );

      // Then
      expect(events, const [
        AnalyticsEvent.runEnd(starsEarned: 2, total: 6400, won: true),
        AnalyticsEvent.worldUnlock(world: .gravity),
      ]);
    });

    test('no stars and no world for a run outside the map', () {
      // Given / When
      final events = runEndEventsOf(runIn(const .over(), runTotal: 900), null);

      // Then
      expect(events, const [
        AnalyticsEvent.runEnd(starsEarned: 0, total: 900, won: false),
      ]);
    });
  });
}
