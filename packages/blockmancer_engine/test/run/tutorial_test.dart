import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/tutorial.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

/// Shape ids: 0 single, 1 horizontal domino, 5 small L.
void main() {
  const gap = Cell(col: 3, row: 7);

  test('the tutorial is in play straight away, with no joker', () {
    // Given / When
    final tutorial = tutorialRun(config: defaultConfig);

    // Then
    expect(tutorial.phase, const RunPhase.playing());
    expect(tutorial.jokers, isEmpty);
    expect(tutorial.tray, [0, 1, 5]);
  });

  test('its bottom row is full but one cell, and the rest is empty', () {
    // Given / When
    final board = tutorialRun(config: defaultConfig).board;

    // Then
    expect(board.occupiedInRow(7), 7);
    expect(board.at(gap), isA<EmptyCell>());
    expect(board.cells.where((cell) => cell is! EmptyCell), hasLength(7));
  });

  test('the single dropped in the gap clears the bottom row and scores', () {
    // Given
    final tutorial = tutorialRun(config: defaultConfig);

    // When
    final (next, events) = place(tutorial, anchor: gap, trayIndex: 0);

    // Then
    expect(events.whereType<LinesCleared>().single.rows, [7]);
    expect(next.board.isEmpty, isTrue);
    expect(next.score, 1 + 10 * 8);
    expect(next.phase, const RunPhase.playing());
  });

  test('any legal spot takes the first piece without ending the round', () {
    // Given
    final tutorial = tutorialRun(config: defaultConfig);

    // When
    final (next, _) = place(
      tutorial,
      anchor: const Cell(col: 0, row: 0),
      trayIndex: 1,
    );

    // Then
    expect(next.phase, const RunPhase.playing());
    expect(next.piecesRemaining, greaterThan(20));
  });

  test('its round is out of reach, so it never ends on a win', () {
    // Given / When
    final tutorial = tutorialRun(config: defaultConfig);

    // Then
    expect(tutorial.round.target, greaterThan(100000));
    expect(tutorial.isLastRound, isTrue);
  });

  test('the tutorial is the same every time', () {
    // Given / When
    final first = tutorialRun(config: defaultConfig);
    final again = tutorialRun(config: defaultConfig);

    // Then
    expect(again, first);
  });

  test('the tray refills the same way every time', () {
    // Given
    RunState playedOut() {
      var state = tutorialRun(config: defaultConfig);
      state = place(state, anchor: gap, trayIndex: 0).$1;
      state = place(state, anchor: const Cell(col: 0, row: 0), trayIndex: 1).$1;

      return place(state, anchor: const Cell(col: 0, row: 2), trayIndex: 2).$1;
    }

    // When
    final first = playedOut();
    final again = playedOut();

    // Then
    expect(first.tray.whereType<int>(), hasLength(3));
    expect(again, first);
  });
}
