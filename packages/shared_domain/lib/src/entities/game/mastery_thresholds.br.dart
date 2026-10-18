import 'package:freezed_annotation/freezed_annotation.dart';

part 'mastery_thresholds.br.freezed.dart';

/// The runs won with a joker owned that earn each mastery tier in the
/// Spellbook.
@freezed
abstract class MasteryThresholds with _$MasteryThresholds {
  const factory MasteryThresholds({
    required int bronze,
    required int gold,
    required int silver,
  }) = _MasteryThresholds;
}
