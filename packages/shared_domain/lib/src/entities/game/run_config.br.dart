import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/joker_tuning.br.dart';
import 'package:shared_domain/src/entities/game/world_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_config.br.freezed.dart';

@freezed
abstract class RoundSpec with _$RoundSpec {
  const factory RoundSpec({
    /// How the round is presented, and the round a world's boss rule holds
    /// in. The run ends after the last round, whichever it is.
    required bool isBoss,
    required int pieces,

    /// Stones on the board when the round starts, in a round whose world rule
    /// drops them (Rubble's boss).
    required int stones,
    required int target,
  }) = _RoundSpec;
}

/// The tunable numbers of a run. The rules supply the defaults
/// (`GameRules.defaultConfig`); Remote Config will supply them later.
@freezed
abstract class RunConfig with _$RunConfig {
  const factory RunConfig({
    /// Chips a cleared cell scores, before any joker.
    required int chipsPerCell,

    /// The jokers offers may draw from, owned ones aside. A set in all but
    /// type: offers draw in the rules' own order, so how the list is ordered
    /// never changes a seeded run.
    required List<JokerId> jokerPool,
    required JokerTuning jokers,
    required int offerCount,

    /// The chance that one offer is the partner of a joker already owned.
    required double partnerBias,
    required int revivePieces,
    required int reviveRows,
    required int revivesPerRun,
    required List<RoundSpec> rounds,

    /// The run total that earns the world's third star.
    required int starThreshold,
    required int traySize,

    /// The world whose boss rule the run plays under.
    required WorldId world,
  }) = _RunConfig;
}
