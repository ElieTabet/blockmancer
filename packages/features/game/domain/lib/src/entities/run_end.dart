import 'package:shared_domain/shared_domain.dart';

/// Whether [run] is over for good: won, or ended by the player. A lost round
/// isn't — it may still be revived.
bool hasEnded(RunState run) => switch (run.phase) {
  WonPhase() || OverPhase() => true,
  PickingJokerPhase() || PlayingPhase() || RoundLostPhase() => false,
};
