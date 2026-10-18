import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/painting/board_painter.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';
import '../pump_game.dart';

void main() {
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

  testWidgets('taking the joker before the boss raises no error', (
    tester,
  ) async {
    // Given: the last pick of the test config, whose next round is the boss
    final rules = await pumpGame(
      tester,
      runIn(const .pickingJoker(offers: [.twin]), pickIndex: 1),
    );
    rules.next = (
      runIn(const .playing(), pickIndex: 2, roundIndex: 1),
      const [],
    );

    // When
    await tester.tap(find.text('Twin Lines'));
    await tester.pump();

    // Then
    expect(tester.takeException(), isNull);
    expect(rules.calls.last, 'pickJoker JokerId.twin');
  });

  testWidgets('a won round’s title names the Saver bonus', (tester) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    rules.next = (
      runIn(const .pickingJoker(offers: [.twin])),
      const [GameEvent.roundWon(bonus: 120, roundIndex: 0, score: 260)],
    );

    // When
    final board = tester.getRect(find.byType(BoardView));
    final finger = await tester.startGesture(
      tester.getCenter(find.byType(TraySlot).first),
    );
    await finger.moveTo(
      board.topLeft +
          BoardGeometry(
            board.width,
          ).cellRect(const Cell(col: 0, row: 0)).center +
          const Offset(0, 60),
    );
    await finger.up();
    await tester.pump(const Duration(milliseconds: 150));

    // Then: once the piece has landed
    expect(find.text('Round cleared! Saver +120'), findsOneWidget);
  });

  testWidgets('revive is offered with the run’s own numbers, and taken', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom)),
    );

    // When
    await tester.tap(find.text('Revive · clear 2 rows + 3 pieces'));
    await tester.pump();

    // Then
    expect(rules.calls.last, 'revive');
  });

  testWidgets('a won run shows its total and build, and can be retried', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .won(), jokers: const [.twin, .patience], runTotal: 12345),
    );

    expect(find.text('BOSS BEATEN · RUN COMPLETE'), findsOneWidget);
    expect(find.text('12,345 points'), findsOneWidget);
    expect(find.text('Build: Twin Lines, Patience'), findsOneWidget);

    // When
    await tester.tap(find.text('Play again'));
    await tester.pump();

    // Then
    expect(rules.calls, ['startRun 1', 'startRun 1']);
  });

  testWidgets('an ended run names the round it reached', (tester) async {
    // Given / When
    await pumpGame(tester, runIn(const .over(), runTotal: 900));

    // Then
    expect(find.text('RUN OVER · REACHED ROUND 1'), findsOneWidget);
    expect(find.text('Build: none'), findsOneWidget);
  });

  testWidgets('the run total groups its thousands', (tester) async {
    // Given / When
    await pumpGame(
      tester,
      runIn(const .playing(), runTotal: 12000, score: 345),
    );

    // Then
    expect(find.text('Run 12,345'), findsOneWidget);
  });

  testWidgets(
    'the round card shows the streak, the stored mult and what is left',
    (tester) async {
      // Given / When
      await pumpGame(
        tester,
        runIn(
          const .playing(),
          piecesLeft: 0,
          storedMult: 4,
          streak: 3,
          tray: const [0, null, null],
        ),
      );

      // Then
      expect(find.text('Combo ×3 · +4 mult stored'), findsOneWidget);
      expect(find.text('1 piece left'), findsOneWidget);
    },
  );

  testWidgets('the round card names the boss rather than numbering it', (
    tester,
  ) async {
    // Given / When
    await pumpGame(tester, runIn(const .playing(), roundIndex: 1));

    // Then
    expect(find.text('Boss · Rubble'), findsOneWidget);
  });

  testWidgets('a round the tide flooded says so', (tester) async {
    // Given / When
    await pumpGame(tester, runIn(const .roundLost(reason: .flooded)));

    // Then
    expect(find.text('Flooded'), findsOneWidget);
  });

  testWidgets("in Tide's boss, the round card counts the pieces left before "
      'the tide rises', (tester) async {
    // Given / When: two singles left in the tray
    await pumpGame(
      tester,
      runIn(
        const .playing(),
        roundIndex: 1,
        tray: const [0, null, 0],
      ).copyWith(config: testConfig.copyWith(world: .tide)),
    );

    // Then
    expect(find.text('Tide in 2'), findsOneWidget);
  });

  testWidgets('outside Tide\'s boss, no tide is counted', (tester) async {
    // Given / When
    await pumpGame(
      tester,
      runIn(
        const .playing(),
      ).copyWith(config: testConfig.copyWith(world: .tide)),
    );

    // Then
    expect(find.textContaining('Tide in'), findsNothing);
  });

  testWidgets('a finished run shows the best it is measured against', (
    tester,
  ) async {
    // Given
    final scores = FakeBestScores()..saved[testDay] = 4200;
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom)),
      bestScores: scores,
    );
    rules.next = (
      runIn(const .over(), runTotal: 900),
      const [GameEvent.runOver(total: 900)],
    );

    // When
    await tester.tap(find.text('End run'));
    await tester.pump();
    await tester.pump();

    // Then
    expect(find.text('Best: 4,200'), findsOneWidget);
  });

  testWidgets('a lost round is revived only once the reward is earned', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .outOfPieces)),
      rewardedAction: () async => const .closed(),
    );

    // When
    await tester.tap(find.text('Revive · clear 2 rows + 3 pieces'));
    await tester.pump();

    // Then
    expect(rules.calls, isNot(contains('revive')));
    expect(find.text('Out of pieces'), findsOneWidget);
  });

  testWidgets('with no rewarded ad loaded, the revive says so and does nothing '
      'when tapped', (tester) async {
    // Given
    var asked = 0;
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .outOfPieces)),
      rewardedAction: () async {
        asked++;

        return const .earned();
      },
      rewardedAdReady: false,
    );

    // When
    await tester.tap(find.text('No ad to revive with right now'));
    await tester.pump();

    // Then
    expect(asked, 0);
    expect(rules.calls, isNot(contains('revive')));
    expect(find.text('Out of pieces'), findsOneWidget);
  });

  testWidgets('a run that beats the best says so', (tester) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom)),
    );
    rules.next = (
      runIn(const .over(), runTotal: 900),
      const [GameEvent.runOver(total: 900)],
    );

    // When
    await tester.tap(find.text('End run'));
    await tester.pump();
    await tester.pump();

    // Then
    expect(find.text('New best!'), findsOneWidget);
  });

  testWidgets('no best is shown while it is still being read', (tester) async {
    // Given
    final scores = FakeBestScores()..gate = Completer<void>();
    final rules = await pumpGame(
      tester,
      runIn(const .roundLost(reason: .noRoom)),
      bestScores: scores,
    );
    rules.next = (
      runIn(const .over(), runTotal: 900),
      const [GameEvent.runOver(total: 900)],
    );

    // When
    await tester.tap(find.text('End run'));
    await tester.pump();

    // Then
    expect(find.text('900 points'), findsOneWidget);
    expect(find.textContaining('best'), findsNothing);
    expect(find.textContaining('Best'), findsNothing);
    scores.gate!.complete();
  });

  testWidgets('a practice run says it is practice', (tester) async {
    // Given / When
    await pumpGame(tester, runIn(const .playing()), launch: .practice);

    // Then
    expect(find.text('Practice · a new run every time'), findsOneWidget);
  });

  testWidgets('the back arrow leaves for the menu', (tester) async {
    // Given
    final routing = FakeGameRouting();
    await pumpGame(tester, runIn(const .playing()), routing: routing);

    // When
    await tester.tap(find.bySemanticsLabel('Back to the menu'));
    await tester.pump();

    // Then
    expect(routing.calls, ['leave']);
  });

  testWidgets('the back button shows no words, even when held', (tester) async {
    // Given
    await pumpGame(tester, runIn(const .playing()));

    // When
    await tester.longPress(find.bySemanticsLabel('Back to the menu'));
    await tester.pump();

    // Then
    expect(find.text('Back to the menu'), findsNothing);
  });

  testWidgets('the menu can be reached while a joker is being picked', (
    tester,
  ) async {
    // Given
    final routing = FakeGameRouting();
    await pumpGame(
      tester,
      runIn(const .pickingJoker(offers: [.twin]), pickIndex: 0),
      routing: routing,
    );

    // When
    await tester.tap(find.bySemanticsLabel('Back to the menu'));
    await tester.pump();

    // Then
    expect(routing.calls, ['leave']);
  });
}
