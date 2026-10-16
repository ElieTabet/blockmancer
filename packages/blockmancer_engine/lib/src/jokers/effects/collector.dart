import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';

/// +1 mult per joker owned, this one included.
final class Collector extends JokerEffect {
  const Collector();

  @override
  JokerId get id => .collector;

  @override
  JokerId get partner => .combo;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      step.addMult(id, move.jokerCount);
}
