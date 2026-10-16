import 'dart:ui';

import 'package:shared_domain/shared_domain.dart';

/// Where the board's cells sit inside a square of [side] logical pixels.
final class BoardGeometry {
  const BoardGeometry(this.side);

  static const gap = 3.0;

  static const padding = 6.0;
  final double side;

  double get cellSize => pitch - gap;

  /// From one cell's left edge to the next one's.
  double get pitch => (side - 2 * padding + gap) / Board.size;

  /// The anchor that puts [shape]'s centre under [centre], a point in board
  /// coordinates; `null` when that centre is off the board.
  Cell? anchorFor(Shape shape, Offset centre) {
    if (centre.dx < 0 ||
        centre.dy < 0 ||
        centre.dx > side ||
        centre.dy > side) {
      return null;
    }

    final left = centre.dx - padding - shape.width * pitch / 2;
    final top = centre.dy - padding - shape.height * pitch / 2;

    return Cell(col: (left / pitch).round(), row: (top / pitch).round());
  }

  Rect cellRect(Cell cell) => Rect.fromLTWH(
    padding + cell.col * pitch,
    padding + cell.row * pitch,
    cellSize,
    cellSize,
  );
}
