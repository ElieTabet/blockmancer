import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/hint_painter.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../pump_game.dart';

void main() {
  late int timesMarkedSeen;

  /// The practice run the tutorial hands over to, on its starting pick.
  final practiceStart = runIn(
    const .pickingJoker(offers: [.twin, .combo, .saver]),
    pickIndex: 0,
  );

  Future<FakeGameRules> pumpTutorial(WidgetTester tester) => pumpGame(
    tester,
    practiceStart,
    launch: .tutorial,
    markTutorialSeen: () async => timesMarkedSeen++,
  );

  List<Cell> litCells(WidgetTester tester) => tester
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .map((paint) => paint.painter)
      .whereType<HintPainter>()
      .single
      .cells;

  Future<void> play(
    WidgetTester tester,
    FakeGameRules rules,
    List<GameEvent> events,
  ) async {
    rules.next = (runIn(const .playing()), events);
    ProviderScope.containerOf(tester.element(find.byType(BoardView)))
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 3, row: 7), trayIndex: 0);
    await tester.pump(const Duration(seconds: 3));
  }

  setUp(() => timesMarkedSeen = 0);

  testWidgets('a tutorial opens on its first line, a spot lit on the board', (
    tester,
  ) async {
    // Given / When
    await pumpTutorial(tester);

    // Then
    expect(find.text('Drag a piece onto the board'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Pick your starting joker'), findsNothing);
    expect(litCells(tester), isNotEmpty);
  });

  testWidgets('Skip goes straight to a practice run’s starting pick', (
    tester,
  ) async {
    // Given
    await pumpTutorial(tester);

    // When
    await tester.tap(find.text('Skip'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    // Then
    expect(find.text('Drag a piece onto the board'), findsNothing);
    expect(find.text('Pick your starting joker'), findsOneWidget);
    expect(timesMarkedSeen, 1);
  });

  testWidgets(
    'the whole tutorial: place, clear, the score held until a touch, the pick',
    (tester) async {
      // Given
      final rules = await pumpTutorial(tester);

      // When: a piece is placed
      await play(tester, rules, const [
        GameEvent.piecePlaced(
          anchor: Cell(col: 0, row: 6),
          cells: [Cell(col: 0, row: 6)],
          shapeId: 1,
          trayIndex: 1,
        ),
      ]);

      // Then
      expect(find.text('Fill a row to clear it'), findsOneWidget);

      // When: a line is cleared
      await play(tester, rules, const [
        GameEvent.piecePlaced(
          anchor: Cell(col: 3, row: 7),
          cells: [Cell(col: 3, row: 7)],
          shapeId: 0,
          trayIndex: 0,
        ),
        GameEvent.linesCleared(cells: [], cols: [], rows: [7]),
        GameEvent.scoreAdded(
          bonusPoints: 0,
          chips: 80,
          lineScore: 80,
          mult: 1,
          piecePoints: 1,
          total: 81,
        ),
      ]);

      // Then: the score waits on chips × mult
      expect(find.text('Chips × mult = score'), findsOneWidget);
      expect(find.text('Tap to continue'), findsOneWidget);
      expect(find.text('= 80'), findsOneWidget);

      // When: the screen is touched
      await tester.tap(find.byType(BoardView));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 400));

      // Then: the real starting pick, with the pick's line
      expect(
        find.text('Pick your first joker — they work in pairs'),
        findsOneWidget,
      );
      expect(find.text('Pick your starting joker'), findsOneWidget);
      expect(timesMarkedSeen, 0);

      // When: a joker is taken
      rules.next = (runIn(const .playing(), jokers: const [.twin]), const []);
      await tester.tap(find.text('Twin Lines'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 400));

      // Then
      expect(
        find.text('Pick your first joker — they work in pairs'),
        findsNothing,
      );
      expect(find.text('Skip'), findsNothing);
      expect(timesMarkedSeen, 1);
    },
  );

  testWidgets('a daily run has no coach and nothing lit', (tester) async {
    // Given / When
    await pumpGame(tester, runIn(const .playing()));

    // Then
    expect(find.text('Skip'), findsNothing);
    expect(litCells(tester), isEmpty);
  });
}
