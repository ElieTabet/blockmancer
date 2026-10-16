import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// When a round is won, +40 run points per unused piece.
final class Saver extends JokerEffect {
  const Saver();

  static const _pointsPerPiece = 40;

  @override
  JokerId get id => .saver;

  @override
  JokerId get partner => .pockets;

  @override
  RoundBonus onRoundWon(RoundBonus bonus, RoundWonContext round) =>
      round.unusedPieces > 0
      ? bonus.addRunPoints(_pointsPerPiece * round.unusedPieces, id)
      : bonus;
}
