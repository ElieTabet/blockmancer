import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// ×[JokerTuning.finisherFactor] mult when the move plays the last piece left
/// in the tray.
final class Finisher extends JokerEffect {
  const Finisher();

  @override
  JokerId get id => .finisher;

  @override
  JokerId get partner => .hattrick;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.trayEmptied
      ? step.multiplyMult(move.tuning.finisherFactor, id)
      : step;
}
