import 'package:design_system/design_system.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/painting/hint_painter.dart';
import 'package:shared_domain/shared_domain.dart';

void main() {
  const size = Size.square(323);

  test('each cell pointed at is lit and outlined in amber', () {
    // Given
    final painter = HintPainter(
      cells: const [Cell(col: 3, row: 7)],
      pulse: const AlwaysStoppedAnimation(1),
    );

    // When / Then
    expect(
      (Canvas canvas) => painter.paint(canvas, size),
      paints
        ..rrect(color: DSColor.accent.withValues(alpha: 0.35))
        ..rrect(color: DSColor.accent, style: .stroke),
    );
  });

  test('with nothing pointed at, nothing is painted', () {
    // Given
    final painter = HintPainter(
      cells: const [],
      pulse: const AlwaysStoppedAnimation(1),
    );

    // When / Then
    expect((Canvas canvas) => painter.paint(canvas, size), paintsNothing);
  });
}
