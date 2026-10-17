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
    RewardedActionFun? rewardedAction,
  }) {
    final container = ProviderContainer(
      overrides: gameOverrides(
        rules,
        bestScores: bestScores,
        rewardedAction: rewardedAction,
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
}
