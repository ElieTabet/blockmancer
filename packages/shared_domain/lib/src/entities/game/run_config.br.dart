import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_config.br.freezed.dart';

@freezed
abstract class RoundSpec with _$RoundSpec {
  const factory RoundSpec({
    /// How the round is presented. The run ends after the last round,
    /// whichever it is.
    required bool isBoss,
    required int pieces,

    /// Stones on the board when the round starts.
    required int stones,
    required int target,
  }) = _RoundSpec;
}

/// The tunable numbers of a run. The rules supply the defaults
/// (`GameRules.defaultConfig`); Remote Config will supply them later.
@freezed
abstract class RunConfig with _$RunConfig {
  const factory RunConfig({
    required int offerCount,

    /// The chance that one offer is the partner of a joker already owned.
    required double partnerBias,
    required int revivePieces,
    required int reviveRows,
    required int revivesPerRun,
    required List<RoundSpec> rounds,
    required int traySize,
  }) = _RunConfig;
}
