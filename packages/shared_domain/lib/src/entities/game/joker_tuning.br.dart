import 'package:freezed_annotation/freezed_annotation.dart';

part 'joker_tuning.br.freezed.dart';

/// The numbers each joker plays with, one field per tunable. Part of
/// `RunConfig` so Remote Config can retune a joker without a release.
@freezed
abstract class JokerTuning with _$JokerTuning {
  const factory JokerTuning({
    required int anchorMult,
    required int avalancheChipsPerCell,

    /// The bottom rows whose filled cells Avalanche counts.
    required int avalancheRows,
    required int bigBoxFactor,
    required int bigBoxMinPieceSize,
    required int brinkFactor,

    /// Occupied cells, filled and stone, from which On the Brink fires.
    required int brinkMinOccupied,
    required int collectorMultPerJoker,
    required int columnFactor,
    required int comboMultPerStreak,
    required int emberFactor,
    required int emberMult,
    required int finisherFactor,

    /// Occupied cells, filled and stone, per +1 mult from Full House.
    required int fullHouseCellsPerMult,

    /// The mult Full House adds per [fullHouseCellsPerMult] occupied cells.
    required int fullHouseMultPerBlock,
    required int hatTrickBonus,
    required int heavyFactor,
    required int heavyMinPieceSize,
    required int momentumMultPerTray,
    required int patienceStoredPerMove,
    required int pocketsExtraPieces,
    required int precisionBonusMult,
    required int precisionMaxPieceSize,

    /// Chips per occupied cell whose mirror cell is occupied too (Prism).
    required int prismChipsPerPair,
    required int quarryStonesPerClear,
    required int saverPointsPerPiece,
    required int sprinterMult,
    required int stonemasonChipsPerStone,
    required int stonemasonExtraStones,
    required int sweepBonus,
    required int symmetryMult,
    required int tinyFactor,
    required int tinyMaxPieceSize,
    required int twinFactor,
    required int twinMinLines,
  }) = _JokerTuning;
}
