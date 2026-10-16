import 'package:blockmancer_engine/src/board/cell.br.dart';

/// A piece, as offsets from the top-left cell of its bounding box — which is
/// also its anchor when placed. Pieces never rotate.
final class Shape {
  const Shape({required this.cells, required this.id});

  final List<Cell> cells;

  /// The shape's index in [shapeCatalog]; the draw streams return it.
  final int id;

  /// Distinct piece colours. A shape always wears the same one, as in the
  /// reference prototype.
  static const colorCount = 9;

  int get colorIndex => id % colorCount;

  int get height => cells.map((cell) => cell.row).reduce(_max) + 1;

  int get size => cells.length;

  int get width => cells.map((cell) => cell.col).reduce(_max) + 1;

  static int _max(int a, int b) => a > b ? a : b;
}
