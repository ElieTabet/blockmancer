import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// After each clearing move, a random empty cell turns to stone.
final class Quarry extends JokerEffect {
  const Quarry();

  @override
  JokerId get id => .quarry;

  @override
  JokerId get partner => .stonemason;

  @override
  AfterMove afterMove(AfterMove after, MoveContext move) =>
      move.clear.clearedAny ? after.dropStone(id) : after;
}
