import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';

/// When a round is won, +40 run points per unused piece.
final class Saver extends JokerEffect {
  const Saver();

  static const _pointsPerPiece = 40;

  @override
  JokerId get id => .saver;

  @override
  JokerId get partner => .pockets;

  @override
  RoundBonus onRoundWon(RoundWonContext round, RoundBonus bonus) =>
      round.unusedPieces > 0
      ? bonus.addRunPoints(id, _pointsPerPiece * round.unusedPieces)
      : bonus;
}
