import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';
import 'package:blockmancer_engine/src/pieces/shape.dart';

/// One joker's rules. Every hook defaults to doing nothing, so a joker
/// overrides only the moments it cares about, and adding one never touches
/// another. Hooks run in [jokerCatalog] order.
abstract class JokerEffect {
  const JokerEffect();

  JokerId get id;

  /// The joker this one pairs with: offers favour it once this one is owned.
  JokerId get partner;

  /// After a move is scored, cleared or not.
  AfterMove afterMove(MoveContext move, AfterMove after) => after;

  /// On a clearing move, before any multiplicative effect.
  ScoreStep onAdditive(MoveContext move, ScoreStep step) => step;

  /// On a clearing move, after every additive effect.
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) => step;

  RoundSetup onRoundSetup(RoundSetup setup) => setup;

  RoundBonus onRoundWon(RoundWonContext round, RoundBonus bonus) => bonus;

  /// How likely [shape] is drawn, relative to the other shapes.
  int pieceWeight(Shape shape, int weight) => weight;
}
