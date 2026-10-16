import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:shared_domain/shared_domain.dart';

void main() {
  // 8 cells of pitch 40 plus 6 px padding either side, less one gap.
  const geometry = BoardGeometry(6 + 8 * 40 - 3 + 6);
  final single = Shape(cells: const [Cell(col: 0, row: 0)], id: 0);
  final square = Shape(
    cells: const [
      Cell(col: 0, row: 0),
      Cell(col: 1, row: 0),
      Cell(col: 0, row: 1),
      Cell(col: 1, row: 1),
    ],
    id: 9,
  );

  test('a single held over a cell anchors on that cell', () {
    // Given / When
    final anchor = geometry.anchorFor(
      single,
      const Offset(6 + 2 * 40 + 18, 6 + 5 * 40 + 18),
    );

    // Then
    expect(anchor, const Cell(col: 2, row: 5));
  });

  test('a square anchors its top-left so its centre stays under the point', () {
    // Given: the point sits where cells (3,3), (3,4), (4,3) and (4,4) meet
    // When
    final anchor = geometry.anchorFor(
      square,
      const Offset(6 + 4 * 40, 6 + 4 * 40),
    );

    // Then
    expect(anchor, const Cell(col: 3, row: 3));
  });

  test('a point off the board anchors nowhere', () {
    // Given / When / Then
    expect(geometry.anchorFor(single, const Offset(-1, 40)), isNull);
    expect(geometry.anchorFor(single, Offset(40, geometry.side + 1)), isNull);
  });

  test('cells are laid out on the pitch, inside the padding', () {
    // Given / When
    final rect = geometry.cellRect(const Cell(col: 1, row: 2));

    // Then
    expect(rect, const Rect.fromLTWH(6 + 40, 6 + 80, 37, 37));
  });
}
