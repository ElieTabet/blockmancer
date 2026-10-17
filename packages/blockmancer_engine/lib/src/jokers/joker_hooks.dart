import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';

/// What a joker can read about the move being scored.
final class MoveContext {
  const MoveContext({
    required this.clear,
    required this.jokerCount,
    required this.pieceSize,
    required this.storedMult,
    required this.streak,
    required this.tuning,
  });

  final ClearResult clear;
  final int jokerCount;
  final int pieceSize;

  /// Patience's bank before this move.
  final int storedMult;

  /// Consecutive clearing moves, this one included.
  final int streak;
  final JokerTuning tuning;
}

/// Chips and mult as they pass through the jokers, with what fired so far.
final class ScoreStep {
  const ScoreStep({
    required this.chips,
    required this.mult,
    this.fired = const [],
  });

  final int chips;
  final List<JokerFired> fired;
  final int mult;

  ScoreStep addChips(int amount, JokerId joker) => ScoreStep(
    chips: chips + amount,
    fired: [
      ...fired,
      JokerFired(
        delta: .chipsAdded(amount: amount),
        joker: joker,
      ),
    ],
    mult: mult,
  );

  ScoreStep addMult(int amount, JokerId joker) => ScoreStep(
    chips: chips,
    fired: [
      ...fired,
      JokerFired(
        delta: .multAdded(amount: amount),
        joker: joker,
      ),
    ],
    mult: mult + amount,
  );

  ScoreStep multiplyMult(int factor, JokerId joker) => ScoreStep(
    chips: chips,
    fired: [
      ...fired,
      JokerFired(
        delta: .multMultiplied(factor: factor),
        joker: joker,
      ),
    ],
    mult: mult * factor,
  );
}

/// What a move leaves behind once scored: the board, Patience's bank, flat
/// bonuses and stones dropped from the stones stream.
final class AfterMove {
  const AfterMove({
    required this.board,
    required this.stonesRng,
    required this.storedMult,
    this.bonusPoints = 0,
    this.fired = const [],
    this.stonesDropped = const [],
  });

  final int bonusPoints;
  final Board board;
  final List<JokerFired> fired;
  final List<Cell> stonesDropped;
  final Mulberry32 stonesRng;
  final int storedMult;

  AfterMove addPoints(int amount, JokerId joker) => _copy(
    bonusPoints: bonusPoints + amount,
    fired: [
      ...fired,
      JokerFired(
        delta: .pointsAdded(amount: amount),
        joker: joker,
      ),
    ],
  );

  /// Turns a random empty cell to stone (see [stoneCells]); a full board
  /// takes none.
  AfterMove dropStone(JokerId joker) {
    final cells = stoneCells(board);

    if (cells.isEmpty) return this;

    final (index, nextRng) = stonesRng.nextInt(cells.length);
    final cell = cells[index];

    return _copy(
      board: board.withCells({cell: const .stone()}),
      fired: [
        ...fired,
        JokerFired(
          delta: .stoneDropped(cell: cell),
          joker: joker,
        ),
      ],
      stonesDropped: [...stonesDropped, cell],
      stonesRng: nextRng,
    );
  }

  AfterMove resetStoredMult() => _copy(storedMult: 0);

  AfterMove storeMult(int amount, JokerId joker) => _copy(
    fired: [
      ...fired,
      JokerFired(
        delta: .multStored(total: storedMult + amount),
        joker: joker,
      ),
    ],
    storedMult: storedMult + amount,
  );

  AfterMove _copy({
    int? bonusPoints,
    Board? board,
    List<JokerFired>? fired,
    List<Cell>? stonesDropped,
    Mulberry32? stonesRng,
    int? storedMult,
  }) => AfterMove(
    board: board ?? this.board,
    bonusPoints: bonusPoints ?? this.bonusPoints,
    fired: fired ?? this.fired,
    stonesDropped: stonesDropped ?? this.stonesDropped,
    stonesRng: stonesRng ?? this.stonesRng,
    storedMult: storedMult ?? this.storedMult,
  );
}

/// How a round starts: its pieces and the stones dropped on the board.
final class RoundSetup {
  const RoundSetup({
    required this.pieces,
    required this.stones,
    this.fired = const [],
  });

  final List<JokerFired> fired;
  final int pieces;
  final int stones;

  RoundSetup addPieces(int amount, JokerId joker) => RoundSetup(
    fired: [
      ...fired,
      JokerFired(
        delta: .piecesAdded(amount: amount),
        joker: joker,
      ),
    ],
    pieces: pieces + amount,
    stones: stones,
  );

  RoundSetup addStones(int amount, JokerId joker) => RoundSetup(
    fired: [
      ...fired,
      JokerFired(
        delta: .stonesAdded(amount: amount),
        joker: joker,
      ),
    ],
    pieces: pieces,
    stones: stones + amount,
  );
}

/// Run points a won round earns on top of its score.
final class RoundBonus {
  const RoundBonus({this.fired = const [], this.runPoints = 0});

  final List<JokerFired> fired;
  final int runPoints;

  RoundBonus addRunPoints(int amount, JokerId joker) => RoundBonus(
    fired: [
      ...fired,
      JokerFired(
        delta: .runPointsAdded(amount: amount),
        joker: joker,
      ),
    ],
    runPoints: runPoints + amount,
  );
}

final class RoundWonContext {
  const RoundWonContext({required this.tuning, required this.unusedPieces});

  final JokerTuning tuning;

  /// Pieces still in the tray plus those not drawn yet.
  final int unusedPieces;
}
