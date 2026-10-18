import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.momentumMultPerTray] mult per tray in a row, this one
/// included, whose first piece cleared a line, on every clearing move.
final class Momentum extends JokerEffect {
  const Momentum();

  @override
  JokerId get id => .momentum;

  @override
  JokerId get partner => .sprinter;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.momentumStreak > 0
      ? step.addMult(move.momentumStreak * move.tuning.momentumMultPerTray, id)
      : step;
}
