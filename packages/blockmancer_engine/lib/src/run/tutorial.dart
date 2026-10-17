import 'package:blockmancer_engine/src/random/rng_stream.dart';
import 'package:shared_domain/shared_domain.dart';

/// The cell missing from the otherwise full bottom row.
const _gap = Cell(col: 3, row: Board.size - 1);
const _pieces = 99;
const _seed = 1;

/// Out of reach, so the round is never won on its own.
const _target = 1000000;

/// A single, a horizontal domino and a small L: the single fills [_gap].
const _tray = <int?>[0, 1, 5];

/// The guided first run: a fixed board and tray, in play with no joker.
RunState tutorialRun({required RunConfig config}) => RunState(
  board: Board.empty().withCells({
    for (var col = 0; col < Board.size; col++)
      if (col != _gap.col)
        Cell(col: col, row: _gap.row): .filled(
          colorIndex: col % Shape.colorCount,
        ),
  }),
  config: config.copyWith(
    rounds: const [
      RoundSpec(isBoss: false, pieces: _pieces, stones: 0, target: _target),
    ],
  ),
  jokers: const [],
  phase: const .playing(),
  pickIndex: 1,
  piecesLeft: _pieces - _tray.length,
  piecesRngState: deriveSeed(index: 0, runSeed: _seed, stream: .pieces),
  revivesUsed: 0,
  roundIndex: 0,
  runTotal: 0,
  score: 0,
  seed: _seed,
  stonesRngState: deriveSeed(index: 0, runSeed: _seed, stream: .stones),
  storedMult: 0,
  streak: 0,
  tray: _tray,
);
