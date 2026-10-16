import 'package:shared_domain/src/entities/game/cell.br.dart';

/// A piece, as offsets from the top-left cell of its bounding box — which is
/// also its anchor when placed. Pieces never rotate.
final class Shape {
  Shape({required List<Cell> cells, required this.id})
    : cells = List.unmodifiable(cells);

  /// Unmodifiable: shapes are shared by every run in the process, and a run
  /// stores only their ids.
  final List<Cell> cells;

  /// Distinct piece colours. A shape always wears the same one, as in the
  /// reference prototype.
  static const colorCount = 9;

  /// What a tray slot holds; `GameRules.shape` turns it back into the shape.
  final int id;

  int get colorIndex => id % colorCount;

  int get height => cells.map((cell) => cell.row).reduce(_max) + 1;

  int get size => cells.length;

  int get width => cells.map((cell) => cell.col).reduce(_max) + 1;

  static int _max(int a, int b) => a > b ? a : b;
}
