import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';

/// A scored move and the state it leaves.
final class MoveScore {
  const MoveScore({
    required this.board,
    required this.bonusPoints,
    required this.chips,
    required this.fired,
    required this.lineScore,
    required this.mult,
    required this.points,
    required this.stonesDropped,
    required this.stonesRng,
    required this.storedMult,
    required this.streak,
  });

  final Board board;

  /// Flat points outside `chips × mult`, such as Clean Sweep's.
  final int bonusPoints;

  /// 0 when nothing cleared, like [mult].
  final int chips;
  final List<JokerFired> fired;

  /// `chips × mult`.
  final int lineScore;
  final int mult;

  /// Everything the move adds to the round score.
  final int points;
  final List<Cell> stonesDropped;
  final Mulberry32 stonesRng;
  final int storedMult;
  final int streak;
}

/// Scores a placed piece once its lines have cleared: the piece's size, then on
/// a clear `chips × mult` with the jokers' additive effects applied before the
/// multiplicative ones, then flat bonuses.
MoveScore scoreMove({
  required ClearResult clear,
  required RunConfig config,
  required List<JokerEffect> jokers,
  required int pieceSize,
  required int previousStreak,
  required Mulberry32 stonesRng,
  required int storedMult,
  required int? trayClearMask,
  required bool trayEmptied,
}) {
  final move = MoveContext(
    clear: clear,
    jokerCount: jokers.length,
    pieceSize: pieceSize,
    storedMult: storedMult,
    streak: clear.clearedAny ? previousStreak + 1 : 0,
    trayClearMask: trayClearMask,
    trayEmptied: trayEmptied,
    traySize: config.traySize,
    tuning: config.jokers,
  );

  var step = const ScoreStep(chips: 0, mult: 0);

  if (clear.clearedAny) {
    step = ScoreStep(
      chips: config.chipsPerCell * clear.cells.length,
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
    (after, joker) => joker.afterMove(after, move),
  );

  final lineScore = step.chips * step.mult;

  return MoveScore(
    board: after.board,
    bonusPoints: after.bonusPoints,
    chips: step.chips,
    fired: [...step.fired, ...after.fired],
    lineScore: lineScore,
    mult: step.mult,
    points: pieceSize + lineScore + after.bonusPoints,
    stonesDropped: after.stonesDropped,
    stonesRng: after.stonesRng,
    storedMult: after.storedMult,
    streak: move.streak,
  );
}
