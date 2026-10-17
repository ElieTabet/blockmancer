import 'package:shared_domain/shared_domain.dart';

/// The run as the brief tunes it, until Remote Config supplies the numbers.
const defaultConfig = RunConfig(
  chipsPerCell: 10,
  jokerPool: JokerId.values,
  jokers: JokerTuning(
    anchorMult: 4,
    avalancheChipsPerCell: 25,
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
    RoundSpec(isBoss: false, pieces: 16, stones: 0, target: 500),
    RoundSpec(isBoss: false, pieces: 18, stones: 0, target: 900),
    RoundSpec(isBoss: false, pieces: 20, stones: 0, target: 1400),
    RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 2000),
  ],
  traySize: 3,
  world: .rubble,
);

/// The default run in Gravity, whose boss starts with no stones: its rule is
/// the fall.
final gravityConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss ? round.copyWith(stones: 0) : round,
  ],
  world: .gravity,
);
