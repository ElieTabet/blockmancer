import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/drag_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';

void main() {
  late FakeGameRules rules;

  ProviderContainer container({
    FakeBestScores? bestScores,
    GameLaunch launch = .daily,
    Progression? progression,
    ProgressionStore? progressionStore,
    RewardedActionFun? rewardedAction,
    SavedRun? resumed,
    FakeRunStore? runStore,
    WorldId? world,
  }) {
    final container = ProviderContainer(
      overrides: gameOverrides(
        rules,
        bestScores: bestScores,
        launch: launch,
        progression: progression,
        progressionStore: progressionStore,
        rewardedAction: rewardedAction,
        resumed: resumed,
        runStore: runStore,
        world: world,
      ),
    );
    addTearDown(container.dispose);
    container.listen(gameProvider, (_, _) {});
    container.listen(dragProvider, (_, _) {});

    return container;
  }

  setUp(() => rules = FakeGameRules(start: runIn(const .playing())));

  test('a run starts from today’s seed with the rules’ own numbers', () {
    // Given / When
    container().read(gameProvider);

    // Then
    expect(rules.calls, ['startRun 1']);
  });

  test('a practice run counts for practice, on a seed of its own', () {
    // Given / When
    final state = container(launch: .practice).read(gameProvider);

    // Then
    expect(state.mode, const GameMode.practice());
    expect(rules.calls.single, isNot('startRun 1'));
  });

  test('playing practice again draws a new practice run', () {
    // Given
    final game = container(launch: .practice);
    rules.next = (runIn(const .over()), const [GameEvent.runOver(total: 1)]);
    game.read(gameProvider.notifier).endRun();

    // When
    game.read(gameProvider.notifier).retry();

    // Then
    expect(game.read(gameProvider).mode, const GameMode.practice());
    expect(
      rules.calls.where((call) => call.startsWith('startRun')),
      hasLength(2),
    );
  });

  group('the jokers a run may offer', () {
    test('are every joker in a daily run', () {
      // Given / When
      container().read(gameProvider);

      // Then
      expect(rules.configured.single.jokerPool, JokerId.values);
    });

    test("are only the player's in practice", () {
      // Given / When
      container(launch: .practice).read(gameProvider);

      // Then
      final (:jokerPool, :world) = rules.configured.single;
      expect(jokerPool, [JokerId.patience, JokerId.twin]);
      expect(world, WorldId.rubble);
    });

    test('are the ones the screen was opened with in a world run', () {
      // Given
      const progression = Progression(
        tutorialDone: true,
        unlockedJokers: {.quarry, .twin},
        worlds: {},
      );

      // When
      final state = container(
        launch: .world,
        progression: progression,
        world: .gravity,
      ).read(gameProvider);

      // Then
      expect(state.mode, const GameMode.world(world: .gravity));
      final (:jokerPool, :world) = rules.configured.single;
      expect(jokerPool, [JokerId.quarry, JokerId.twin]);
      expect(world, WorldId.gravity);
    });
  });

  test('playing a world again plays the same world on a new seed', () {
    // Given
    final game = container(launch: .world, world: .gravity);
    rules.next = (runIn(const .over()), const [GameEvent.runOver(total: 1)]);
    game.read(gameProvider.notifier).endRun();

    // When
    game.read(gameProvider.notifier).retry();

    // Then
    expect(game.read(gameProvider).mode, const GameMode.world(world: .gravity));
    expect(rules.configured.map((config) => config.world), [
      WorldId.gravity,
      WorldId.gravity,
    ]);
  });

  test('a move keeps what it did and counts as a new move', () {
    // Given
    final game = container();
    const events = [GameEvent.runOver(total: 10)];
    rules.next = (runIn(const .over()), events);

    // When
    game.read(gameProvider.notifier).endRun();

    // Then
    final state = game.read(gameProvider);
    expect(state.run.phase, const RunPhase.over());
    expect(state.lastEvents, events);
    expect(state.moveCount, 1);
  });

  test('a drop where the piece does not fit is ignored', () {
    // Given
    rules = FakeGameRules(
      start: runIn(
        const .playing(),
        board: Board.empty().withCells({
          const Cell(col: 0, row: 0): const .stone(),
        }),
      ),
    );
    final game = container();

    // When
    game
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);

    // Then
    expect(rules.calls, ['startRun 1']);
  });

  group('dragging', () {
    test('dropping where it fits places the piece there', () {
      // Given
      final game = container();
      final drag = game.read(dragProvider.notifier)
        ..begin(1)
        ..hover(const Cell(col: 3, row: 2));

      // When
      drag.drop();

      // Then
      expect(rules.calls.last, 'place 1 (2, 3)');
      expect(game.read(dragProvider), isNull);
    });

    test('dropping after moving off the board places nothing', () {
      // Given
      final game = container();
      final drag = game.read(dragProvider.notifier)
        ..begin(0)
        ..hover(const Cell(col: 3, row: 3))
        ..hover(null);

      // When
      drag.drop();

      // Then
      expect(rules.calls, ['startRun 1']);
    });

    test('the shadow is recomputed only when the hovered cell changes', () {
      // Given
      final game = container();
      final drag = game.read(dragProvider.notifier)..begin(0);
      var emissions = 0;
      game.listen(dragProvider, (_, _) => emissions++);

      // When
      drag
        ..hover(const Cell(col: 1, row: 1))
        ..hover(const Cell(col: 1, row: 1))
        ..hover(const Cell(col: 2, row: 1));

      // Then
      expect(emissions, 2);
    });
  });

  group('forwarding', () {
    test('taking a joker and ending go to the rules', () {
      // Given
      final notifier = container().read(gameProvider.notifier);

      // When
      notifier
        ..pickJoker(.twin)
        ..endRun();

      // Then
      expect(rules.calls.skip(1), ['pickJoker JokerId.twin', 'endRun']);
    });

    test('retrying starts today’s run again from scratch', () {
      // Given
      final game = container();
      rules.next = (runIn(const .over()), const [GameEvent.runOver(total: 1)]);
      game.read(gameProvider.notifier).endRun();

      // When
      game.read(gameProvider.notifier).retry();

      // Then
      final state = game.read(gameProvider);
      expect(state.run, rules.start);
      expect(state.moveCount, 0);
      expect(state.lastEvents, isEmpty);
    });
  });

  group('the drag shadow', () {
    test('an empty tray slot starts no drag', () {
      // Given
      rules = FakeGameRules(
        start: runIn(const .playing(), tray: const [null, 0, 0]),
      );
      final game = container();

      // When
      game.read(dragProvider.notifier).begin(0);

      // Then
      expect(game.read(dragProvider), isNull);
    });

    test('a cancelled drag clears the shadow and places nothing', () {
      // Given
      final game = container();
      final drag = game.read(dragProvider.notifier)
        ..begin(0)
        ..hover(const Cell(col: 1, row: 1));

      // When
      drag.cancel();

      // Then
      expect(game.read(dragProvider), isNull);
      expect(rules.calls, ['startRun 1']);
    });

    test('dropping where the piece does not fit places nothing', () {
      // Given
      rules = FakeGameRules(
        start: runIn(
          const .playing(),
          board: Board.empty().withCells({
            const Cell(col: 2, row: 2): const .stone(),
          }),
        ),
      );
      final game = container();
      final drag = game.read(dragProvider.notifier)
        ..begin(0)
        ..hover(const Cell(col: 2, row: 2));

      // When
      drag.drop();

      // Then
      expect(rules.calls, ['startRun 1']);
    });
  });

  group('reviving', () {
    setUp(
      () => rules = FakeGameRules(
        start: runIn(const .roundLost(reason: .outOfPieces)),
      ),
    );

    test('revives once the reward has been earned', () async {
      // Given
      final game = container();
      final revived = runIn(const .playing(), revivesUsed: 1);
      rules.next = (
        revived,
        const [
          GameEvent.revived(rows: [0, 1]),
        ],
      );

      // When
      await game.read(gameProvider.notifier).revive();

      // Then
      expect(rules.calls.last, 'revive');
      expect(game.read(gameProvider).run, revived);
    });

    test('a second tap while the reward shows asks for it once', () async {
      // Given
      final reward = Completer<bool>();
      var shown = 0;
      final game = container(
        rewardedAction: () {
          shown++;

          return reward.future;
        },
      );
      rules.next = (runIn(const .playing(), revivesUsed: 1), const []);
      final notifier = game.read(gameProvider.notifier);

      // When
      final first = notifier.revive();
      final second = notifier.revive();
      reward.complete(true);
      await Future.wait([first, second]);

      // Then
      expect(shown, 1);
      expect(rules.calls.where((call) => call == 'revive'), hasLength(1));
    });

    test('a run ended while the reward shows is not revived', () async {
      // Given
      final reward = Completer<bool>();
      final game = container(rewardedAction: () => reward.future);
      final notifier = game.read(gameProvider.notifier);
      final reviving = notifier.revive();

      // When
      rules.next = (runIn(const .over()), const [GameEvent.runOver(total: 0)]);
      notifier.endRun();
      reward.complete(true);
      await reviving;

      // Then
      expect(rules.calls, isNot(contains('revive')));
      expect(game.read(gameProvider).run.phase, const RunPhase.over());
    });

    test('a reward that fails to show leaves the round lost', () async {
      // Given
      final game = container(
        rewardedAction: () async => throw StateError('no ad'),
      );

      // When
      await game.read(gameProvider.notifier).revive();

      // Then
      expect(rules.calls, isNot(contains('revive')));
      expect(
        game.read(gameProvider).run.phase,
        const RunPhase.roundLost(reason: .outOfPieces),
      );
    });

    test('no reward is asked for once the revive is spent', () async {
      // Given
      rules = FakeGameRules(
        start: runIn(const .roundLost(reason: .noRoom), revivesUsed: 1),
      );
      var shown = 0;
      final game = container(
        rewardedAction: () async {
          shown++;

          return true;
        },
      );

      // When
      await game.read(gameProvider.notifier).revive();

      // Then
      expect(shown, 0);
    });

    test('a reward not earned leaves the round lost', () async {
      // Given
      final game = container(rewardedAction: () async => false);

      // When
      await game.read(gameProvider.notifier).revive();

      // Then
      expect(rules.calls, isNot(contains('revive')));
      expect(
        game.read(gameProvider).run.phase,
        const RunPhase.roundLost(reason: .outOfPieces),
      );
    });
  });

  group('when the run ends', () {
    test('a first run of the day becomes its best', () async {
      // Given
      final scores = FakeBestScores();
      final game = container(bestScores: scores);
      rules.next = (
        runIn(const .over(), runTotal: 1450),
        const [GameEvent.runOver(total: 1450)],
      );

      // When
      game.read(gameProvider.notifier).endRun();
      await pumpEventQueue();

      // Then
      expect(
        game.read(gameProvider).record,
        const RunEndRecord(best: 1450, isNewBest: true),
      );
      expect(scores.saved[testDay], 1450);
    });

    test('a run short of the day’s best says what the best is', () async {
      // Given
      final scores = FakeBestScores()..saved[testDay] = 3000;
      final game = container(bestScores: scores);
      rules.next = (
        runIn(const .won(), runTotal: 2100),
        const [GameEvent.runWon(total: 2100)],
      );

      // When
      game.read(gameProvider.notifier).endRun();
      await pumpEventQueue();

      // Then
      expect(
        game.read(gameProvider).record,
        const RunEndRecord(best: 3000, isNewBest: false),
      );
    });

    test(
      'a best read after starting again stays with the run it was for',
      () async {
        // Given
        final scores = FakeBestScores()..gate = Completer<void>();
        final game = container(bestScores: scores);
        rules.next = (
          runIn(const .over(), runTotal: 1450),
          const [GameEvent.runOver(total: 1450)],
        );
        game.read(gameProvider.notifier).endRun();

        // When
        game.read(gameProvider.notifier).retry();
        scores.gate!.complete();
        await pumpEventQueue();

        // Then
        expect(game.read(gameProvider).record, isNull);
        expect(scores.saved[testDay], 1450);
      },
    );

    test(
      'a best that cannot be read leaves the run ended, without one',
      () async {
        // Given
        final scores = FakeBestScores()..broken = true;
        final game = container(bestScores: scores);
        rules.next = (
          runIn(const .over(), runTotal: 1450),
          const [GameEvent.runOver(total: 1450)],
        );

        // When
        game.read(gameProvider.notifier).endRun();
        await pumpEventQueue();

        // Then
        expect(game.read(gameProvider).run.phase, const RunPhase.over());
        expect(game.read(gameProvider).record, isNull);
      },
    );
  });

  group('when a world run ends', () {
    late FakeProgressionStore store;

    setUp(() => store = FakeProgressionStore(startingProgression(rules)));

    test('beating its boss keeps and shows what it unlocked', () async {
      // Given
      final game = container(
        launch: .world,
        progressionStore: store,
        world: .rubble,
      );
      rules.next = (runIn(const .won()), const [GameEvent.runWon(total: 0)]);

      // When
      game.read(gameProvider.notifier).endRun();
      await pumpEventQueue();

      // Then
      final progress = game.read(gameProvider).progress;
      expect(progress?.unlockedWorld, WorldId.gravity);
      expect(progress?.unlockedJokers, [JokerId.stonemason, JokerId.quarry]);
      expect(store.saved.worlds[WorldId.gravity]?.unlocked, isTrue);
    });

    test('what it unlocked is shown once, then the run end', () async {
      // Given
      final game = container(
        launch: .world,
        progressionStore: store,
        world: .rubble,
      );
      rules.next = (runIn(const .won()), const [GameEvent.runWon(total: 0)]);
      game.read(gameProvider.notifier).endRun();
      await pumpEventQueue();

      // When
      game.read(gameProvider.notifier).closeUnlocks();

      // Then
      expect(game.read(gameProvider).unlocksSeen, isTrue);
    });

    test('a daily run leaves the map as it was', () async {
      // Given
      final before = store.saved;
      final game = container(progressionStore: store);
      rules.next = (runIn(const .won()), const [GameEvent.runWon(total: 0)]);

      // When
      game.read(gameProvider.notifier).endRun();
      await pumpEventQueue();

      // Then
      expect(game.read(gameProvider).progress, isNull);
      expect(store.saved, before);
    });
  });

  group('saving the run', () {
    test('opening a run keeps the saved one until its first action', () async {
      // Given
      final saved = SavedRun(
        mode: const .practice(),
        run: runIn(const .playing()),
      );
      final store = FakeRunStore()..saved = saved;

      // When
      container(runStore: store).read(gameProvider);
      await pumpEventQueue();

      // Then
      expect(store.saved, saved);
    });

    test("a new run's first pick replaces the saved one", () async {
      // Given
      final store = FakeRunStore()
        ..saved = SavedRun(
          mode: const .practice(),
          run: runIn(const .playing()),
        );
      final game = container(runStore: store);
      final picked = runIn(const .playing(), jokers: const [.twin]);
      rules.next = (picked, const []);

      // When
      game.read(gameProvider.notifier).pickJoker(.twin);
      await pumpEventQueue();

      // Then
      expect(store.saved, SavedRun(mode: testDay, run: picked));
    });

    test('every move is saved as it leaves the run', () async {
      // Given
      final store = FakeRunStore();
      final game = container(runStore: store);
      final after = runIn(const .playing(), score: 9);
      rules.next = (after, const []);

      // When
      game
          .read(gameProvider.notifier)
          .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
      await pumpEventQueue();

      // Then
      expect(store.saved, SavedRun(mode: testDay, run: after));
    });

    test('a finished run is forgotten', () async {
      // Given
      final store = FakeRunStore();
      final game = container(runStore: store);
      rules.next = (runIn(const .over()), const [GameEvent.runOver(total: 0)]);

      // When
      game.read(gameProvider.notifier).endRun();
      await pumpEventQueue();

      // Then
      expect(store.saved, isNull);
    });

    test('putting the app away saves the run as it stands', () async {
      // Given
      final store = FakeRunStore();
      final game = container(runStore: store);

      // When
      game.read(gameProvider.notifier).persist();
      await pumpEventQueue();

      // Then
      expect(store.saved, SavedRun(mode: testDay, run: rules.start));
    });
  });

  group('resuming', () {
    test('picks up the saved run where it stood', () {
      // Given
      final saved = SavedRun(
        mode: const .practice(),
        run: runIn(const .playing(), score: 640, storedMult: 6),
      );

      // When
      final state = container(
        launch: .resume,
        resumed: saved,
      ).read(gameProvider);

      // Then
      expect(state.run, saved.run);
      expect(state.mode, const GameMode.practice());
      expect(rules.calls, isEmpty);
    });

    test("a save that couldn't be read starts today's run instead", () {
      // Given / When
      final state = container(launch: .resume).read(gameProvider);

      // Then
      expect(state.mode, testDay);
      expect(rules.calls, ['startRun 1']);
    });
  });
}
