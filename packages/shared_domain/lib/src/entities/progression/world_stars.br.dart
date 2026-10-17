import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_stars.br.freezed.dart';

/// The three stars a world awards, each kept once earned.
@freezed
abstract class WorldStars with _$WorldStars {
  const factory WorldStars({
    required bool bossBeaten,
    required bool noRevive,

    /// A run total of at least the world's `RunConfig.starThreshold`.
    required bool scoreThreshold,
  }) = _WorldStars;
}
