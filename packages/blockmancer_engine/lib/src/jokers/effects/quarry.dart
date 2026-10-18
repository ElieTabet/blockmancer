import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// After each clearing move, [JokerTuning.quarryStonesPerClear] random empty
/// cells turn to stone, one draw from the stones stream each.
final class Quarry extends JokerEffect {
  const Quarry();

  @override
  JokerId get id => .quarry;

  @override
  JokerKind get kind => .boardEffect;

  @override
  JokerId get partner => .stonemason;

  @override
  AfterMove afterMove(AfterMove after, MoveContext move) {
    if (!move.clear.clearedAny) return after;

    var dropped = after;

    for (var stone = 0; stone < move.tuning.quarryStonesPerClear; stone++) {
      dropped = dropped.dropStone(id);
    }

    return dropped;
  }
}
