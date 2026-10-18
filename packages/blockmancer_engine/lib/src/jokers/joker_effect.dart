import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// One joker's rules. Every hook defaults to doing nothing, so a joker
/// overrides only the moments it cares about, and adding one never touches
/// another. Hooks run in [jokerCatalog] order.
abstract class JokerEffect {
  const JokerEffect();

  JokerId get id;

  /// The joker this one pairs with: offers favour it once this one is owned.
  JokerId get partner;

  /// On a clearing move, before it is scored: what the clear takes off the
  /// board besides its lines.
  ClearResult extendClear(ClearResult clear) => clear;

  /// After a move is scored, cleared or not.
  AfterMove afterMove(AfterMove after, MoveContext move) => after;

  /// On a clearing move, before any multiplicative effect.
  ScoreStep onAdditive(MoveContext move, ScoreStep step) => step;

  /// On a clearing move, after every additive effect.
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) => step;

  RoundSetup onRoundSetup(RoundSetup setup, JokerTuning tuning) => setup;

  RoundBonus onRoundWon(RoundBonus bonus, RoundWonContext round) => bonus;

  /// How likely [shape] is drawn, relative to the other shapes.
  int pieceWeight(Shape shape, JokerTuning tuning, int weight) => weight;
}
