import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_config.br.freezed.dart';

@freezed
abstract class RoundSpec with _$RoundSpec {
  const factory RoundSpec({
    required int pieces,
    required int target,
    @Default(false) bool isBoss,

    /// Stones on the board when the round starts.
    @Default(0) int stones,
  }) = _RoundSpec;
}

/// The tunable numbers of a run. Hard-coded for now; Remote Config will
/// supply them later.
@freezed
abstract class RunConfig with _$RunConfig {
  const factory RunConfig({
    @Default(3) int offerCount,

    /// The chance that one offer is the partner of a joker already owned.
    @Default(0.75) double partnerBias,
    @Default(3) int revivePieces,
    @Default(2) int reviveRows,
    @Default(1) int revivesPerRun,
    @Default(defaultRounds) List<RoundSpec> rounds,
    @Default(3) int traySize,
  }) = _RunConfig;
}

const defaultRounds = [
  RoundSpec(pieces: 14, target: 250),
  RoundSpec(pieces: 16, target: 500),
  RoundSpec(pieces: 18, target: 900),
  RoundSpec(pieces: 20, target: 1400),
  RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 2000),
];
