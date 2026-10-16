import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +1 mult for every clearing move in a row before this one.
final class ComboKing extends JokerEffect {
  const ComboKing();

  @override
  JokerId get id => .combo;

  @override
  JokerId get partner => .collector;

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.streak > 1 ? step.addMult(move.streak - 1, id) : step;
}
