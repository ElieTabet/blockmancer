import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/entities/tutorial_step.dart';
import 'package:game_presentation/src/notifiers/tutorial_hint.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';

/// Rules where a single fills one empty cell, and a domino two side by side,
/// and a placement that fills a row clears it.
final class _RowRules implements GameRules {
  const _RowRules();

  static const _domino = 1;

  @override
  bool canPlace(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) => _cellsOf(
    state,
    anchor,
    trayIndex,
  ).every((cell) => cell.col < Board.size && state.board.at(cell) is EmptyCell);

  @override
  PlacementPreview preview(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) {
    final cells = _cellsOf(state, anchor, trayIndex);
    final filled = state.board.withCells({
      for (final cell in cells) cell: const .filled(colorIndex: 0),
    });

    return PlacementPreview(
      cells: cells,
      clearingCols: const [],
      clearingRows: [
        for (final row in {for (final cell in cells) cell.row})
          if ([
            for (var col = 0; col < Board.size; col++)
              filled.at(Cell(col: col, row: row)),
          ].every((state) => state is! EmptyCell))
            row,
      ],
      colliding: const [],
      fits: true,
    );
  }

  List<Cell> _cellsOf(RunState state, Cell anchor, int trayIndex) => [
    anchor,
    if (state.tray[trayIndex] == _domino)
      Cell(col: anchor.col + 1, row: anchor.row),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const gap = Cell(col: 3, row: Board.size - 1);

  // The tutorial's board: the bottom row full but for one cell.
  final board = Board.empty().withCells({
    for (var col = 0; col < Board.size; col++)
      if (col != gap.col)
        Cell(col: col, row: gap.row): const .filled(colorIndex: 0),
  });

  List<Cell> hintOn(TutorialStep step, {List<int?> tray = const [0, 1]}) =>
      tutorialHintFor(
        runIn(const .playing(), board: board, tray: tray),
        rules: const _RowRules(),
        step: step,
      );

  test('the clear step points at the gap a piece completes the row in', () {
    // Given / When
    final hint = hintOn(.clear);

    // Then
    expect(hint, [gap]);
  });

  test('the drag step points at a spot low on the board, keeping the clearing '
      'piece for the next step', () {
    // Given / When
    final hint = hintOn(.drag);

    // Then: the domino, just above the full row
    expect(hint, const [Cell(col: 0, row: 6), Cell(col: 1, row: 6)]);
  });

  test('with only the clearing piece left, the drag step points with it', () {
    // Given / When
    final hint = hintOn(.drag, tray: const [0, null]);

    // Then: somewhere it clears nothing
    expect(hint, const [Cell(col: 0, row: 6)]);
  });

  test('nothing is pointed at once no piece can clear the row', () {
    // Given / When
    final hint = hintOn(.clear, tray: const [null, 1]);

    // Then
    expect(hint, isEmpty);
  });

  for (final step in const <TutorialStep>[.pick, .score]) {
    test('nothing is pointed at on the ${step.name} step', () {
      // Given / When / Then
      expect(hintOn(step), isEmpty);
    });
  }
}
