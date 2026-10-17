import 'package:shared_domain/src/entities/game/board.br.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/run_config.br.dart';
import 'package:shared_domain/src/entities/game/run_phase.br.dart';
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

    /// The pieces stream's generator state; only the rules read it.
    required int piecesRngState,
    required int revivesUsed,
    required int roundIndex,

    /// Banked from won rounds, Saver included; the round in play isn't in it.
    required int runTotal,
    required int score,
    required int seed,

    /// The stones stream's generator state; only the rules read it.
    required int stonesRngState,
    required int storedMult,
    required int streak,

    /// Shape ids; `null` is a slot already played.
    required List<int?> tray,

    /// The tray slots whose piece cleared a line, one bit per slot, since the
    /// tray was dealt. `null` when the tray can't earn Hat Trick: dealt short,
    /// in play when a revive came, or not dealt at all.
    int? trayClearMask,
  }) = _RunState;

  const RunState._();

  bool get isLastRound => roundIndex == config.rounds.length - 1;

  /// The tray plus the pieces not drawn yet.
  int get piecesRemaining => piecesLeft + tray.whereType<int>().length;

  RoundSpec get round => config.rounds[roundIndex];
}
