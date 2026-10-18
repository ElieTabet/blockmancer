import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:blockmancer_engine/src/scoring/score_move.dart';
import 'package:shared_domain/shared_domain.dart';
import 'board_picture.dart';
import 'brief_config.dart';

/// Places shape [shape] at [at] on the pictured board, clears and scores it.
MoveScore playMove(
  List<String> picture, {
  required Cell at,
  required int shape,
  RunConfig config = briefConfig,
  bool firstOfTray = false,
  List<JokerId> jokers = const [],
  int momentumStreak = 0,
  int previousStreak = 0,
  int storedMult = 0,
  int? trayClearMask,
  bool trayEmptied = false,
}) {
  final piece = shapeCatalog[shape];
  final placed = placeShape(boardFrom(picture), piece, anchor: at);

  return scoreMove(
    clear: resolveClears(placed),
    config: config,
    jokers: effectsOf(jokers),
    pieceSize: piece.size,
    previousStreak: previousStreak,
    stonesRng: const Mulberry32(1),
    storedMult: storedMult,
    trayClearMask: trayClearMask,
    trayEmptied: trayEmptied,
    firstOfTray: firstOfTray,
    momentumStreak: momentumStreak,
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

/// [rows] as the bottom of an otherwise empty board.
List<String> atBottom(List<String> rows) => [
  ...List.filled(Board.size - rows.length, '........'),
  ...rows,
];

const bottomRight = Cell(col: 7, row: 7);
const topLeft = Cell(col: 0, row: 0);
const topRight = Cell(col: 7, row: 0);
