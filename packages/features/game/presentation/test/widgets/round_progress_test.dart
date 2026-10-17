import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/painting/round_progress_painter.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/round_card.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../pump_game.dart';

void main() {
  // Lands 1,050 ms in — after the burst, the chips, the mult and the product —
  // and fills the bar over the next 400 ms.
  List<GameEvent> clear({int total = 81}) => [
    const GameEvent.linesCleared(
      cells: [Cell(col: 7, row: 0)],
      cols: [],
      rows: [0],
    ),
    GameEvent.scoreAdded(
      bonusPoints: 0,
      chips: total - 1,
      lineScore: total - 1,
      mult: 1,
      piecePoints: 1,
      total: total,
    ),
  ];

  RoundProgressPainter bar(WidgetTester tester) =>
      tester
              .widget<CustomPaint>(
                find.descendant(
                  of: find.byType(RoundProgress),
                  matching: find.byType(CustomPaint),
                ),
              )
              .painter!
          as RoundProgressPainter;

  Future<void> playMove(
    WidgetTester tester,
    FakeGameRules rules,
    RunState after,
    List<GameEvent> events,
  ) async {
    final board = tester.getRect(find.byType(BoardView));
    final slot = tester.getCenter(find.byType(TraySlot).first);
    final cell = BoardGeometry(
      board.width,
    ).cellRect(const Cell(col: 7, row: 0)).center;

    rules.next = (after, events);
    await tester.dragFrom(
      slot,
      board.topLeft + cell + const Offset(0, 60) - slot,
    );
    await tester.pump();
  }

  /// Moves the clock on [duration], a frame every 20 ms.
  Future<void> play(WidgetTester tester, Duration duration) async {
    for (var elapsed = Duration.zero; elapsed < duration; elapsed += _frame) {
      await tester.pump(_frame);
    }
  }

  testWidgets('the bar fills to the landed score, with a glint as it grows', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    await playMove(
      tester,
      rules,
      runIn(const .playing(), score: 100),
      clear(total: 100),
    );

    // When: part way through the landing
    await play(tester, const Duration(milliseconds: 1150));

    // Then
    expect(bar(tester).fill.value, inExclusiveRange(0, 0.4));
    expect(bar(tester).shine.isAnimating, isTrue);

    // When: it settles
    await play(tester, const Duration(seconds: 1));

    // Then
    expect(bar(tester).fill.value, closeTo(0.4, 0.001));
    expect(bar(tester).shine.isAnimating, isFalse);
  });

  testWidgets('meeting the target pulses the bar and turns it', (tester) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing(), score: 200));
    await playMove(
      tester,
      rules,
      runIn(const .pickingJoker(offers: [.twin]), score: 281),
      [
        ...clear(),
        const GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 281),
      ],
    );

    // When: the fill is full
    await play(tester, const Duration(milliseconds: 1550));

    // Then
    expect(bar(tester).fill.value, 1);
    expect(bar(tester).pulse.isAnimating, isTrue);
    await play(tester, const Duration(seconds: 1));
    expect(bar(tester).complete.value, 1);
  });

  testWidgets('with reduce motion on, the bar lands without glint or pulse', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .playing(), score: 200),
      disableAnimations: true,
    );
    await playMove(
      tester,
      rules,
      runIn(const .pickingJoker(offers: [.twin]), score: 281),
      [
        ...clear(),
        const GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 281),
      ],
    );
    var glinted = false;
    var pulsed = false;

    // When
    for (var frame = 0; frame < 50; frame++) {
      await tester.pump(_frame);
      glinted |= bar(tester).shine.isAnimating;
      pulsed |= bar(tester).pulse.isAnimating;
    }

    // Then
    expect(bar(tester).fill.value, 1);
    expect(bar(tester).complete.value, 1);
    expect(glinted, isFalse);
    expect(pulsed, isFalse);
  });
}

const _frame = Duration(milliseconds: 20);
