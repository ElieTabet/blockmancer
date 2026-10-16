import 'package:blockmancer_engine/blockmancer_engine.dart';

import 'board_picture.dart';

/// Places shape [shape] at [at] on the pictured board, clears and scores it.
MoveScore playMove(
  List<String> picture, {
  required Cell at,
  required int shape,
  List<JokerId> jokers = const [],
  int previousStreak = 0,
  int storedMult = 0,
}) {
  final piece = shapeCatalog[shape];
  final placed = placeShape(boardFrom(picture), piece, at);

  return scoreMove(
    clear: resolveClears(placed),
    jokers: effectsOf(jokers),
    pieceSize: piece.size,
    previousStreak: previousStreak,
    stonesRng: const Mulberry32(1),
    storedMult: storedMult,
  );
}

/// Row 0 full but its last cell.
const rowAlmostFull = ['#######.'];

/// Row 0 and column 0 full but their shared corner.
const crossAlmostFull = [
  '.#######',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
];

/// Column 0 full but its top cell.
const columnAlmostFull = [
  '........',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
  '#.......',
];

const topLeft = Cell(col: 0, row: 0);
const topRight = Cell(col: 7, row: 0);
