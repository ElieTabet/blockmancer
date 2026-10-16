import 'package:blockmancer_engine/src/board/board.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:blockmancer_engine/src/run/run_config.br.dart';
import 'package:blockmancer_engine/src/run/run_phase.br.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_state.br.freezed.dart';

/// Everything a run is, between two moves. Immutable: the engine's functions
/// return the next state rather than changing this one.
@freezed
abstract class RunState with _$RunState {
  const factory RunState({
    required Board board,
    required RunConfig config,

    /// In the order they were picked.
    required List<JokerId> jokers,
    required RunPhase phase,

    /// Joker picks made so far; the next pick starts round [pickIndex].
    required int pickIndex,

    /// Pieces not drawn into the tray yet.
    required int piecesLeft,
    required Mulberry32 piecesRng,
    required int revivesUsed,
    required int roundIndex,

    /// Banked from won rounds, Saver included; the round in play isn't in it.
    required int runTotal,
    required int score,
    required int seed,
    required Mulberry32 stonesRng,
    required int storedMult,
    required int streak,

    /// Shape ids; `null` is a slot already played.
    required List<int?> tray,
  }) = _RunState;

  const RunState._();

  bool get canRevive =>
      phase is RoundLostPhase && revivesUsed < config.revivesPerRun;

  bool get isLastRound => roundIndex == config.rounds.length - 1;

  /// The tray plus the pieces not drawn yet.
  int get piecesRemaining => piecesLeft + tray.whereType<int>().length;

  RoundSpec get round => config.rounds[roundIndex];
}
