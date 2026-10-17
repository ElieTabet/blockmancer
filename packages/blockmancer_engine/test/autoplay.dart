import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/replay.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import 'brief_config.dart';

/// A whole run played with a fixed strategy, and what it did.
typedef Autoplayed = ({
  List<GameEvent> events,
  List<RunMove> moves,
  RunState state,
});

/// Plays the run of [seed] under [config] to its end: take the first joker of
/// [build] on offer, else the first offer; place the move that clears the most lines
/// (first in tray and row-major order on a tie); revive when allowed,
/// otherwise end the run.
Autoplayed autoplay(
  int seed, {
  List<JokerId> build = const [],
  RunConfig config = briefConfig,
}) {
  var state = startRun(config: config, seed: seed);
  final events = <GameEvent>[];
  final moves = <RunMove>[];

  for (var step = 0; step < 2000; step++) {
    final RunMove move;

    switch (state.phase) {
      case PickingJokerPhase(:final offers):
        move = .pick(
          id: build.where(offers.contains).firstOrNull ?? offers.first,
        );
      case PlayingPhase():
        final (trayIndex, anchor) = _bestMove(state);
        move = .place(anchor: anchor, trayIndex: trayIndex);
      case RoundLostPhase() when canRevive(state):
        move = const .revive();
      case RoundLostPhase():
        move = const .end();
      case WonPhase() || OverPhase():
        return (events: events, moves: moves, state: state);
    }

    final (next, happened) = applyMove(state, move);
    state = next;
    events.addAll(happened);
    moves.add(move);
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
