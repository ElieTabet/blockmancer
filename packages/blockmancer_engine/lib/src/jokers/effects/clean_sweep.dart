import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +500 points when a clear leaves the board completely empty.
final class CleanSweep extends JokerEffect {
  const CleanSweep();

  static const _bonus = 500;

  @override
  JokerId get id => .sweep;

  @override
  JokerId get partner => .column;

  @override
  AfterMove afterMove(AfterMove after, MoveContext move) =>
      move.clear.clearedAny && after.board.isEmpty
      ? after.addPoints(_bonus, id)
      : after;
}
