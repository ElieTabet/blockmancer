import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.sweepBonus] points when a clear leaves the board completely
/// empty.
final class CleanSweep extends JokerEffect {
  const CleanSweep();

  @override
  JokerId get id => .sweep;

  @override
  JokerKind get kind => .flatBonus;

  @override
  JokerId get partner => .column;

  @override
  AfterMove afterMove(AfterMove after, MoveContext move) =>
      move.clear.clearedAny && after.board.isEmpty
      ? after.addPoints(move.tuning.sweepBonus, id)
      : after;
}
