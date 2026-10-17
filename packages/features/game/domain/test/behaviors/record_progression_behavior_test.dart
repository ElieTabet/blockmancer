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

    test(
      'whose next world is coming soon unlocks its jokers, not that world',
      () async {
        // Given: Gravity open, and Fog after it with no rules yet
        store.saved = store.saved.copyWith(
          worlds: {
            ...store.saved.worlds,
            WorldId.gravity: const WorldProgress(
              bossBeaten: false,
              stars: _noStars,
              unlocked: true,
            ),
          },
        );

        // When: Gravity's boss is beaten for the first time
        final change = await record(
          const .world(world: .gravity),
          runIn(const .won()),
        );

        // Then
        expect(change?.unlockedWorld, isNull);
        expect(change?.unlockedJokers, [JokerId.anchor, JokerId.avalanche]);
        expect(change?.unlocksAnything, isTrue);
        expect(store.saved.worlds[WorldId.fog]?.unlocked, isFalse);
        expect(store.saved.worlds[WorldId.gravity]?.bossBeaten, isTrue);
        expect(
          store.saved.unlockedJokers,
          containsAll([JokerId.anchor, JokerId.avalanche]),
        );
      },
    );

    test('says what the progression now holds, for the next run', () async {
      // Given a fresh profile / When
      final change = await record(_rubble, runIn(const .won()));

      // Then
      expect(change?.progression, store.saved);
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

  group('stars held across worlds', () {
    const gravity = GameMode.world(world: .gravity);
    const allThree = WorldStars(
      bossBeaten: true,
      noRevive: true,
      scoreThreshold: true,
    );

    /// Rubble's boss beaten with every star, and Gravity open with [stars].
    void holding({WorldStars gravityStars = _noStars, Set<JokerId>? jokers}) {
      store.saved = store.saved.copyWith(
        unlockedJokers: jokers ?? store.saved.unlockedJokers,
        worlds: {
          ...store.saved.worlds,
          WorldId.rubble: const WorldProgress(
            bossBeaten: true,
            stars: allThree,
            unlocked: true,
          ),
          WorldId.gravity: WorldProgress(
            bossBeaten: false,
            stars: gravityStars,
            unlocked: true,
          ),
        },
      );
    }

    test('3 stars unlock no joker', () async {
      // Given
      holding();

      // When: a Gravity run that earns nothing
      final change = await record(gravity, runIn(const .over()));

      // Then
      expect(change?.unlockedJokers, isEmpty);
      expect(store.saved.unlockedJokers, {JokerId.patience, JokerId.twin});
    });

    test(
      'the run that reaches 4 stars unlocks Full House and On the Brink',
      () async {
        // Given
        holding();

        // When: Gravity's third star, its boss still standing
        final change = await record(
          gravity,
          runIn(const .over(), runTotal: 8000),
        );

        // Then
        expect(change?.unlockedWorld, isNull);
        expect(change?.unlockedJokers, [JokerId.fullhouse, JokerId.brink]);
        expect(change?.unlocksAnything, isTrue);
        expect(
          store.saved.unlockedJokers,
          containsAll([JokerId.fullhouse, JokerId.brink]),
        );
        expect(store.saved.unlockedJokers, isNot(contains(JokerId.finisher)));
      },
    );

    test('a pair is announced once, and never locked again', () async {
      // Given: the pair unlocked by reaching 4 stars
      holding();
      await record(gravity, runIn(const .over(), runTotal: 8000));

      // When: a run that earns nothing
      final change = await record(gravity, runIn(const .over()));

      // Then
      expect(change?.unlockedJokers, isEmpty);
      expect(
        store.saved.unlockedJokers,
        containsAll([JokerId.fullhouse, JokerId.brink]),
      );
    });

    test('5 stars unlock nothing beyond the first pair', () async {
      // Given: 4 stars, the first pair already unlocked
      holding(
        gravityStars: const WorldStars(
          bossBeaten: false,
          noRevive: false,
          scoreThreshold: true,
        ),
        jokers: {.patience, .twin, .fullhouse, .brink},
      );

      // When: Gravity's boss falls after a revive, for 5 stars
      final change = await record(gravity, runIn(const .won(), revivesUsed: 1));

      // Then
      expect(change?.unlockedJokers, [JokerId.anchor, JokerId.avalanche]);
      expect(store.saved.unlockedJokers, isNot(contains(JokerId.finisher)));
    });

    test(
      'the run that reaches 6 stars unlocks Finisher and Hat Trick',
      () async {
        // Given: 5 stars, the first pair already unlocked
        holding(
          gravityStars: const WorldStars(
            bossBeaten: true,
            noRevive: true,
            scoreThreshold: false,
          ),
          jokers: {.patience, .twin, .fullhouse, .brink},
        );

        // When
        final change = await record(
          gravity,
          runIn(const .over(), runTotal: 8000),
        );

        // Then
        expect(change?.unlockedJokers, [JokerId.finisher, JokerId.hattrick]);
      },
    );

    test(
      "a first boss win's jokers and the stars' jokers are announced together",
      () async {
        // Given: 4 stars held before the star unlocks existed, so neither
        // pair was ever announced
        holding(
          gravityStars: const WorldStars(
            bossBeaten: false,
            noRevive: false,
            scoreThreshold: true,
          ),
        );

        // When: Gravity's boss falls with no revive, for 6 stars
        final change = await record(gravity, runIn(const .won()));

        // Then
        expect(change?.unlockedJokers, [
          JokerId.anchor,
          JokerId.avalanche,
          JokerId.fullhouse,
          JokerId.brink,
          JokerId.finisher,
          JokerId.hattrick,
        ]);
      },
    );
  });

  group('joker stats', () {
    test('a finished run counts once for each joker it owned', () async {
      // Given / When
      await record(
        _rubble,
        runIn(
          const .over(),
          runTotal: 3000,
        ).copyWith(jokers: [.patience, .twin]),
      );

      // Then
      const once = JokerStats(bestRunTotal: 3000, runsWon: 0, timesPicked: 1);
      expect(store.saved.jokerStats, {
        JokerId.patience: once,
        JokerId.twin: once,
      });
    });

    test('a win counts, and the best total is kept over a worse run', () async {
      // Given
      await record(
        _rubble,
        runIn(const .won(), runTotal: 9000).copyWith(jokers: [.twin]),
      );

      // When
      await record(
        _rubble,
        runIn(const .over(), runTotal: 2000).copyWith(jokers: [.twin]),
      );

      // Then
      expect(
        store.saved.jokerStats[JokerId.twin],
        const JokerStats(bestRunTotal: 9000, runsWon: 1, timesPicked: 2),
      );
    });

    for (final (name, mode) in const [
      ('daily run', GameMode.daily(day: 20261017)),
      ('practice run', GameMode.practice()),
    ]) {
      test('a $name counts its jokers too', () async {
        // Given / When
        await record(
          mode,
          runIn(const .won(), runTotal: 5000).copyWith(jokers: [.collector]),
        );

        // Then
        expect(store.saved.jokerStats, const {
          JokerId.collector: JokerStats(
            bestRunTotal: 5000,
            runsWon: 1,
            timesPicked: 1,
          ),
        });
      });
    }

    test('a run with no joker counts nothing', () async {
      // Given / When
      await record(_rubble, runIn(const .over(), runTotal: 3000));

      // Then
      expect(store.saved.jokerStats, isEmpty);
    });
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
