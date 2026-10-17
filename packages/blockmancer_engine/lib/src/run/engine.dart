import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:blockmancer_engine/src/random/rng_stream.dart';
import 'package:blockmancer_engine/src/random/weighted_draw.dart';
import 'package:blockmancer_engine/src/run/offers.dart';
import 'package:blockmancer_engine/src/scoring/score_move.dart';
import 'package:blockmancer_engine/src/worlds/world_rules.dart';

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
  piecesRngState: deriveSeed(index: 0, runSeed: seed, stream: .pieces),
  revivesUsed: 0,
  roundIndex: 0,
  runTotal: 0,
  score: 0,
  seed: seed,
  stonesRngState: deriveSeed(index: 0, runSeed: seed, stream: .stones),
  storedMult: 0,
  streak: 0,
  tray: List.filled(config.traySize, null),
);

/// Takes an offered joker and starts the next round.
Transition pickJoker(RunState state, {required JokerId id}) {
  final phase = state.phase;

  if (phase is! PickingJokerPhase) {
    throw StateError('No joker is on offer in ${state.phase}');
  }

  if (!phase.offers.contains(id)) {
    throw ArgumentError.value(id, 'id', 'is not on offer');
  }

  return _startRound((state.copyWith(jokers: [...state.jokers, id]), const []));
}

bool canPlace(RunState state, {required Cell anchor, required int trayIndex}) {
  final shapeId = _playableShape(state, trayIndex);

  return shapeId != null &&
      _landing(state, shapeCatalog[shapeId], anchor: anchor) != null;
}

bool canRevive(RunState state) =>
    state.phase is RoundLostPhase &&
    state.revivesUsed < state.config.revivesPerRun;

/// What is banked, plus the round in play: a won round's score is already in
/// [RunState.runTotal], a lost or playing one's is not yet.
int liveRunTotal(RunState state) => switch (state.phase) {
  PlayingPhase() || RoundLostPhase() => state.runTotal + state.score,
  PickingJokerPhase() || WonPhase() || OverPhase() => state.runTotal,
};

/// Whether the tray piece at [trayIndex] fits anywhere on the board.
bool fitsSomewhere(RunState state, {required int trayIndex}) {
  final shapeId = _playableShape(state, trayIndex);

  return shapeId != null && _fitsAnywhere(state, shapeCatalog[shapeId]);
}

PlacementPreview preview(
  RunState state, {
  required Cell anchor,
  required int trayIndex,
}) {
  final shapeId = _playableShape(state, trayIndex);

  if (shapeId == null) return .none;

  final shape = shapeCatalog[shapeId];
  final landing = _landing(state, shape, anchor: anchor);
  final shown = landing ?? anchor;
  final cells = [
    for (final offset in shape.cells)
      if (state.board.contains(shown + offset)) shown + offset,
  ];
  final placed = landing == null
      ? null
      : placeShape(state.board, shape, anchor: landing);

  return PlacementPreview(
    cells: cells,
    clearingCols: placed?.fullCols ?? const [],
    clearingRows: placed?.fullRows ?? const [],
    colliding: [
      for (final cell in cells)
        if (state.board.at(cell) is! EmptyCell) cell,
    ],
    fits: landing != null,
  );
}

/// Drops the tray piece at [trayIndex] with its top-left at [anchor], lands it
/// where the round's world rule says, clears and scores, then decides whether
/// the round is won or lost. The tray refills only when play goes on: a won
/// round deals nothing it would never play.
Transition place(
  RunState state, {
  required Cell anchor,
  required int trayIndex,
}) {
  if (!canPlace(state, anchor: anchor, trayIndex: trayIndex)) {
    throw ArgumentError('Tray piece $trayIndex cannot be placed at $anchor');
  }

  final shapeId = state.tray[trayIndex]!;
  final shape = shapeCatalog[shapeId];
  final landing = _landing(state, shape, anchor: anchor)!;
  final jokers = effectsOf(state.jokers);
  final clear = resolveClears(placeShape(state.board, shape, anchor: landing));
  final mask = state.trayClearMask;
  final trayClearMask = mask != null && clear.clearedAny
      ? mask | 1 << trayIndex
      : mask;

  final score = scoreMove(
    clear: clear,
    config: state.config,
    jokers: jokers,
    pieceSize: shape.size,
    previousStreak: state.streak,
    stonesRng: Mulberry32(state.stonesRngState),
    storedMult: state.storedMult,
    trayClearMask: trayClearMask,
    trayEmptied: state.tray.whereType<int>().length == 1,
  );

  final events = <GameEvent>[
    .piecePlaced(
      anchor: landing,
      cells: [for (final offset in shape.cells) landing + offset],
      shapeId: shapeId,
      trayIndex: trayIndex,
    ),
    if (clear.clearedAny)
      .linesCleared(cells: clear.cells, cols: clear.cols, rows: clear.rows),
    ...score.fired,
    .scoreAdded(
      bonusPoints: score.bonusPoints,
      chips: score.chips,
      lineScore: score.lineScore,
      mult: score.mult,
      piecePoints: shape.size,
      total: score.points,
    ),
    for (final cell in score.stonesDropped) .stonePlaced(cell: cell),
  ];

  final next = state.copyWith(
    board: score.board,
    score: state.score + score.points,
    stonesRngState: score.stonesRng.state,
    storedMult: score.storedMult,
    streak: score.streak,
    tray: [...state.tray]..[trayIndex] = null,
    trayClearMask: trayClearMask,
  );

  if (next.score >= next.round.target) return _winRound(jokers, (next, events));

  return _settle(_refillIfEmpty(jokers, (next, events)));
}

/// Empties the fullest rows and adds pieces to a lost round, once per
/// [RunConfig.revivesPerRun]. A board still stuck afterwards loses again.
Transition revive(RunState state) {
  if (!canRevive(state)) throw StateError('Cannot revive in ${state.phase}');

  final rows = List.generate(Board.size, (row) => row)
    ..sort((a, b) {
      final byOccupancy =
          state.board.occupiedInRow(b) - state.board.occupiedInRow(a);

      return byOccupancy != 0 ? byOccupancy : a - b;
    });
  final cleared = rows.take(state.config.reviveRows).toList()..sort();

  final next = state.copyWith(
    board: state.board.withCells({
      for (final row in cleared)
        for (var col = 0; col < Board.size; col++)
          Cell(col: col, row: row): const .empty(),
    }),
    piecesLeft: state.piecesLeft + state.config.revivePieces,
    revivePiecesLeft: state.revivePiecesLeft + state.config.revivePieces,
    revivesUsed: state.revivesUsed + 1,
  );

  return _settle(
    _refillIfEmpty(effectsOf(state.jokers), (next, [.revived(rows: cleared)])),
  );
}

/// Gives up after a lost round, banking its score.
Transition endRun(RunState state) {
  if (state.phase is! RoundLostPhase) {
    throw StateError('Cannot end the run in ${state.phase}');
  }

  final total = state.runTotal + state.score;

  return (
    state.copyWith(phase: const .over(), runTotal: total),
    [.runOver(total: total)],
  );
}

bool _fitsAnywhere(RunState state, Shape shape) => [
  for (var row = 0; row < Board.size; row++)
    for (var col = 0; col < Board.size; col++) Cell(col: col, row: row),
].any((anchor) => _landing(state, shape, anchor: anchor) != null);

/// Where [shape] dropped at [anchor] lands under the round's world rule, or
/// `null` when it can't be placed from there.
Cell? _landing(RunState state, Shape shape, {required Cell anchor}) =>
    ruleOfRound(
      state.config,
      state.round,
    ).transformAnchor(anchor: anchor, board: state.board, shape: shape);

/// The tray piece at [trayIndex] while the round is being played, else `null`.
int? _playableShape(RunState state, int trayIndex) {
  final inTray = trayIndex >= 0 && trayIndex < state.tray.length;

  return state.phase is PlayingPhase && inTray ? state.tray[trayIndex] : null;
}

/// Draws the next tray when the current one is played out and pieces remain.
/// Only a tray dealt in full from the round's own pieces can earn Hat Trick:
/// a short one, or one holding any of a revive's pieces, starts with no clear
/// mask.
Transition _refillIfEmpty(List<JokerEffect> jokers, Transition transition) {
  final (state, events) = transition;

  if (state.tray.any((slot) => slot != null) || state.piecesLeft == 0) {
    return transition;
  }

  final traySize = state.config.traySize;
  final count = state.piecesLeft < traySize ? state.piecesLeft : traySize;
  final weights = pieceWeights(jokers, state.config.jokers);
  final tray = <int?>[];
  var rng = Mulberry32(state.piecesRngState);

  for (var slot = 0; slot < traySize; slot++) {
    if (slot < count) {
      final (shapeId, next) = weightedIndex(rng, weights);
      tray.add(shapeId);
      rng = next;
    } else {
      tray.add(null);
    }
  }

  final piecesLeft = state.piecesLeft - count;
  final ownPiecesOnly = piecesLeft >= state.revivePiecesLeft;

  return (
    state.copyWith(
      piecesLeft: piecesLeft,
      piecesRngState: rng.state,
      revivePiecesLeft: ownPiecesOnly ? state.revivePiecesLeft : piecesLeft,
      tray: tray,
      trayClearMask: count == traySize && ownPiecesOnly ? 0 : null,
    ),
    [...events, .trayRefilled(tray: tray)],
  );
}

/// Playing on, or lost: out of pieces, or none of the tray fits.
Transition _settle(Transition transition) {
  final (state, events) = transition;
  final pieces = state.tray.whereType<int>();

  LossReason? reason;

  if (pieces.isEmpty) {
    reason = .outOfPieces;
  } else if (!pieces.any((id) => _fitsAnywhere(state, shapeCatalog[id]))) {
    reason = .noRoom;
  }

  if (reason == null) return (state.copyWith(phase: const .playing()), events);

  return (
    state.copyWith(phase: .roundLost(reason: reason)),
    [...events, .roundLost(reason: reason)],
  );
}

/// Sets up round [RunState.pickIndex]: its stones, its pieces and a full tray.
Transition _startRound(Transition transition) {
  final (state, events) = transition;
  final roundIndex = state.pickIndex;
  final spec = state.config.rounds[roundIndex];
  final jokers = effectsOf(state.jokers);
  final rule = ruleOfRound(state.config, spec);
  final setup = roundSetup(
    rule.onRoundSetup(RoundSetup(pieces: spec.pieces, stones: 0), spec),
    jokers,
    state.config.jokers,
  );

  final started = <GameEvent>[
    ...events,
    .roundStarted(
      pieces: setup.pieces,
      roundIndex: roundIndex,
      target: spec.target,
    ),
    ...setup.fired,
  ];

  var board = Board.empty();
  var stonesRng = streamFor(
    index: roundIndex,
    runSeed: state.seed,
    stream: .stones,
  );

  for (var stone = 0; stone < setup.stones; stone++) {
    final cells = stoneCells(board);

    if (cells.isEmpty) break;

    final (index, next) = stonesRng.nextInt(cells.length);
    stonesRng = next;
    board = board.withCells({cells[index]: const .stone()});
    started.add(.stonePlaced(cell: cells[index]));
  }

  final round = state.copyWith(
    board: board,
    pickIndex: roundIndex + 1,
    piecesLeft: setup.pieces,
    piecesRngState: deriveSeed(
      index: roundIndex,
      runSeed: state.seed,
      stream: .pieces,
    ),
    revivePiecesLeft: 0,
    roundIndex: roundIndex,
    score: 0,
    stonesRngState: stonesRng.state,
    storedMult: 0,
    streak: 0,
    tray: List.filled(state.config.traySize, null),
  );

  return _settle(_refillIfEmpty(jokers, (round, started)));
}

/// Banks the round and its bonus, then offers jokers — or, after the last
/// round, wins the run. With every joker already owned there is nothing to
/// offer, and the next round starts straight away.
Transition _winRound(List<JokerEffect> jokers, Transition transition) {
  final (state, events) = transition;
  final bonus = roundBonus(
    jokers,
    RoundWonContext(
      tuning: state.config.jokers,
      unusedPieces: state.piecesRemaining,
    ),
  );
  final total = state.runTotal + state.score + bonus.runPoints;

  final List<GameEvent> won = [
    ...events,
    ...bonus.fired,
    .roundWon(
      bonus: bonus.runPoints,
      roundIndex: state.roundIndex,
      score: state.score,
    ),
  ];

  if (state.isLastRound) {
    return (
      state.copyWith(phase: const .won(), runTotal: total),
      [...won, .runWon(total: total)],
    );
  }

  final offers = offersFor(
    config: state.config,
    owned: state.jokers,
    pickIndex: state.pickIndex,
    seed: state.seed,
  );

  if (offers.isEmpty) {
    return _startRound((state.copyWith(runTotal: total), won));
  }

  return (
    state.copyWith(
      phase: .pickingJoker(offers: offers),
      runTotal: total,
    ),
    [...won, .offersPresented(offers: offers)],
  );
}
