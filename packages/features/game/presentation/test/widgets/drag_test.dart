import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../pump_game.dart';

void main() {
  const lift = Offset(0, 60);

  Offset centreOf(WidgetTester tester, Cell cell) {
    final board = tester.getRect(find.byType(BoardView));

    return board.topLeft + BoardGeometry(board.width).cellRect(cell).center;
  }

  Offset slot(WidgetTester tester, int index) =>
      tester.getCenter(find.byType(TraySlot).at(index));

  bool placed(FakeGameRules rules) =>
      rules.calls.any((call) => call.startsWith('place'));

  testWidgets('a cancelled drag places nothing', (tester) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    final finger = await tester.startGesture(slot(tester, 0));
    await finger.moveTo(centreOf(tester, const Cell(col: 3, row: 3)) + lift);
    await tester.pump();

    // When
    await finger.cancel();
    await tester.pump();

    // Then
    expect(placed(rules), isFalse);
  });

  testWidgets('a piece carried back off the board places nothing', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    final finger = await tester.startGesture(slot(tester, 0));
    await finger.moveTo(centreOf(tester, const Cell(col: 3, row: 3)) + lift);
    await tester.pump();

    // When
    await finger.moveTo(const Offset(5, 5));
    await tester.pump();
    await finger.up();
    await tester.pump();

    // Then
    expect(placed(rules), isFalse);
  });

  testWidgets('a second finger is ignored while the first one drags', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    final first = await tester.startGesture(slot(tester, 0), pointer: 1);
    final second = await tester.startGesture(slot(tester, 1), pointer: 2);

    // When
    await second.moveTo(centreOf(tester, const Cell(col: 5, row: 5)) + lift);
    await second.up();
    await first.moveTo(centreOf(tester, const Cell(col: 1, row: 1)) + lift);
    await first.up();
    await tester.pump();

    // Then
    expect(rules.calls.where((call) => call.startsWith('place')), [
      'place 0 (1, 1)',
    ]);
  });

  testWidgets('a mouse drags the piece right under the pointer', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    final mouse = await tester.startGesture(
      slot(tester, 0),
      kind: PointerDeviceKind.mouse,
    );

    // When
    await mouse.moveTo(centreOf(tester, const Cell(col: 6, row: 4)));
    await tester.pump();
    await mouse.up();
    await tester.pump();

    // Then
    expect(rules.calls.last, 'place 0 (4, 6)');
  });

  testWidgets('an empty tray slot cannot be picked up', (tester) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .playing(), tray: const [null, 0, 0]),
    );
    final finger = await tester.startGesture(slot(tester, 0));

    // When
    await finger.moveTo(centreOf(tester, const Cell(col: 3, row: 3)) + lift);
    await finger.up();
    await tester.pump();

    // Then
    expect(placed(rules), isFalse);
  });

  testWidgets('a drag still going when the screen closes is dropped quietly', (
    tester,
  ) async {
    // Given
    await pumpGame(tester, runIn(const .playing()));
    final finger = await tester.startGesture(slot(tester, 0));

    // When
    await tester.pumpWidget(const SizedBox());
    await finger.moveTo(const Offset(100, 100));
    await finger.up();
    await tester.pump();

    // Then
    expect(tester.takeException(), isNull);
  });

  group('right after a clear', () {
    const clear = <GameEvent>[
      GameEvent.linesCleared(cells: [], cols: [], rows: [0]),
      GameEvent.scoreAdded(
        bonusPoints: 0,
        chips: 80,
        lineScore: 80,
        mult: 1,
        piecePoints: 1,
        total: 81,
      ),
    ];

    Future<FakeGameRules> clearOneLine(WidgetTester tester) async {
      final rules = await pumpGame(tester, runIn(const .playing()));
      rules.next = (runIn(const .playing(), score: 81), clear);
      await tester.dragFrom(
        slot(tester, 0),
        centreOf(tester, const Cell(col: 7, row: 0)) + lift - slot(tester, 0),
      );
      await tester.pump();
      rules.calls.clear();

      return rules;
    }

    Future<void> dropOnCentre(WidgetTester tester) async {
      final finger = await tester.startGesture(slot(tester, 1));
      await finger.moveTo(centreOf(tester, const Cell(col: 3, row: 3)) + lift);
      await finger.up();
      await tester.pump();
    }

    testWidgets('no piece can be grabbed while the score is shown', (
      tester,
    ) async {
      // Given
      final rules = await clearOneLine(tester);

      // When
      await tester.pump(const Duration(milliseconds: 300));
      await dropOnCentre(tester);

      // Then
      expect(placed(rules), isFalse);
    });

    testWidgets('pieces can be grabbed again once the score is shown', (
      tester,
    ) async {
      // Given
      final rules = await clearOneLine(tester);

      // When
      await tester.pump(const Duration(milliseconds: 700));
      await dropOnCentre(tester);

      // Then
      expect(rules.calls, ['place 1 (3, 3)']);
    });
  });
}
