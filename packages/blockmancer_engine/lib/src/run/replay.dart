import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';

/// Plays [move] on [state], as the player would have.
Transition applyMove(RunState state, RunMove move) => switch (move) {
  EndMove() => endRun(state),
  PickMove(:final id) => pickJoker(state, id: id),
  PlaceMove(:final anchor, :final trayIndex) => place(
    state,
    anchor: anchor,
    trayIndex: trayIndex,
  ),
  ReviveMove() => revive(state),
};

/// The run [moves] play from the start of the run of [seed].
RunState replay({
  required RunConfig config,
  required List<RunMove> moves,
  required int seed,
}) => moves.fold(
  startRun(config: config, seed: seed),
  (state, move) => applyMove(state, move).$1,
);
