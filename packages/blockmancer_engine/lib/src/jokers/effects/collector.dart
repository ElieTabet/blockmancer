import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.collectorMultPerJoker] mult for every two jokers owned,
/// this one included.
final class Collector extends JokerEffect {
  const Collector();

  @override
  JokerId get id => .collector;

  @override
  JokerId get partner => .combo;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) {
    final pairs = move.jokerCount ~/ 2;

    return pairs > 0
        ? step.addMult(pairs * move.tuning.collectorMultPerJoker, id)
        : step;
  }
}
