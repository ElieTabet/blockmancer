import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:shared_domain/shared_domain.dart';

/// The boss starts with [RoundSpec.stones] stones scattered on the board.
final class RubbleRule extends WorldRule {
  const RubbleRule();

  @override
  bool get bossOnly => true;

  @override
  RoundSetup onRoundSetup(RoundSetup setup, RoundSpec round) => RoundSetup(
    fired: setup.fired,
    pieces: setup.pieces,
    stones: setup.stones + round.stones,
  );
}
