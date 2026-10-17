import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';
import '../pump_game.dart';

/// The icon beside the star objective reading [objective].
Icon _starOf(WidgetTester tester, String objective) => tester.widget<Icon>(
  find.descendant(
    of: find.ancestor(of: find.text(objective), matching: find.byType(Row)),
    matching: find.byType(Icon),
  ),
);

/// Ends a run opened from a lost round, as [ended] says it ended.
Future<void> _endAs(
  WidgetTester tester,
  FakeGameRules rules,
  RunState ended,
) async {
  rules.next = (ended, [GameEvent.runOver(total: ended.runTotal)]);
  await tester.tap(find.text('End run'));
  await tester.pumpAndSettle();
}

void main() {
  late FakeProgressionStore store;

  setUp(() {
    store = FakeProgressionStore(
      startingProgression(FakeGameRules(start: runIn(const .playing()))),
    );
  });

  testWidgets(
    'beating a world boss for the first time shows the new world and its two '
    'jokers, then how the run ended',
    (tester) async {
      // Given
      final rules = await pumpGame(
        tester,
        runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
        launch: .world,
        progressionStore: store,
        world: .rubble,
      );

      // When
      await _endAs(tester, rules, runIn(const .won(), runTotal: 3000));

      // Then
      expect(find.text('New world: Gravity'), findsOneWidget);
      expect(find.text('Stonemason'), findsOneWidget);
      expect(find.text('Quarry'), findsOneWidget);
      expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsNothing);

      // When
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('New world: Gravity'), findsNothing);
      expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsOneWidget);
    },
  );

  testWidgets(
    "beating Gravity's boss for the first time shows its two jokers, and no "
    'world that is still coming soon',
    (tester) async {
      // Given: Gravity open
      store.saved = store.saved.copyWith(
        worlds: {
          ...store.saved.worlds,
          WorldId.gravity: const WorldProgress(
            bossBeaten: false,
            stars: WorldStars(
              bossBeaten: false,
              noRevive: false,
              scoreThreshold: false,
            ),
            unlocked: true,
          ),
        },
      );
      final rules = await pumpGame(
        tester,
        runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
        launch: .world,
        progressionStore: store,
        world: .gravity,
      );

      // When
      await _endAs(tester, rules, runIn(const .won(), runTotal: 3000));

      // Then
      expect(find.text('New jokers'), findsOneWidget);
      expect(find.text('Anchor'), findsOneWidget);
      expect(find.text('Avalanche'), findsOneWidget);
      expect(find.textContaining('New world'), findsNothing);
    },
  );

  testWidgets(
    'the run end waits for what the run earned, then celebrates it first',
    (tester) async {
      // Given: a slow write
      store.gate = Completer<void>();
      final rules = await pumpGame(
        tester,
        runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
        launch: .world,
        progressionStore: store,
        world: .rubble,
      );

      // When: the boss falls, and the write is still going
      rules.next = (
        runIn(const .won(), runTotal: 3000),
        const [GameEvent.runWon(total: 3000)],
      );
      await tester.tap(find.text('End run'));
      await tester.pump(const Duration(milliseconds: 400));

      // Then
      expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsNothing);
      expect(find.text('Play again'), findsNothing);

      // When
      store.gate!.complete();
      await tester.pumpAndSettle();

      // Then
      expect(find.text('New world: Gravity'), findsOneWidget);
      expect(find.text('Play again'), findsNothing);
    },
  );

  testWidgets('a run whose earnings cannot be kept still ends, without stars', (
    tester,
  ) async {
    // Given
    store.broken = true;
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
      launch: .world,
      progressionStore: store,
      world: .rubble,
    );

    // When
    await _endAs(tester, rules, runIn(const .won(), runTotal: 3000));

    // Then
    expect(tester.takeException(), isNull);
    expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsOneWidget);
    expect(find.text('Play again'), findsOneWidget);
    expect(find.text('Beat the boss'), findsNothing);
  });

  testWidgets('playing again after an unlock offers the jokers just unlocked', (
    tester,
  ) async {
    // Given: Rubble's boss beaten for the first time, its unlocks seen
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
      launch: .world,
      progressionStore: store,
      world: .rubble,
    );
    await _endAs(tester, rules, runIn(const .won(), runTotal: 3000));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // When
    await tester.tap(find.text('Play again'));
    await tester.pump();

    // Then
    expect(
      rules.configured.last.jokerPool,
      containsAll([JokerId.stonemason, JokerId.quarry]),
    );
  });

  testWidgets(
    'beating the boss after a revive shows the no-revive star as not earned',
    (tester) async {
      // Given: Rubble's boss beaten before, so the run goes straight to its end
      store.saved = store.saved.copyWith(
        worlds: {
          ...store.saved.worlds,
          WorldId.rubble: const WorldProgress(
            bossBeaten: true,
            stars: WorldStars(
              bossBeaten: true,
              noRevive: false,
              scoreThreshold: false,
            ),
            unlocked: true,
          ),
        },
      );
      final rules = await pumpGame(
        tester,
        runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
        launch: .world,
        progressionStore: store,
        world: .rubble,
      );

      // When: revived, then the boss beaten
      rules.next = (
        runIn(const .roundLost(reason: .noRoom), revivesUsed: 1, roundIndex: 1),
        const [],
      );
      await tester.tap(find.text('Revive · clear 2 rows + 3 pieces'));
      await tester.pumpAndSettle();
      await _endAs(
        tester,
        rules,
        runIn(const .won(), revivesUsed: 1, runTotal: 3000),
      );

      // Then
      expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsOneWidget);
      expect(
        _starOf(tester, 'Beat the boss without reviving').semanticLabel,
        'Star not earned yet',
      );
    },
  );

  testWidgets("a world run's end shows the stars it earned as new", (
    tester,
  ) async {
    // Given: Rubble's boss already beaten once, after a revive
    store.saved = store.saved.copyWith(
      worlds: {
        ...store.saved.worlds,
        WorldId.rubble: const WorldProgress(
          bossBeaten: true,
          stars: WorldStars(
            bossBeaten: true,
            noRevive: false,
            scoreThreshold: false,
          ),
          unlocked: true,
        ),
      },
    );
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
      launch: .world,
      progressionStore: store,
      world: .rubble,
    );

    // When: beaten again without a revive, short of the threshold
    await _endAs(tester, rules, runIn(const .won(), runTotal: 3000));

    // Then: straight to the end, the first star kept and the second new
    expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsOneWidget);
    expect(find.text('Beat the boss'), findsOneWidget);
    expect(find.text('Beat the boss without reviving'), findsOneWidget);
    expect(find.text('Reach 8,000'), findsOneWidget);
    expect(find.bySemanticsLabel('Star earned'), findsOneWidget);
    expect(find.bySemanticsLabel('New star'), findsOneWidget);
    expect(find.bySemanticsLabel('Star not earned yet'), findsOneWidget);
  });

  for (final (name, reduceMotion) in [
    ('pops in', false),
    ('keeps still under reduce motion', true),
  ]) {
    testWidgets('a new star $name', (tester) async {
      // Given
      final rules = await pumpGame(
        tester,
        runIn(const .roundLost(reason: .noRoom)),
        launch: .world,
        progressionStore: store,
        reduceMotion: reduceMotion,
        world: .rubble,
      );
      rules.next = (
        runIn(const .over(), runTotal: 9000),
        const [GameEvent.runOver(total: 9000)],
      );

      // When: the threshold reached, short of the boss
      await tester.tap(find.text('End run'));
      for (var frame = 0; frame < 4; frame++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Then
      final star = tester.widget<ScaleTransition>(
        find.ancestor(
          of: find.bySemanticsLabel('New star'),
          matching: find.byType(ScaleTransition),
        ),
      );
      expect(star.scale.value, reduceMotion ? 1.0 : lessThan(1.0));
      await tester.pumpAndSettle();
    });
  }

  group("the unlock sheet's cards", () {
    /// The angle [card]'s flip has left to turn, 0 once it is face up.
    double turnLeft(WidgetTester tester, String card) {
      final flip = tester.widget<Transform>(
        find
            .ancestor(of: find.text(card), matching: find.byType(Transform))
            .first,
      );

      return flip.transform.storage[8].abs();
    }

    Future<void> beatRubble(WidgetTester tester, {required bool still}) async {
      final rules = await pumpGame(
        tester,
        runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
        launch: .world,
        progressionStore: store,
        reduceMotion: still,
        world: .rubble,
      );
      rules.next = (
        runIn(const .won(), runTotal: 3000),
        const [GameEvent.runWon(total: 3000)],
      );
      await tester.tap(find.text('End run'));
      await tester.pump();
      await tester.pump();
    }

    testWidgets('flip in one after another', (tester) async {
      // Given / When: the sheet up, the first card turning
      await beatRubble(tester, still: false);
      await tester.pump(const Duration(milliseconds: 400));

      // Then: the first ahead of the second
      expect(
        turnLeft(tester, 'Stonemason'),
        lessThan(turnLeft(tester, 'Quarry')),
      );

      // When
      await tester.pumpAndSettle();

      // Then
      expect(turnLeft(tester, 'Stonemason'), closeTo(0, 1e-9));
      expect(turnLeft(tester, 'Quarry'), closeTo(0, 1e-9));
    });

    testWidgets('are face up at once under reduce motion', (tester) async {
      // Given / When
      await beatRubble(tester, still: true);

      // Then
      expect(turnLeft(tester, 'Stonemason'), closeTo(0, 1e-9));
      expect(turnLeft(tester, 'Quarry'), closeTo(0, 1e-9));
      await tester.pumpAndSettle();
    });

    testWidgets('turn face up at a tap', (tester) async {
      // Given: the cards still turning
      await beatRubble(tester, still: false);
      await tester.pump(const Duration(milliseconds: 350));

      // When
      await tester.tap(find.text('Stonemason'), warnIfMissed: false);
      await tester.pump();

      // Then
      expect(turnLeft(tester, 'Stonemason'), closeTo(0, 1e-9));
      expect(turnLeft(tester, 'Quarry'), closeTo(0, 1e-9));
      await tester.pumpAndSettle();
    });
  });

  testWidgets('a daily run earns no stars, so its end shows none', (
    tester,
  ) async {
    // Given / When
    await pumpGame(tester, runIn(const .won(), runTotal: 9000));

    // Then
    expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsOneWidget);
    expect(find.text('Beat the boss'), findsNothing);
  });

  testWidgets("a world run's header names its world", (tester) async {
    // Given / When
    await pumpGame(
      tester,
      runIn(const .playing()),
      launch: .world,
      world: .gravity,
    );

    // Then
    expect(find.text('Gravity · earn its three stars'), findsOneWidget);
  });
}
