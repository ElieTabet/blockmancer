import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.hatTrickBonus] points when every piece of a tray dealt in
/// full cleared at least one line, paid on the move that plays its last piece.
final class HatTrick extends JokerEffect {
  const HatTrick();

  @override
  JokerId get id => .hattrick;

  @override
  JokerId get partner => .finisher;

  @override
  AfterMove afterMove(AfterMove after, MoveContext move) =>
      move.trayEmptied && move.trayClearMask == (1 << move.traySize) - 1
      ? after.addPoints(move.tuning.hatTrickBonus, id)
      : after;
}
