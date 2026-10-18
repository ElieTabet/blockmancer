import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// When a round is won, +[JokerTuning.saverPointsPerPiece] run points per
/// unused piece.
final class Saver extends JokerEffect {
  const Saver();

  @override
  JokerId get id => .saver;

  @override
  JokerKind get kind => .flatBonus;

  @override
  JokerId get partner => .pockets;

  @override
  RoundBonus onRoundWon(RoundBonus bonus, RoundWonContext round) =>
      round.unusedPieces > 0
      ? bonus.addRunPoints(
          round.tuning.saverPointsPerPiece * round.unusedPieces,
          id,
        )
      : bonus;
}
