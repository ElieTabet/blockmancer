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
    emberFactor: 2,
    finisherFactor: 3,
    fullHouseCellsPerMult: 10,
    fullHouseMultPerBlock: 1,
    hatTrickBonus: 300,
    heavyFactor: 2,
    heavyMinPieceSize: 3,
    momentumMultPerTray: 2,
    patienceStoredPerMove: 1,
    pocketsExtraPieces: 8,
    precisionBonusMult: 6,
    precisionMaxPieceSize: 2,
    prismChipsPerPair: 15,
    quarryStonesPerClear: 1,
    saverPointsPerPiece: 40,
    sprinterMult: 5,
    stonemasonChipsPerStone: 125,
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
  // Round 3 eased, round 4 and the boss steepened so the boss is the run's
  // wall (docs/balance/2026-10-18-sprint5.md).
  rounds: [
    RoundSpec(isBoss: false, pieces: 14, stones: 0, target: 250),
    RoundSpec(isBoss: false, pieces: 16, stones: 0, target: 500),
    RoundSpec(isBoss: false, pieces: 18, stones: 0, target: 800),
    RoundSpec(isBoss: false, pieces: 20, stones: 0, target: 2200),
    RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 5000),
  ],
  // The bot's 80th percentile with its best pair, over the runs that completed
  // it, so the third star takes skill and a good build: patience,twin's
  // 11,071 rounded to the nearest 250 (docs/balance/2026-10-18-sprint5.md).
  starThreshold: 11000,
  // Six is every star of today's two worlds.
  starUnlocks: [
    StarUnlock(jokers: [.fullhouse, .brink], stars: 4),
    StarUnlock(jokers: [.finisher, .hattrick], stars: 6),
  ],
  traySize: 3,
  world: .rubble,
);

/// The default run in Gravity, whose boss starts with no stones: its rule is
/// the fall. Its boss asks a little more than Rubble's, since difficulty
/// rises along the map.
final gravityConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss ? round.copyWith(stones: 0, target: 5250) : round,
  ],
  // patience,twin's 11,549 over the runs that completed it, rounded to the
  // nearest 250 (docs/balance/2026-10-18-sprint5.md).
  starThreshold: 11500,
  world: .gravity,
);

/// The default run in Fog, whose boss starts with no stones but 8 fog cells,
/// 3 of them hiding a stone. Its boss target and ★3 threshold are a step above
/// Gravity's until Sprint 7's balance pass sets them from the bot.
final fogConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss
          ? round.copyWith(fog: 8, fogStones: 3, stones: 0, target: 5500)
          : round,
  ],
  starThreshold: 12000,
  world: .fog,
);

/// The default run in Tide, whose boss starts with no stones and rises a row
/// with every tray but its first, a stone row with 2 gaps entering at the
/// bottom. Its boss target and ★3 threshold are a step above Fog's until
/// Sprint 7's balance pass sets them from the bot.
final tideConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss
          ? round.copyWith(stones: 0, target: 5750, tideGaps: 2)
          : round,
  ],
  starThreshold: 12500,
  world: .tide,
);

/// The default run in Mirror, whose boss starts with no stones and reflects
/// every piece across the board's centre line. Its boss target and ★3
/// threshold are a step above Tide's until Sprint 7's balance pass sets them
/// from the bot.
final mirrorConfig = defaultConfig.copyWith(
  rounds: [
    for (final round in defaultConfig.rounds)
      round.isBoss ? round.copyWith(stones: 0, target: 6000) : round,
  ],
  starThreshold: 13000,
  world: .mirror,
);
