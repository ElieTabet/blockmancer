import 'package:shared_domain/shared_domain.dart';

/// The run as the brief tunes it, until Remote Config supplies the numbers.
const defaultConfig = RunConfig(
  chipsPerCell: 10,
  jokerPool: JokerId.values,
  jokers: JokerTuning(
    anchorMult: 6,
    avalancheChipsPerCell: 40,
    avalancheRows: 2,
    bigBoxFactor: 3,
    bigBoxMinPieceSize: 5,
    brinkFactor: 2,
    brinkMinOccupied: 40,
    collectorMultPerJoker: 1,
    columnFactor: 2,
    comboMultPerStreak: 1,
    emberFactor: 4,
    finisherFactor: 3,
    fullHouseCellsPerMult: 12,
    fullHouseMultPerBlock: 1,
    hatTrickBonus: 300,
    heavyFactor: 2,
    heavyMinPieceSize: 3,
    momentumMultPerTray: 1,
    patienceStoredPerMove: 1,
    pocketsExtraPieces: 11,
    precisionBonusMult: 6,
    precisionMaxPieceSize: 2,
    prismChipsPerPair: 15,
    quarryStonesPerClear: 1,
    saverPointsPerPiece: 60,
    sprinterMult: 2,
    stonemasonChipsPerStone: 150,
    stonemasonExtraStones: 2,
    sweepBonus: 750,
    symmetryMult: 4,
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
  // Round 3 so the bot clears it about two runs in three; each world's boss
  // so it beats a little less often than in the world before
  // (docs/balance/2026-10-18-sprint7.md).
  rounds: [
    RoundSpec(isBoss: false, pieces: 14, stones: 0, target: 250),
    RoundSpec(isBoss: false, pieces: 16, stones: 0, target: 500),
    RoundSpec(isBoss: false, pieces: 18, stones: 0, target: 875),
    RoundSpec(isBoss: false, pieces: 20, stones: 0, target: 2200),
    RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 4250),
  ],
  // The bot's 80th percentile with its best pair, over the runs that completed
  // it, so the third star takes skill and a good build: patience,twin's
  // 10,686 rounded down to 250 (docs/balance/2026-10-18-sprint7.md).
  starThreshold: 10500,
  // Kept at 4 and 6 as the map grew to 5 worlds (15 stars).
  starUnlocks: [
    StarUnlock(jokers: [.fullhouse, .brink], stars: 4),
    StarUnlock(jokers: [.finisher, .hattrick], stars: 6),
  ],
  traySize: 3,
  world: .rubble,
);

/// The default run in Gravity, whose boss starts with no stones: its rule is
/// the fall. Its boss is a little harder than Rubble's, as each is than the
/// one before: a lower target, since the fall costs more points than stones.
final gravityConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss ? round.copyWith(stones: 0, target: 4000) : round,
  ],
  // patience,twin's 10,579 over the runs that completed it, rounded down to
  // 250 (docs/balance/2026-10-18-sprint7.md).
  starThreshold: 10500,
  world: .gravity,
);

/// The default run in Fog, whose boss starts with no stones but 8 fog cells,
/// 3 of them hiding a stone.
final fogConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss
          ? round.copyWith(fog: 8, fogStones: 3, stones: 0, target: 4250)
          : round,
  ],
  // patience,twin's 10,548 (docs/balance/2026-10-18-sprint7.md).
  starThreshold: 10500,
  world: .fog,
);

/// The default run in Tide, whose boss starts with no stones and rises a row
/// with every tray a move empties, a stone row with 2 gaps entering at the
/// bottom. A flood ends the boss early, so its target is the lowest.
final tideConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss
          ? round.copyWith(stones: 0, target: 3000, tideGaps: 2)
          : round,
  ],
  // patience,twin's 9,603 (docs/balance/2026-10-18-sprint7.md).
  starThreshold: 9500,
  world: .tide,
);

/// The default run in Mirror, whose boss starts with no stones and reflects
/// every piece across the board's centre line.
final mirrorConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss ? round.copyWith(stones: 0, target: 4250) : round,
  ],
  // patience,twin's 10,542 (docs/balance/2026-10-18-sprint7.md).
  starThreshold: 10500,
  world: .mirror,
);
