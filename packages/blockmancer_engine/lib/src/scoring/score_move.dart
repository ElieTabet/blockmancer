import 'package:blockmancer_engine/src/board/board.br.dart';
import 'package:blockmancer_engine/src/board/cell.br.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/events/game_event.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';

/// A scored move and the state it leaves.
final class MoveScore {
  const MoveScore({
    required this.board,
    required this.chips,
    required this.fired,
    required this.mult,
    required this.points,
    required this.stonesDropped,
    required this.stonesRng,
    required this.storedMult,
    required this.streak,
  });

  final Board board;

  /// 0 when nothing cleared, like [mult].
  final int chips;
  final List<JokerFired> fired;
  final int mult;

  /// Everything the move adds to the round score.
  final int points;
  final List<Cell> stonesDropped;
  final Mulberry32 stonesRng;
  final int storedMult;
  final int streak;
}

const _chipsPerCell = 10;

/// Scores a placed piece once its lines have cleared: the piece's size, then on
/// a clear `chips × mult` with the jokers' additive effects applied before the
/// multiplicative ones, then flat bonuses.
MoveScore scoreMove({
  required ClearResult clear,
  required List<JokerEffect> jokers,
  required int pieceSize,
  required int previousStreak,
  required Mulberry32 stonesRng,
  required int storedMult,
}) {
  final move = MoveContext(
    clear: clear,
    jokerCount: jokers.length,
    pieceSize: pieceSize,
    storedMult: storedMult,
    streak: clear.clearedAny ? previousStreak + 1 : 0,
  );

  var step = const ScoreStep(chips: 0, mult: 0);

  if (clear.clearedAny) {
    step = ScoreStep(
      chips: _chipsPerCell * clear.cells.length,
      mult: clear.lineCount,
    );
    step = jokers.fold(step, (step, joker) => joker.onAdditive(move, step));
    step = jokers.fold(
      step,
      (step, joker) => joker.onMultiplicative(move, step),
    );
  }

  final after = jokers.fold(
    AfterMove(board: clear.board, stonesRng: stonesRng, storedMult: storedMult),
    (after, joker) => joker.afterMove(move, after),
  );

  return MoveScore(
    board: after.board,
    chips: step.chips,
    fired: [...step.fired, ...after.fired],
    mult: step.mult,
    points: pieceSize + step.chips * step.mult + after.bonusPoints,
    stonesDropped: after.stonesDropped,
    stonesRng: after.stonesRng,
    storedMult: after.storedMult,
    streak: move.streak,
  );
}
