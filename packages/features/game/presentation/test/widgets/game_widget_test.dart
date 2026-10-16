import 'package:design_system/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/painting/board_painter.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';

void main() {
  Future<FakeGameRules> pumpGame(WidgetTester tester, RunState start) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final rules = FakeGameRules(start: start);

    await tester.pumpWidget(
      ProviderScope(
        overrides: bindProviders(gameRules: (ref) => rules),
        child: TranslationProvider(
          child: MaterialApp(
            theme: DSTheme.instance.darkTheme,
            home: const GameWidget(),
          ),
        ),
      ),
    );
    await tester.pump();

    return rules;
  }

  testWidgets('offers the starting jokers, and taking one closes the sheet', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .pickingJoker(offers: [.twin, .combo, .saver]), pickIndex: 0),
    );
    rules.next = (runIn(const .playing(), jokers: const [.twin]), const []);

    expect(find.text('Pick your starting joker'), findsOneWidget);

    // When
    await tester.tap(find.text('Twin Lines'));
    await tester.pump();

    // Then
    expect(rules.calls.last, 'pickJoker JokerId.twin');
    expect(find.text('Pick your starting joker'), findsNothing);
  });

  testWidgets('after a round, the offer names the next target', (tester) async {
    // Given / When
    await pumpGame(
      tester,
      runIn(const .pickingJoker(offers: [.twin]), jokers: const [.patience]),
    );

    // Then: round 2 is the boss in the test config
    expect(find.text('Round cleared!'), findsOneWidget);
    expect(
      find.text('Pick a joker. Next: Boss · 2000 pts with stones.'),
      findsOneWidget,
    );
    expect(find.text('★ Completes a pair with your Patience'), findsOneWidget);
  });

  testWidgets('a lost round offers a revive and a way out', (tester) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .outOfPieces), score: 120),
    );

    expect(find.text('Out of pieces'), findsOneWidget);
    expect(find.text('120 of 250 points this round.'), findsOneWidget);
    expect(find.text('Revive · clear 2 rows + 3 pieces'), findsOneWidget);

    // When
    await tester.tap(find.text('End run'));
    await tester.pump();

    // Then
    expect(rules.calls.last, 'endRun');
  });

  testWidgets('a revive already used is not offered again', (tester) async {
    // Given / When
    await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom), revivesUsed: 1),
    );

    // Then
    expect(find.text('No room left'), findsOneWidget);
    expect(find.text('Revive · clear 2 rows + 3 pieces'), findsNothing);
  });

  testWidgets('the board draws what the run holds', (tester) async {
    // Given
    final board = Board.empty().withCells({
      const Cell(col: 0, row: 0): const .stone(),
    });

    // When
    await pumpGame(tester, runIn(const .playing(), board: board));

    // Then
    final painters = tester
        .widgetList<CustomPaint>(
          find.descendant(
            of: find.byType(BoardView),
            matching: find.byType(CustomPaint),
          ),
        )
        .map((paint) => paint.painter)
        .whereType<BoardPainter>();
    expect(painters.single.board, board);
  });

  testWidgets('dragging a tray piece onto a cell places it there', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    final boardRect = tester.getRect(find.byType(BoardView));
    final geometry = BoardGeometry(boardRect.width);
    final cellCentre =
        boardRect.topLeft +
        geometry.cellRect(const Cell(col: 3, row: 2)).center;

    // When: the piece rides 60 px above the finger
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(TraySlot).first),
      kind: PointerDeviceKind.touch,
    );
    await gesture.moveTo(cellCentre + const Offset(0, 60));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    // Then
    expect(rules.calls.last, 'place 0 (2, 3)');
  });
}
