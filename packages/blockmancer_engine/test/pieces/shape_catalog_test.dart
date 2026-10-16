import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

void main() {
  test('the catalog holds the 19 shapes of the brief, by size', () {
    // Given / When
    final sizes = shapeCatalog.map((shape) => shape.size);

    // Then
    expect(sizes, [1, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 9, 5, 5]);
  });

  test('every shape is anchored on the top-left of its bounding box', () {
    // Given / When / Then
    for (final shape in shapeCatalog) {
      expect(
        shape.cells.map((cell) => cell.row).reduce((a, b) => a < b ? a : b),
        0,
      );
      expect(
        shape.cells.map((cell) => cell.col).reduce((a, b) => a < b ? a : b),
        0,
      );
    }
  });

  test('a shape knows its bounding box', () {
    // Given
    final threeByThree = shapeCatalog[16];
    final verticalFive = shapeCatalog[18];

    // When / Then
    expect((threeByThree.width, threeByThree.height), (3, 3));
    expect((verticalFive.width, verticalFive.height), (1, 5));
  });

  test('ids follow catalog order and colours cycle through nine', () {
    // Given / When / Then
    expect(shapeCatalog.map((shape) => shape.id), List.generate(19, (i) => i));
    expect(shapeCatalog[9].colorIndex, 0);
    expect(shapeCatalog[18].colorIndex, 0);
  });

  test('a shape cannot be changed, since every run shares it', () {
    // Given / When / Then
    expect(
      () => shapeCatalog[16].cells.add(const Cell(col: 5, row: 5)),
      throwsUnsupportedError,
    );
  });
}
