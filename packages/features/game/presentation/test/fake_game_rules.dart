import 'package:shared_domain/shared_domain.dart';

/// A run in [phase] with an empty board and a tray of singles.
RunState runIn(
  RunPhase phase, {
  Board? board,
  List<JokerId> jokers = const [],
  int pickIndex = 1,
  int piecesLeft = 5,
  int revivesUsed = 0,
  int roundIndex = 0,
  int runTotal = 0,
  int score = 0,
  int seed = 1,
  int storedMult = 0,
  int streak = 0,
  List<int?> tray = const [0, 0, 0],
}) => RunState(
  board: board ?? Board.empty(),
  config: testConfig,
  jokers: jokers,
  phase: phase,
  pickIndex: pickIndex,
  piecesLeft: piecesLeft,
  piecesRngState: 0,
  revivesUsed: revivesUsed,
  roundIndex: roundIndex,
  runTotal: runTotal,
  score: score,
  seed: seed,
  stonesRngState: 0,
  storedMult: storedMult,
  streak: streak,
  tray: tray,
);

const testConfig = RunConfig(
  chipsPerCell: 10,
  jokers: JokerTuning(
    bigBoxFactor: 3,
    bigBoxMinPieceSize: 5,
    collectorMultPerJoker: 1,
    columnFactor: 2,
    comboMultPerStreak: 1,
    heavyFactor: 2,
    heavyMinPieceSize: 4,
    patienceStoredPerMove: 2,
    pocketsExtraPieces: 4,
    precisionBonusMult: 6,
    precisionMaxPieceSize: 2,
    quarryStonesPerClear: 1,
    saverPointsPerPiece: 40,
    stonemasonChipsPerStone: 50,
    stonemasonExtraStones: 2,
    sweepBonus: 500,
    tinyFactor: 3,
    tinyMaxPieceSize: 2,
    twinFactor: 3,
    twinMinLines: 2,
  ),
  offerCount: 3,
  partnerBias: 0.75,
  revivePieces: 3,
  reviveRows: 2,
  revivesPerRun: 1,
  rounds: [
    RoundSpec(isBoss: false, pieces: 14, stones: 0, target: 250),
    RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 2000),
  ],
  traySize: 3,
  world: .rubble,
);

/// Scripted rules: every move answers [next], and every call is recorded.
/// Shape ids are singles; a piece fits wherever the board is empty.
final class FakeGameRules implements GameRules {
  FakeGameRules({required this.start});

  final calls = <String>[];
  Transition? next;
  final RunState start;

  @override
  RunConfig get defaultConfig => testConfig;

  @override
  bool canPlace(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) => state.tray[trayIndex] != null && state.board.at(anchor) is EmptyCell;

  @override
  bool canRevive(RunState state) =>
      state.phase is RoundLostPhase &&
      state.revivesUsed < state.config.revivesPerRun;

  @override
  int dailySeed({required int day, required int month, required int year}) => 1;

  @override
  Transition endRun(RunState state) => _move('endRun', state);

  @override
  bool fitsSomewhere(RunState state, {required int trayIndex}) => true;

  @override
  int liveRunTotal(RunState state) => state.runTotal + state.score;

  @override
  JokerId partnerOf(JokerId id) => id == .twin ? .patience : .twin;

  @override
  Transition pickJoker(RunState state, {required JokerId id}) =>
      _move('pickJoker $id', state);

  @override
  Transition place(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) => _move('place $trayIndex (${anchor.row}, ${anchor.col})', state);

  @override
  PlacementPreview preview(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) {
    final fits = canPlace(state, anchor: anchor, trayIndex: trayIndex);

    return PlacementPreview(
      cells: [anchor],
      clearingCols: const [],
      clearingRows: const [],
      colliding: fits ? const [] : [anchor],
      fits: fits,
    );
  }

  @override
  RunState replay({
    required RunConfig config,
    required List<RunMove> moves,
    required int seed,
  }) => throw UnimplementedError('the screen never replays');

  @override
  Transition revive(RunState state) => _move('revive', state);

  @override
  Shape shape(int id) => Shape(cells: const [Cell(col: 0, row: 0)], id: id);

  @override
  RunState startRun({required RunConfig config, required int seed}) {
    calls.add('startRun $seed');

    return start;
  }

  @override
  RunState tutorialRun({required RunConfig config}) =>
      throw UnimplementedError('the screen has no tutorial yet');

  Transition _move(String call, RunState state) {
    calls.add(call);

    return next ?? (state, const []);
  }
}
