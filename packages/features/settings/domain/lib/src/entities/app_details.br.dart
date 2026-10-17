import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_details.br.freezed.dart';

/// The build the player runs and the phone it runs on, as Settings shows it
/// and a feedback email carries it.
@freezed
abstract class AppDetails with _$AppDetails {
  const factory AppDetails({
    required String build,
    required String device,
    required String os,
    required String version,
  }) = _AppDetails;
}
