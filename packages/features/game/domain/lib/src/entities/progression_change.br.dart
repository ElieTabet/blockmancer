import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'progression_change.br.freezed.dart';

/// What a world run earned on the map, for the run's end to celebrate.
@freezed
abstract class ProgressionChange with _$ProgressionChange {
  const factory ProgressionChange({
    /// The stars this run earned that the world had not awarded before.
    required WorldStars newStars,

    /// Every star the world has awarded, this run's included.
    required WorldStars stars,
    required List<JokerId> unlockedJokers,
    WorldId? unlockedWorld,
  }) = _ProgressionChange;

  const ProgressionChange._();

  bool get unlocksAnything =>
      unlockedWorld != null || unlockedJokers.isNotEmpty;
}
