import 'package:blockmancer_engine/src/random/rng_stream.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';

/// The balance bot's move from [state]: the first joker of [build] on offer
/// (else any offer, see [_anyOffer]), the placement that scores the most right away
/// (fewest occupied cells after it on a tie, then the first in tray and
/// row-major order, bottom row first in Tide's boss, and never a flood while
/// a move that scores as much doesn't flood), a revive when allowed,
/// otherwise ending the run. Null once the run is over.
RunMove? greedyMove(
  RunState state, {
  required List<JokerId> build,
}) => switch (state.phase) {
  PickingJokerPhase(:final offers) => .pick(
    id: build.where(offers.contains).firstOrNull ?? _anyOffer(state, offers),
  ),
  PlayingPhase() => _bestPlacement(state),
  RoundLostPhase() when canRevive(state) => const .revive(),
  RoundLostPhase() => const .end(),
  WonPhase() || OverPhase() => null,
};

/// One of [offers], each as likely, drawn from the run's seed so a table is
/// reproducible. Not the first: the partner bias puts an owned joker's
/// partner there three times in four, so "the first offer" would chase pairs.
JokerId _anyOffer(RunState state, List<JokerId> offers) {
  final (index, _) = streamFor(
    index: state.pickIndex,
    runSeed: state.seed,
    stream: .botPicks,
  ).nextInt(offers.length);

  return offers[index];
}

RunMove _bestPlacement(RunState state) {
  RunMove? best;
  var bestGain = -1;
  var bestOccupied = Board.cellCount + 2;
  final before = liveRunTotal(state);
  // Ties go to the first placement scanned; from the top row, under a rising
  // board, that stacks every piece where the next rise floods.
  final bottomUp = state.config.world == .tide && state.round.isBoss;

  for (var trayIndex = 0; trayIndex < state.tray.length; trayIndex++) {
    if (state.tray[trayIndex] == null) continue;

    for (var scan = 0; scan < Board.size; scan++) {
      final row = bottomUp ? Board.size - 1 - scan : scan;

      for (var col = 0; col < Board.size; col++) {
        final anchor = Cell(col: col, row: row);

        if (!canPlace(state, anchor: anchor, trayIndex: trayIndex)) continue;

        final (next, _) = place(state, anchor: anchor, trayIndex: trayIndex);
        // The run total, so a winning move's bonuses count too.
        final gain = liveRunTotal(next) - before;
        // A flood leaves fewer cells, those it pushed off the top, but loses.
        final occupied =
            next.phase == const RunPhase.roundLost(reason: .flooded)
            ? Board.cellCount + 1
            : _occupiedAsSeen(state.board, next.board);

        if (gain > bestGain || (gain == bestGain && occupied < bestOccupied)) {
          best = .place(anchor: anchor, trayIndex: trayIndex);
          bestGain = gain;
          bestOccupied = occupied;
        }
      }
    }
  }

  // Playing means some tray piece fits: the engine settles otherwise.
  return best!;
}

/// The cells [after] occupies, a fog cell of [before] that turned to stone
/// counted as empty: whether fog hid a stone is the rules' secret, so the bot
/// may not prefer a move for what it would reveal.
int _occupiedAsSeen(Board before, Board after) => [
  for (var index = 0; index < Board.cellCount; index++)
    if (after.cells[index] is! EmptyCell &&
        !(before.cells[index] is FogCell && after.cells[index] is StoneCell))
      index,
].length;
