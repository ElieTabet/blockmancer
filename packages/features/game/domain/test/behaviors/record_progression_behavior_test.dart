import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/record_progression_behavior.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

const _rubble = GameMode.world(world: .rubble);

const _noStars = WorldStars(
  bossBeaten: false,
  noRevive: false,
  scoreThreshold: false,
);

void main() {
  late FakeProgressionStore store;
  late RecordProgressionBehavior record;

  setUp(() {
    store = FakeProgressionStore()
      ..saved = startingProgression(const TwoWorldRules());
    record = RecordProgressionBehavior(
      rules: const TwoWorldRules(),
      store: store,
    );
  });

  group('beating a world boss', () {
    test('for the first time opens the next world and its jokers', () async {
      // Given a fresh profile / When
      final change = await record(_rubble, runIn(const .won()));

      // Then
      expect(change?.unlockedWorld, WorldId.gravity);
      expect(change?.unlockedJokers, [JokerId.stonemason, JokerId.quarry]);
      expect(store.saved.worlds[WorldId.gravity]?.unlocked, isTrue);
      expect(store.saved.worlds[WorldId.rubble]?.bossBeaten, isTrue);
      expect(store.saved.unlockedJokers, {
        JokerId.patience,
        JokerId.twin,
        JokerId.stonemason,
        JokerId.quarry,
      });
    });

    test('a second time unlocks nothing more', () async {
      // Given
      await record(_rubble, runIn(const .won()));
      final afterFirstWin = store.saved;

      // When
      final change = await record(_rubble, runIn(const .won()));

      // Then
      expect(change?.unlockedWorld, isNull);
      expect(change?.unlockedJokers, isEmpty);
      expect(change?.unlocksAnything, isFalse);
      expect(store.saved, afterFirstWin);
    });

    test('of the last world opens nothing', () async {
      // Given / When
      final change = await record(
        const .world(world: .gravity),
        runIn(const .won()),
      );

      // Then
      expect(change?.unlockedWorld, isNull);
      expect(change?.unlockedJokers, isEmpty);
      expect(store.saved.worlds[WorldId.gravity]?.bossBeaten, isTrue);
    });
  });

  group('stars', () {
    test(
      'beating the boss after reviving earns the first star alone',
      () async {
        // Given / When
        final change = await record(
          _rubble,
          runIn(const .won(), revivesUsed: 1),
        );

        // Then
        const boss = WorldStars(
          bossBeaten: true,
          noRevive: false,
          scoreThreshold: false,
        );
        expect(change?.newStars, boss);
        expect(store.saved.worlds[WorldId.rubble]?.stars, boss);
      },
    );

    test('beating the boss without reviving earns the first two', () async {
      // Given / When
      final change = await record(_rubble, runIn(const .won()));

      // Then
      expect(
        change?.newStars,
        const WorldStars(
          bossBeaten: true,
          noRevive: true,
          scoreThreshold: false,
        ),
      );
    });

    test(
      'reaching the threshold earns the third star, boss beaten or not',
      () async {
        // Given / When: ended short of the boss with 8000 points
        final change = await record(
          _rubble,
          runIn(const .over(), runTotal: 8000),
        );

        // Then
        const threshold = WorldStars(
          bossBeaten: false,
          noRevive: false,
          scoreThreshold: true,
        );
        expect(change?.newStars, threshold);
        expect(change?.unlocksAnything, isFalse);
        expect(store.saved.worlds[WorldId.rubble]?.stars, threshold);
        expect(store.saved.worlds[WorldId.gravity]?.unlocked, isFalse);
      },
    );

    test('a run short of everything earns no star', () async {
      // Given / When
      final change = await record(
        _rubble,
        runIn(const .over(), runTotal: 7999),
      );

      // Then
      expect(change?.newStars, _noStars);
      expect(change?.stars, _noStars);
    });

    test(
      'are never taken back by a worse run, and are not new again',
      () async {
        // Given: all three stars earned
        await record(_rubble, runIn(const .won(), runTotal: 9000));

        // When
        final change = await record(
          _rubble,
          runIn(const .over(), runTotal: 100),
        );

        // Then
        const all = WorldStars(
          bossBeaten: true,
          noRevive: true,
          scoreThreshold: true,
        );
        expect(change?.stars, all);
        expect(change?.newStars, _noStars);
        expect(store.saved.worlds[WorldId.rubble]?.stars, all);
      },
    );
  });

  for (final (name, mode) in const [
    ('daily run', GameMode.daily(day: 20261017)),
    ('practice run', GameMode.practice()),
  ]) {
    test('a $name leaves the map as it was', () async {
      // Given
      final before = store.saved;

      // When
      final change = await record(mode, runIn(const .won(), runTotal: 9000));

      // Then
      expect(change, isNull);
      expect(store.saved, before);
    });
  }
}
