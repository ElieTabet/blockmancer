import 'package:blockmancer_engine/src/jokers/joker_id.dart';
import 'package:blockmancer_engine/src/run/loss_reason.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_phase.br.freezed.dart';

@freezed
sealed class RunPhase with _$RunPhase {
  /// Ended by the player after a lost round.
  const factory RunPhase.over() = OverPhase;

  /// Before the first round, and after every round but the boss.
  const factory RunPhase.pickingJoker({required List<JokerId> offers}) =
      PickingJokerPhase;

  const factory RunPhase.playing() = PlayingPhase;

  /// Waiting for the player to revive or end the run.
  const factory RunPhase.roundLost({required LossReason reason}) =
      RoundLostPhase;

  const factory RunPhase.won() = WonPhase;
}
