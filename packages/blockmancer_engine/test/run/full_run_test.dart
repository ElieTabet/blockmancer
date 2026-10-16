import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

/// Plays a whole run with a fixed strategy: take the first offer, place the
/// move that clears the most lines (first in tray and row-major order on a
/// tie), revive when allowed, otherwise end the run.
(RunState, List<GameEvent>) _autoplay(int seed) {
  var state = startRun(config: defaultConfig, seed: seed);
  final log = <GameEvent>[];

  for (var step = 0; step < 2000; step++) {
    final List<GameEvent> events;

    switch (state.phase) {
      case PickingJokerPhase(:final offers):
        (state, events) = pickJoker(state, id: offers.first);
      case PlayingPhase():
        final (trayIndex, anchor) = _bestMove(state);
        (state, events) = place(state, anchor: anchor, trayIndex: trayIndex);
      case RoundLostPhase() when canRevive(state):
        (state, events) = revive(state);
      case RoundLostPhase():
        (state, events) = endRun(state);
      case WonPhase() || OverPhase():
        return (state, log);
    }

    log.addAll(events);
  }

  fail('the run did not end');
}

(int, Cell) _bestMove(RunState state) {
  (int, Cell)? best;
  var bestLines = -1;

  for (var trayIndex = 0; trayIndex < state.tray.length; trayIndex++) {
    for (var row = 0; row < Board.size; row++) {
      for (var col = 0; col < Board.size; col++) {
        final anchor = Cell(col: col, row: row);
        final result = preview(state, anchor: anchor, trayIndex: trayIndex);

        if (!result.fits) continue;

        final lines = result.clearingRows.length + result.clearingCols.length;

        if (lines > bestLines) {
          best = (trayIndex, anchor);
          bestLines = lines;
        }
      }
    }
  }

  return best!;
}

void main() {
  test('a seeded run plays to its end and replays identically', () {
    // Given
    const seed = 20261016;

    // When
    final (first, firstLog) = _autoplay(seed);
    final (again, againLog) = _autoplay(seed);

    // Then
    expect(again, first);
    expect(againLog, firstLog);
    expect(first.phase, anyOf(const RunPhase.won(), const RunPhase.over()));
  });

  test('the daily run of 20261016 is won the same way every time', () {
    // Given / When
    final (state, log) = _autoplay(20261016);

    // Then
    expect(state.phase, const RunPhase.won());
    expect(state.runTotal, 6850);
    expect(state.jokers, const [
      JokerId.pockets,
      JokerId.saver,
      JokerId.collector,
      JokerId.combo,
      JokerId.tiny,
    ]);
    expect(log.whereType<RoundWon>(), hasLength(5));
  });

  test('seed 4 revives once, loses again in round 2 and ends there', () {
    // Given / When
    final (state, log) = _autoplay(4);

    // Then
    expect(state.phase, const RunPhase.over());
    expect(state.roundIndex, 1);
    expect(state.runTotal, 1045);
    expect(state.revivesUsed, 1);
    expect(log.whereType<Revived>(), hasLength(1));
    expect(log.last, const GameEvent.runOver(total: 1045));
  });
}
