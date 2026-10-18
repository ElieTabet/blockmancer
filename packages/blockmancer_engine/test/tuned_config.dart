import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:shared_domain/shared_domain.dart';

/// Every joker number distinct and off its default, so a test reading one
/// proves the effect reads its own field rather than another's or a constant.
const tunedJokers = JokerTuning(
  anchorMult: 19,
  avalancheChipsPerCell: 21,
  avalancheRows: 6,
  bigBoxFactor: 15,
  bigBoxMinPieceSize: 9,
  brinkFactor: 22,
  brinkMinOccupied: 20,
  collectorMultPerJoker: 8,
  columnFactor: 11,
  comboMultPerStreak: 10,
  emberFactor: 26,
  finisherFactor: 23,
  fullHouseCellsPerMult: 3,
  fullHouseMultPerBlock: 24,
  hatTrickBonus: 950,
  heavyFactor: 12,
  heavyMinPieceSize: 5,
  momentumMultPerTray: 27,
  patienceStoredPerMove: 16,
  pocketsExtraPieces: 17,
  precisionBonusMult: 18,
  precisionMaxPieceSize: 4,
  prismChipsPerPair: 28,
  quarryStonesPerClear: 2,
  saverPointsPerPiece: 70,
  sprinterMult: 29,
  stonemasonChipsPerStone: 80,
  stonemasonExtraStones: 7,
  sweepBonus: 900,
  symmetryMult: 31,
  tinyFactor: 14,
  tinyMaxPieceSize: 1,
  twinFactor: 13,
  twinMinLines: 3,
);

final tunedConfig = defaultConfig.copyWith(
  chipsPerCell: 20,
  jokers: tunedJokers,
);
