import 'package:blockmancer_engine/src/board/board.br.dart';
import 'package:blockmancer_engine/src/board/cell.br.dart';
import 'package:blockmancer_engine/src/board/cell_state.br.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/events/game_event.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:blockmancer_engine/src/random/rng_stream.dart';
import 'package:blockmancer_engine/src/random/weighted_draw.dart';
import 'package:blockmancer_engine/src/run/loss_reason.dart';
import 'package:blockmancer_engine/src/run/offers.dart';
import 'package:blockmancer_engine/src/run/placement_preview.br.dart';
import 'package:blockmancer_engine/src/run/run_config.br.dart';
import 'package:blockmancer_engine/src/run/run_phase.br.dart';
import 'package:blockmancer_engine/src/run/run_state.br.dart';
import 'package:blockmancer_engine/src/scoring/score_move.dart';

/// The next state and what happened on the way, in order.
typedef Transition = (RunState, List<GameEvent>);

/// A new run, waiting for its starting joker.
RunState startRun({required RunConfig config, required int seed}) => RunState(
  board: Board.empty(),
  config: config,
  jokers: const [],
  phase: .pickingJoker(
    offers: offersFor(
      config: config,
      owned: const [],
      pickIndex: 0,
      seed: seed,
    ),
  ),
  pickIndex: 0,
  piecesLeft: 0,
  piecesRng: streamFor(seed, .pieces, 0),
  revivesUsed: 0,
  roundIndex: 0,
  runTotal: 0,
  score: 0,
  seed: seed,
  stonesRng: streamFor(seed, .stones, 0),
  storedMult: 0,
  streak: 0,
  tray: List.filled(config.traySize, null),
);

/// Takes an offered joker and starts the next round.
Transition pickJoker(RunState state, JokerId id) {
  final phase = state.phase;

  if (phase is! PickingJokerPhase) {
    throw StateError('No joker is on offer in ${state.phase}');
  }

  if (!phase.offers.contains(id)) {
    throw ArgumentError.value(id, 'id', 'is not on offer');
  }

  return _startRound(state.copyWith(jokers: [...state.jokers, id]));
}

bool canPlace(RunState state, int trayIndex, Cell anchor) {
  final shapeId = _trayShape(state, trayIndex);

  return state.phase is PlayingPhase &&
      shapeId != null &&
      fits(state.board, shapeCatalog[shapeId], anchor);
}

/// Whether the tray piece at [trayIndex] fits anywhere on the board.
bool fitsSomewhere(RunState state, int trayIndex) {
  final shapeId = _trayShape(state, trayIndex);

  return shapeId != null && fitsAnywhere(state.board, shapeCatalog[shapeId]);
}

PlacementPreview preview(RunState state, int trayIndex, Cell anchor) {
  final shapeId = _trayShape(state, trayIndex);

  if (shapeId == null) return PlacementPreview.none;

  final shape = shapeCatalog[shapeId];
  final cells = [
    for (final offset in shape.cells)
      if (state.board.contains(anchor + offset)) anchor + offset,
  ];
  final fitsHere =
      cells.length == shape.size && fits(state.board, shape, anchor);
  final placed = fitsHere ? placeShape(state.board, shape, anchor) : null;

  return PlacementPreview(
    cells: cells,
    clearingCols: placed?.fullCols ?? const [],
    clearingRows: placed?.fullRows ?? const [],
    colliding: [
      for (final cell in cells)
        if (state.board.at(cell) is! EmptyCell) cell,
    ],
    fits: fitsHere,
  );
}

/// Drops the tray piece at [trayIndex] with its top-left at [anchor], clears,
/// scores, refills the tray, then decides whether the round is won or lost.
Transition place(
  RunState state, {
  required Cell anchor,
  required int trayIndex,
}) {
  if (!canPlace(state, trayIndex, anchor)) {
    throw ArgumentError('Tray piece $trayIndex cannot be placed at $anchor');
  }

  final shapeId = state.tray[trayIndex]!;
  final shape = shapeCatalog[shapeId];
  final jokers = effectsOf(state.jokers);
  final clear = resolveClears(placeShape(state.board, shape, anchor));

  final score = scoreMove(
    clear: clear,
    jokers: jokers,
    pieceSize: shape.size,
    previousStreak: state.streak,
    stonesRng: state.stonesRng,
    storedMult: state.storedMult,
  );

  final events = <GameEvent>[
    GameEvent.piecePlaced(
      anchor: anchor,
      cells: [for (final offset in shape.cells) anchor + offset],
      shapeId: shapeId,
      trayIndex: trayIndex,
    ),
    if (clear.clearedAny)
      GameEvent.linesCleared(
        cells: clear.cells,
        cols: clear.cols,
        rows: clear.rows,
      ),
    ...score.fired,
    GameEvent.scoreAdded(
      chips: score.chips,
      mult: score.mult,
      total: score.points,
    ),
    for (final cell in score.stonesDropped) GameEvent.stonePlaced(cell: cell),
  ];

  var next = state.copyWith(
    board: score.board,
    score: state.score + score.points,
    stonesRng: score.stonesRng,
    storedMult: score.storedMult,
    streak: score.streak,
    tray: [...state.tray]..[trayIndex] = null,
  );
  next = _refillIfEmpty(next, jokers, events);

  if (next.score >= next.round.target) return _winRound(next, jokers, events);

  return _settle(next, events);
}

/// Empties the fullest rows and adds pieces to a lost round, once per
/// [RunConfig.revivesPerRun]. A board still stuck afterwards loses again.
Transition revive(RunState state) {
  if (!state.canRevive) throw StateError('Cannot revive in ${state.phase}');

  final rows = List.generate(Board.size, (row) => row)
    ..sort((a, b) {
      final byOccupancy =
          state.board.occupiedInRow(b) - state.board.occupiedInRow(a);

      return byOccupancy != 0 ? byOccupancy : a - b;
    });
  final cleared = rows.take(state.config.reviveRows).toList()..sort();

  final events = <GameEvent>[GameEvent.revived(rows: cleared)];

  final next = state.copyWith(
    board: state.board.withCells({
      for (final row in cleared)
        for (var col = 0; col < Board.size; col++)
          Cell(col: col, row: row): const CellState.empty(),
    }),
    piecesLeft: state.piecesLeft + state.config.revivePieces,
    revivesUsed: state.revivesUsed + 1,
  );

  return _settle(_refillIfEmpty(next, effectsOf(state.jokers), events), events);
}

/// Gives up after a lost round, banking its score.
Transition endRun(RunState state) {
  if (state.phase is! RoundLostPhase) {
    throw StateError('Cannot end the run in ${state.phase}');
  }

  final total = state.runTotal + state.score;

  return (
    state.copyWith(phase: const .over(), runTotal: total),
    [GameEvent.runOver(total: total)],
  );
}

(List<int?>, int, Mulberry32) _draw({
  required List<JokerEffect> jokers,
  required int piecesLeft,
  required Mulberry32 rng,
  required int traySize,
}) {
  final count = piecesLeft < traySize ? piecesLeft : traySize;
  final weights = pieceWeights(jokers);
  final tray = <int?>[];
  var next = rng;

  for (var slot = 0; slot < traySize; slot++) {
    if (slot < count) {
      final (shapeId, afterDraw) = weightedIndex(next, weights);
      tray.add(shapeId);
      next = afterDraw;
    } else {
      tray.add(null);
    }
  }

  return (tray, piecesLeft - count, next);
}

RunState _refillIfEmpty(
  RunState state,
  List<JokerEffect> jokers,
  List<GameEvent> events,
) {
  if (state.tray.any((slot) => slot != null) || state.piecesLeft == 0) {
    return state;
  }

  final (tray, piecesLeft, piecesRng) = _draw(
    jokers: jokers,
    piecesLeft: state.piecesLeft,
    rng: state.piecesRng,
    traySize: state.config.traySize,
  );
  events.add(GameEvent.trayRefilled(tray: tray));

  return state.copyWith(
    piecesLeft: piecesLeft,
    piecesRng: piecesRng,
    tray: tray,
  );
}

/// Playing on, or lost: out of pieces, or none of the tray fits.
Transition _settle(RunState state, List<GameEvent> events) {
  final pieces = state.tray.whereType<int>();

  LossReason? reason;

  if (pieces.isEmpty) {
    reason = .outOfPieces;
  } else if (!pieces.any((id) => fitsAnywhere(state.board, shapeCatalog[id]))) {
    reason = .noRoom;
  }

  if (reason == null) return (state.copyWith(phase: const .playing()), events);

  return (
    state.copyWith(phase: .roundLost(reason: reason)),
    [...events, GameEvent.roundLost(reason: reason)],
  );
}

/// Sets up round [RunState.pickIndex]: its stones, its pieces and a full tray.
Transition _startRound(RunState state) {
  final roundIndex = state.pickIndex;
  final spec = state.config.rounds[roundIndex];
  final jokers = effectsOf(state.jokers);
  final setup = roundSetup(
    jokers,
    RoundSetup(pieces: spec.pieces, stones: spec.stones),
  );

  final events = <GameEvent>[
    GameEvent.roundStarted(
      pieces: setup.pieces,
      roundIndex: roundIndex,
      target: spec.target,
    ),
    ...setup.fired,
  ];

  var board = Board.empty();
  var stonesRng = streamFor(state.seed, .stones, roundIndex);

  for (var stone = 0; stone < setup.stones; stone++) {
    final empties = board.emptyCells;

    if (empties.isEmpty) break;

    final (index, next) = stonesRng.nextInt(empties.length);
    stonesRng = next;
    board = board.withCells({empties[index]: const CellState.stone()});
    events.add(GameEvent.stonePlaced(cell: empties[index]));
  }

  final round = state.copyWith(
    board: board,
    pickIndex: roundIndex + 1,
    piecesLeft: setup.pieces,
    piecesRng: streamFor(state.seed, .pieces, roundIndex),
    roundIndex: roundIndex,
    score: 0,
    stonesRng: stonesRng,
    storedMult: 0,
    streak: 0,
    tray: List.filled(state.config.traySize, null),
  );

  return _settle(_refillIfEmpty(round, jokers, events), events);
}

int? _trayShape(RunState state, int trayIndex) =>
    trayIndex >= 0 && trayIndex < state.tray.length
    ? state.tray[trayIndex]
    : null;

/// Banks the round and its bonus, then offers jokers — or ends the run on the boss.
Transition _winRound(
  RunState state,
  List<JokerEffect> jokers,
  List<GameEvent> events,
) {
  final bonus = roundBonus(
    jokers,
    RoundWonContext(unusedPieces: state.piecesRemaining),
  );
  final total = state.runTotal + state.score + bonus.runPoints;

  final won = [
    ...events,
    ...bonus.fired,
    GameEvent.roundWon(
      bonus: bonus.runPoints,
      roundIndex: state.roundIndex,
      score: state.score,
    ),
  ];

  if (state.isLastRound) {
    return (
      state.copyWith(phase: const .won(), runTotal: total),
      [...won, GameEvent.runWon(total: total)],
    );
  }

  final offers = offersFor(
    config: state.config,
    owned: state.jokers,
    pickIndex: state.pickIndex,
    seed: state.seed,
  );

  return (
    state.copyWith(
      phase: .pickingJoker(offers: offers),
      runTotal: total,
    ),
    [...won, GameEvent.offersPresented(offers: offers)],
  );
}
