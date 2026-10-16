import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';

/// A move that clears nothing banks +2 mult; the next clear spends the bank.
final class Patience extends JokerEffect {
  const Patience();

  static const _storedPerMove = 2;

  @override
  JokerId get id => .patience;

  @override
  JokerId get partner => .twin;

  @override
  AfterMove afterMove(MoveContext move, AfterMove after) =>
      move.clear.clearedAny
      ? after.resetStoredMult()
      : after.storeMult(id, _storedPerMove);

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.storedMult > 0 ? step.addMult(id, move.storedMult) : step;
}
