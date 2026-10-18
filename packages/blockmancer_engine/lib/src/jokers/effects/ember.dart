import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.emberMult] mult on every clear, then ×[JokerTuning.emberFactor]
/// when the move takes a stone or a fog cell off the board, in its lines or
/// beside them (Lantern).
final class Ember extends JokerEffect {
  const Ember();

  @override
  JokerId get id => .ember;

  @override
  JokerId get partner => .lantern;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.tuning.emberMult > 0
      ? step.addMult(move.tuning.emberMult, id)
      : step;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.clear.obstaclesCleared > 0
      ? step.multiplyMult(move.tuning.emberFactor, id)
      : step;
}
