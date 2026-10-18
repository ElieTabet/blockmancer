import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';
import '../pump_game.dart';

void main() {
  testWidgets(
    'continuing a run opens it on the board, tray and score it was left with',
    (tester) async {
      // Given: a run saved mid-round
      final rules = FakeGameRules(start: runIn(const .playing()));
      final store = FakeRunStore()
        ..saved = SavedRun(
          mode: testDay,
          run: runIn(const .playing(), score: 640, piecesLeft: 9),
        );

      // When
      await tester.pumpWidget(
        ProviderScope(
          overrides: gameOverrides(rules, runStore: store),
          child: TranslationProvider(
            child: MaterialApp(
              theme: DSTheme.instance.darkTheme,
              home: const GamePage(launch: .resume),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Then
      expect(find.textContaining('640 ', findRichText: true), findsOneWidget);
      expect(find.text('12 pieces left'), findsOneWidget);
      expect(rules.calls, isEmpty);
    },
  );

  testWidgets('putting the app away saves the run', (tester) async {
    // Given
    final store = FakeRunStore();
    await pumpGame(tester, runIn(const .playing()), runStore: store);

    // When
    for (final state in const [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();

    // Then
    expect(store.saved, isNotNull);
  });

  for (final (name, store) in [
    ('nothing is saved', FakeRunStore()),
    ('the save is out of reach', _UnreachableRunStore()),
  ]) {
    testWidgets(
      'continuing when $name starts today’s run, saving nothing yet',
      (tester) async {
        // Given
        final rules = FakeGameRules(
          start: runIn(const .pickingJoker(offers: [.twin]), pickIndex: 0),
        );

        // When
        await tester.pumpWidget(
          ProviderScope(
            overrides: gameOverrides(rules, runStore: store),
            child: TranslationProvider(
              child: MaterialApp(
                theme: DSTheme.instance.darkTheme,
                home: const GamePage(launch: .resume),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump();

        // Then
        expect(find.text('Pick your starting joker'), findsOneWidget);
        expect(rules.calls, ['startRun 1']);
        if (store is FakeRunStore) expect(store.saved, isNull);
      },
    );
  }

  testWidgets(
    'a world run continued, revived and then won celebrates its unlock and '
    'keeps only the first star',
    (tester) async {
      // Given: a Rubble run saved on its boss's lost round
      final rules = FakeGameRules(start: runIn(const .playing()));
      final progression = FakeProgressionStore(startingProgression(rules));
      final runs = FakeRunStore()
        ..saved = SavedRun(
          mode: const .world(world: .rubble),
          run: runIn(const .roundLost(reason: .noRoom), roundIndex: 1),
        );
      await tester.pumpWidget(
        ProviderScope(
          overrides: gameOverrides(
            rules,
            progressionStore: progression,
            runStore: runs,
          ),
          child: TranslationProvider(
            child: MaterialApp(
              theme: DSTheme.instance.darkTheme,
              home: const GamePage(launch: .resume),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // When: revived, then the boss beaten
      rules.next = (
        runIn(const .roundLost(reason: .noRoom), revivesUsed: 1, roundIndex: 1),
        const [],
      );
      await tester.tap(find.text('Watch an ad to revive'));
      await tester.pumpAndSettle();
      rules.next = (
        runIn(const .won(), revivesUsed: 1, runTotal: 3000),
        const [GameEvent.runWon(total: 3000)],
      );
      await tester.tap(find.text('End run'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('New world: Gravity'), findsOneWidget);
      expect(
        progression.saved.worlds[WorldId.rubble]?.stars,
        const WorldStars(
          bossBeaten: true,
          noRevive: false,
          scoreThreshold: false,
        ),
      );
    },
  );

  group('a world run', () {
    Future<FakeGameRules> openWorld(
      WidgetTester tester,
      ProgressionStore store, {
      WorldId world = .gravity,
    }) async {
      final rules = FakeGameRules(
        start: runIn(const .pickingJoker(offers: [.twin]), pickIndex: 0),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: gameOverrides(rules, progressionStore: store),
          child: TranslationProvider(
            child: MaterialApp(
              theme: DSTheme.instance.darkTheme,
              home: GamePage(launch: .world, world: world),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      return rules;
    }

    testWidgets("offers the jokers this device's progression unlocked", (
      tester,
    ) async {
      // Given
      final store = FakeProgressionStore(
        const Progression(
          jokerStats: {},
          tutorialDone: true,
          unannouncedJokers: {},
          unlockedJokers: {.quarry, .twin},
          worlds: {},
        ),
      );

      // When
      final rules = await openWorld(tester, store);

      // Then
      expect(find.text('Pick your starting joker'), findsOneWidget);
      final (:jokerPool, :world) = rules.configured.single;
      expect(jokerPool, [JokerId.quarry, JokerId.twin]);
      expect(world, WorldId.gravity);
    });

    testWidgets(
      "offers a new player's jokers when the progression is out of reach",
      (tester) async {
        // Given / When
        final rules = await openWorld(tester, _UnreachableProgressionStore());

        // Then
        expect(find.text('Pick your starting joker'), findsOneWidget);
        expect(rules.configured.single.jokerPool, [
          JokerId.patience,
          JokerId.twin,
        ]);
      },
    );

    testWidgets("naming a world that is coming soon plays the map's first", (
      tester,
    ) async {
      // Given / When
      final rules = await openWorld(
        tester,
        FakeProgressionStore(
          startingProgression(FakeGameRules(start: runIn(const .playing()))),
        ),
        world: .fog,
      );

      // Then
      expect(tester.takeException(), isNull);
      expect(find.text('Pick your starting joker'), findsOneWidget);
      expect(rules.configured.single.world, WorldId.rubble);
    });
  });
}

/// Progression storage that can't be reached at all.
final class _UnreachableProgressionStore implements ProgressionStore {
  @override
  Future<Progression> load() => Future.error(StateError('no storage'));

  @override
  Future<void> save(Progression progression) => throw StateError('no storage');
}

/// Storage that can't be reached at all.
final class _UnreachableRunStore implements RunStore {
  @override
  Future<void> clear() => throw StateError('no storage');

  @override
  Future<SavedRun?> load() => Future.error(StateError('no storage'));

  @override
  Future<void> save(SavedRun run) => throw StateError('no storage');
}
