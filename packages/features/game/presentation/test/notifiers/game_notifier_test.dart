import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/notifiers/drag_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';

void main() {
  late FakeGameRules rules;

  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: bindProviders(gameRules: (ref) => rules),
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

    test('dropping off the board places nothing', () {
      // Given
      final game = container();
      final drag = game.read(dragProvider.notifier)
        ..begin(0)
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
}
