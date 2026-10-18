import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.sprinterMult] mult when the first piece played from a fresh
/// tray clears a line.
final class Sprinter extends JokerEffect {
  const Sprinter();

  @override
  JokerId get id => .sprinter;

  @override
  JokerId get partner => .momentum;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.firstOfTray ? step.addMult(move.tuning.sprinterMult, id) : step;
}
