import 'package:design_system/design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/notifiers/drag_preview.br.dart';
import 'package:game_presentation/src/painting/preview_painter.dart';
import 'package:shared_domain/shared_domain.dart';

void main() {
  const size = Size.square(323);
  const cell = Cell(col: 2, row: 2);

  void Function(Canvas) painting(PlacementPreview preview) =>
      (canvas) => PreviewPainter(
        DragPreview(
          anchor: cell,
          colorIndex: 1,
          preview: preview,
          trayIndex: 0,
        ),
      ).paint(canvas, size);

  test('a piece that fits is shadowed in its own colour, outlined', () {
    // Given
    const preview = PlacementPreview(
      cells: [cell],
      clearingCols: [],
      clearingRows: [],
      colliding: [],
      fits: true,
    );

    // When / Then
    expect(
      painting(preview),
      paints
        ..rrect(color: DSGameColor.pieces[1].withValues(alpha: 0.6))
        ..rrect(color: DSGameColor.pieces[1], style: .stroke),
    );
  });

  test('a cell the piece collides with is solid red', () {
    // Given
    const preview = PlacementPreview(
      cells: [cell],
      clearingCols: [],
      clearingRows: [],
      colliding: [cell],
      fits: false,
    );

    // When / Then
    expect(
      painting(preview),
      paints
        ..rrect(color: DSGameColor.collision)
        ..rrect(color: DSGameColor.collisionOutline, style: .stroke),
    );
  });

  test('the lines a drop would clear are outlined', () {
    // Given
    const preview = PlacementPreview(
      cells: [cell],
      clearingCols: [],
      clearingRows: [2],
      colliding: [],
      fits: true,
    );

    // When / Then: the seven other cells of row 2 come first
    expect(
      painting(preview),
      paints..rrect(color: DSGameColor.clearingOutline, style: .stroke),
    );
  });

  test('no drag paints nothing', () {
    // Given / When / Then
    expect(
      (Canvas canvas) => const PreviewPainter(null).paint(canvas, size),
      paintsNothing,
    );
  });

  test('in Mirror\'s boss, the cells under the finger are outlined, the '
      'shadow where the piece lands', () {
    // Given: held in the top-left corner, landing in the top-right one
    const landing = Cell(col: 7, row: 0);
    final painter = PreviewPainter(
      const DragPreview(
        anchor: Cell(col: 0, row: 0),
        colorIndex: 1,
        held: [Cell(col: 0, row: 0)],
        preview: PlacementPreview(
          cells: [landing],
          clearingCols: [],
          clearingRows: [],
          colliding: [],
          fits: true,
        ),
        trayIndex: 0,
      ),
    );

    // When / Then
    expect(
      (Canvas canvas) => painter.paint(canvas, size),
      paints
        ..rrect(color: DSColor.white.withValues(alpha: 0.7), style: .stroke)
        ..rrect(color: DSGameColor.pieces[1].withValues(alpha: 0.6)),
    );
  });
}
