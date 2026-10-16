import 'package:blockmancer_engine/src/board/cell.br.dart';
import 'package:blockmancer_engine/src/pieces/shape.dart';

/// The 19 shapes, in the brief's order. Draws index into this list, so
/// reordering it changes every seeded run.
final List<Shape> shapeCatalog = List.unmodifiable([
  for (final (id, cells) in _offsets.indexed)
    Shape(
      cells: [for (final (row, col) in cells) Cell(col: col, row: row)],
      id: id,
    ),
]);

const _offsets = <List<(int, int)>>[
  [(0, 0)],
  [(0, 0), (0, 1)],
  [(0, 0), (1, 0)],
  [(0, 0), (0, 1), (0, 2)],
  [(0, 0), (1, 0), (2, 0)],
  [(0, 0), (1, 0), (1, 1)],
  [(0, 0), (0, 1), (1, 0)],
  [(0, 0), (0, 1), (1, 1)],
  [(0, 1), (1, 0), (1, 1)],
  [(0, 0), (0, 1), (1, 0), (1, 1)],
  [(0, 0), (0, 1), (0, 2), (0, 3)],
  [(0, 0), (1, 0), (2, 0), (3, 0)],
  [(0, 0), (0, 1), (0, 2), (1, 1)],
  [(0, 0), (1, 0), (2, 0), (2, 1)],
  [(0, 1), (1, 1), (2, 0), (2, 1)],
  [(0, 1), (0, 2), (1, 0), (1, 1)],
  [(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (1, 2), (2, 0), (2, 1), (2, 2)],
  [(0, 0), (0, 1), (0, 2), (0, 3), (0, 4)],
  [(0, 0), (1, 0), (2, 0), (3, 0), (4, 0)],
];
