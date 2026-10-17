import 'package:blockmancer_engine/src/random/rng_stream.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';

/// The balance bot's move from [state]: the first joker of [build] on offer
/// (else any offer, see [_anyOffer]), the placement that scores the most right away
/// (fewest occupied cells after it on a tie, then the first in tray and
/// row-major order), a revive when allowed, otherwise ending the run. Null
/// once the run is over.
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
  var bestOccupied = Board.cellCount + 1;
  final before = liveRunTotal(state);

  for (var trayIndex = 0; trayIndex < state.tray.length; trayIndex++) {
    if (state.tray[trayIndex] == null) continue;

    for (var row = 0; row < Board.size; row++) {
      for (var col = 0; col < Board.size; col++) {
        final anchor = Cell(col: col, row: row);

        if (!canPlace(state, anchor: anchor, trayIndex: trayIndex)) continue;

        final (next, _) = place(state, anchor: anchor, trayIndex: trayIndex);
        // The run total, so a winning move's bonuses count too.
        final gain = liveRunTotal(next) - before;
        final occupied = Board.cellCount - next.board.emptyCells.length;

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
