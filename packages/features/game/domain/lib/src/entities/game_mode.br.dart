import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'game_mode.br.freezed.dart';

/// Which run is being played, and so which best score it is measured against.
@freezed
sealed class GameMode with _$GameMode {
  /// The run everyone plays on the UTC day [day] (`yyyymmdd`), its own seed.
  const factory GameMode.daily({required int day}) = DailyMode;

  const factory GameMode.practice() = PracticeMode;

  /// A run of one world of the map: the only runs that earn its stars and
  /// unlock what comes after it.
  const factory GameMode.world({required WorldId world}) = WorldMode;
}
