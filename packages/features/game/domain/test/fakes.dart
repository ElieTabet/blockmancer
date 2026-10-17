import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

export 'fake_best_scores.dart';
export 'fake_run_store.dart';

/// A clock at [current], which a test may move.
final class FakeClock implements Clock {
  FakeClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

/// Rules whose daily seed is the date as `yyyymmdd` plus one, so a test can
/// tell a seed from a day. Nothing else is called.
final class DailySeedRules implements GameRules {
  const DailySeedRules();

  @override
  int dailySeed({required int day, required int month, required int year}) =>
      year * 10000 + month * 100 + day + 1;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _config = RunConfig(
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
  rounds: [RoundSpec(isBoss: true, pieces: 14, stones: 0, target: 250)],
  traySize: 3,
);

/// A practice run in [phase].
SavedRun savedIn(RunPhase phase) => SavedRun(
  mode: const .practice(),
  run: RunState(
    board: Board.empty(),
    config: _config,
    jokers: const [],
    phase: phase,
    pickIndex: 1,
    piecesLeft: 5,
    piecesRngState: 0,
    revivesUsed: 0,
    roundIndex: 0,
    runTotal: 0,
    score: 40,
    seed: 7,
    stonesRngState: 0,
    storedMult: 0,
    streak: 0,
    tray: const [0, 1, 2],
  ),
);
