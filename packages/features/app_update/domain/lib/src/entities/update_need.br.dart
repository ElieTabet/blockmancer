import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_need.br.freezed.dart';

/// What this version of the app has to do about the published ones.
@freezed
sealed class UpdateNeed with _$UpdateNeed {
  /// Up to date, or nothing (valid) is published.
  const factory UpdateNeed.none() = UpdateNotNeeded;

  /// A newer version, [latest], is out; this one still plays.
  const factory UpdateNeed.optional({required String latest}) = UpdateOffered;

  /// Below the minimum: this version no longer plays.
  const factory UpdateNeed.required() = UpdateRequired;
}
