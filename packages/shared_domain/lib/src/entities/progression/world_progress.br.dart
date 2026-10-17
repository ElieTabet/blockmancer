import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/progression/world_stars.br.dart';

part 'world_progress.br.freezed.dart';

/// How far the player has come in one world of the map.
@freezed
abstract class WorldProgress with _$WorldProgress {
  const factory WorldProgress({
    required bool bossBeaten,
    required WorldStars stars,
    required bool unlocked,
  }) = _WorldProgress;
}
