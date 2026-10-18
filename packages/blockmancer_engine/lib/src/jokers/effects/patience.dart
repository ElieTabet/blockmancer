import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// A move that clears nothing banks +[JokerTuning.patienceStoredPerMove] mult;
/// the next clear spends the bank.
final class Patience extends JokerEffect {
  const Patience();

  @override
  JokerId get id => .patience;

  @override
  JokerKind get kind => .additiveMult;

  @override
  JokerId get partner => .twin;

  @override
  AfterMove afterMove(AfterMove after, MoveContext move) =>
      move.clear.clearedAny
      ? after.resetStoredMult()
      : after.storeMult(move.tuning.patienceStoredPerMove, id);

  @override
  ScoreStep onAdditive(MoveContext move, ScoreStep step) =>
      move.storedMult > 0 ? step.addMult(move.storedMult, id) : step;
}
