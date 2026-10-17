import 'package:freezed_annotation/freezed_annotation.dart';

part 'joker_tuning.br.freezed.dart';

/// The numbers each joker plays with, one field per tunable. Part of
/// `RunConfig` so Remote Config can retune a joker without a release.
@freezed
abstract class JokerTuning with _$JokerTuning {
  const factory JokerTuning({
    required int bigBoxFactor,
    required int bigBoxMinPieceSize,
    required int collectorMultPerJoker,
    required int columnFactor,
    required int comboMultPerStreak,
    required int heavyFactor,
    required int heavyMinPieceSize,
    required int patienceStoredPerMove,
    required int pocketsExtraPieces,
    required int precisionBonusMult,
    required int precisionMaxPieceSize,
    required int quarryStonesPerClear,
    required int saverPointsPerPiece,
    required int stonemasonChipsPerStone,
    required int stonemasonExtraStones,
    required int sweepBonus,
    required int tinyFactor,
    required int tinyMaxPieceSize,
    required int twinFactor,
    required int twinMinLines,
  }) = _JokerTuning;
}
