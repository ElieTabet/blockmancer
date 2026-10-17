import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/painting/board_effects_painter.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/combo_pop.dart';
import 'package:game_presentation/src/widgets/game_header.dart';
import 'package:game_presentation/src/widgets/input_gate.dart';
import 'package:game_presentation/src/widgets/joker_chips.dart';
import 'package:game_presentation/src/widgets/round_card.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';
import '../pump_game.dart';

void main() {
  const lift = Offset(0, 60);

  // Played back in 1.3 s: the burst, the chips, the mult, the product and the
  // landing.
  const clear = <GameEvent>[
    GameEvent.linesCleared(cells: [Cell(col: 7, row: 0)], cols: [], rows: [0]),
    GameEvent.scoreAdded(
      bonusPoints: 0,
      chips: 80,
      lineScore: 80,
      mult: 1,
      piecePoints: 1,
      total: 81,
    ),
  ];

  Offset centreOf(WidgetTester tester, Cell cell) {
    final board = tester.getRect(find.byType(BoardView));

    return board.topLeft + BoardGeometry(board.width).cellRect(cell).center;
  }

  Offset slot(WidgetTester tester, int index) =>
      tester.getCenter(find.byType(TraySlot).at(index));

  bool placed(FakeGameRules rules) =>
      rules.calls.any((call) => call.startsWith('place'));

  String roundScore(WidgetTester tester) => tester
      .widget<Text>(
        find.descendant(
          of: find.byType(RoundScore),
          matching: find.byType(Text),
        ),
      )
      .textSpan!
      .toPlainText();

  /// Drops tray piece 0 for a move that answers [events] with [after].
  Future<void> playMove(
    WidgetTester tester,
    FakeGameRules rules, {
    RunState? after,
    List<GameEvent> events = clear,
  }) async {
    rules.next = (after ?? runIn(const .playing(), score: 81), events);
    await tester.dragFrom(
      slot(tester, 0),
      centreOf(tester, const Cell(col: 7, row: 0)) + lift - slot(tester, 0),
    );
    await tester.pump();
    rules.calls.clear();
  }

  Future<void> dropOnCentre(WidgetTester tester) async {
    final finger = await tester.startGesture(slot(tester, 1));
    await finger.moveTo(centreOf(tester, const Cell(col: 3, row: 3)) + lift);
    await finger.up();
    await tester.pump();
  }

  testWidgets('while a move plays back, no piece can be grabbed', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    await playMove(tester, rules);

    // When
    await tester.pump(const Duration(milliseconds: 200));
    await dropOnCentre(tester);

    // Then
    expect(placed(rules), isFalse);
  });

  testWidgets('once the move has played out, pieces can be grabbed again', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    await playMove(tester, rules);

    // When
    await tester.pump(const Duration(milliseconds: 1400));
    await dropOnCentre(tester);

    // Then
    expect(rules.calls, ['place 1 (3, 3)']);
  });

  testWidgets('the round score keeps its old value until the points land', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));

    // When
    await playMove(tester, rules);
    await tester.pump(const Duration(milliseconds: 500));

    // Then
    expect(roundScore(tester), '0 / 250');
    await tester.pump(const Duration(seconds: 1));
    expect(roundScore(tester), '81 / 250');
  });

  String runTotal(WidgetTester tester) => tester
      .widget<Text>(
        find.descendant(
          of: find.byType(RunTotalChip),
          matching: find.byType(Text),
        ),
      )
      .data!;

  testWidgets(
    'the run total and the streak hold their old values until the points land',
    (tester) async {
      // Given
      final rules = await pumpGame(tester, runIn(const .playing()));

      // When
      await playMove(
        tester,
        rules,
        after: runIn(const .playing(), score: 81, streak: 3),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Then
      expect(runTotal(tester), 'Run 0');
      expect(
        find.descendant(
          of: find.byType(RoundStatus),
          matching: find.text('Combo ×3'),
        ),
        findsNothing,
      );
      await tester.pump(const Duration(seconds: 2));
      expect(runTotal(tester), 'Run 81');
      expect(
        find.descendant(
          of: find.byType(RoundStatus),
          matching: find.text('Combo ×3'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'past 300 ms, a piece dragged onto the board ends the playback and is '
    'placed',
    (tester) async {
      // Given
      final rules = await pumpGame(tester, runIn(const .playing()));
      await playMove(tester, rules);
      await tester.pump(const Duration(milliseconds: 350));

      // When
      await dropOnCentre(tester);

      // Then
      expect(rules.calls, ['place 1 (3, 3)']);
      expect(roundScore(tester), '81 / 250');
    },
  );

  testWidgets('a piece grabbed just before the playback ends is placed', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    await playMove(tester, rules);
    await tester.pump(const Duration(milliseconds: 1200));

    // When: the finger stays down past the end
    final finger = await tester.startGesture(slot(tester, 1));
    await tester.pump(const Duration(milliseconds: 200));
    await finger.moveTo(centreOf(tester, const Cell(col: 3, row: 3)) + lift);
    await finger.up();
    await tester.pump();

    // Then
    expect(rules.calls, ['place 1 (3, 3)']);
  });

  testWidgets(
    'a second tap right after a skip does not pick from the sheet it reveals',
    (tester) async {
      // Given: a clear that wins the round
      final rules = await pumpGame(tester, runIn(const .playing(), score: 200));
      await playMove(
        tester,
        rules,
        after: runIn(const .pickingJoker(offers: [.twin]), score: 281),
        events: const [
          ...clear,
          GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 281),
          GameEvent.offersPresented(offers: [.twin]),
        ],
      );
      await tester.pump(const Duration(milliseconds: 350));

      // When: two taps 50 ms apart, the second where the offer now is
      await tester.tapAt(centreOf(tester, const Cell(col: 3, row: 3)));
      await tester.pump();
      final offer = tester.getCenter(find.text('Twin Lines'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tapAt(offer);
      await tester.pump();

      // Then
      expect(rules.calls, isNot(contains('pickJoker JokerId.twin')));
      expect(find.text('Round cleared!'), findsOneWidget);

      // And once the sheet is in, the same spot picks the joker
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tapAt(offer);
      await tester.pump();
      expect(rules.calls, contains('pickJoker JokerId.twin'));
    },
  );

  testWidgets('turning reduce motion on mid-playback still lands the move', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    await playMove(tester, rules);
    await tester.pump(const Duration(milliseconds: 200));

    // When
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pump(const Duration(seconds: 2));

    // Then
    expect(tester.takeException(), isNull);
    expect(roundScore(tester), '81 / 250');
    await dropOnCentre(tester);
    expect(rules.calls, ['place 1 (3, 3)']);
  });

  testWidgets('leaving the screen mid-playback leaves nothing running', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    await playMove(tester, rules);
    await tester.pump(const Duration(milliseconds: 100));

    // When
    await tester.pumpWidget(const SizedBox());

    // Then
    expect(tester.takeException(), isNull);
  });

  testWidgets('a resumed run opens with nothing to play back', (tester) async {
    // Given: a run saved mid-round
    final rules = FakeGameRules(start: runIn(const .playing()));
    final store = FakeRunStore()
      ..saved = SavedRun(
        mode: testDay,
        run: runIn(const .playing(), score: 640),
      );

    // When
    await tester.pumpWidget(
      ProviderScope(
        overrides: gameOverrides(rules, runStore: store),
        child: TranslationProvider(
          child: MaterialApp(
            theme: DSTheme.instance.darkTheme,
            home: const GamePage(launch: .resume),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    // Then
    final container = ProviderScope.containerOf(
      tester.element(find.byType(InputGate)),
    );
    expect(container.read(playbackProvider).isPlaying, isFalse);
    expect(roundScore(tester), '640 / 250');
  });

  testWidgets('a tap in the first 300 ms does not skip', (tester) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    await playMove(tester, rules);

    // When
    await tester.tapAt(centreOf(tester, const Cell(col: 3, row: 3)));
    await tester.pump();

    // Then
    expect(roundScore(tester), '0 / 250');
    await dropOnCentre(tester);
    expect(placed(rules), isFalse);
  });

  testWidgets(
    'a tap after 300 ms skips to the end: the score shows, and a piece can be '
    'grabbed',
    (tester) async {
      // Given
      final rules = await pumpGame(tester, runIn(const .playing()));
      await playMove(tester, rules);
      await tester.pump(const Duration(milliseconds: 350));

      // When
      await tester.tapAt(centreOf(tester, const Cell(col: 3, row: 3)));
      await tester.pump();

      // Then
      expect(roundScore(tester), '81 / 250');
      await dropOnCentre(tester);
      expect(rules.calls, ['place 1 (3, 3)']);
    },
  );

  testWidgets('the menu can be reached while a move plays back', (
    tester,
  ) async {
    // Given
    final routing = FakeGameRouting();
    final rules = await pumpGame(
      tester,
      runIn(const .playing()),
      routing: routing,
    );
    await playMove(tester, rules);

    // When
    await tester.tap(find.bySemanticsLabel('Back to the menu'));
    await tester.pump();

    // Then
    expect(routing.calls, ['leave']);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('the joker pick waits for the round’s score to land', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing(), score: 200));

    // When
    await playMove(
      tester,
      rules,
      after: runIn(const .pickingJoker(offers: [.twin]), score: 281),
      events: const [
        ...clear,
        GameEvent.roundWon(bonus: 0, roundIndex: 0, score: 281),
        GameEvent.offersPresented(offers: [.twin]),
      ],
    );
    await tester.pump(const Duration(milliseconds: 1000));

    // Then
    expect(find.text('Round cleared!'), findsNothing);
    await tester.pump(const Duration(milliseconds: 400));
    expect(roundScore(tester), '281 / 250');
    expect(find.text('Round cleared!'), findsOneWidget);
  });

  testWidgets('a third clear in a row pops a combo over the board', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));

    // When: past the burst
    await playMove(tester, rules, after: runIn(const .playing(), streak: 3));
    await tester.pump(const Duration(milliseconds: 450));

    // Then
    expect(
      find.descendant(
        of: find.byType(ComboPop),
        matching: find.text('Combo ×3'),
      ),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('a joker that fired swells in the joker bar', (tester) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .playing(), jokers: const [.combo]),
    );

    // When: into the joker's beat, after the burst, the chips and the mult
    await playMove(
      tester,
      rules,
      after: runIn(const .playing(), jokers: const [.combo], score: 81),
      events: const [
        GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
        ...clear,
      ],
    );
    await tester.pump(const Duration(milliseconds: 820));
    await tester.pump(const Duration(milliseconds: 60));

    // Then
    final scale = tester
        .widget<Transform>(
          find
              .descendant(
                of: find.byType(JokerChip),
                matching: find.byType(Transform),
              )
              .first,
        )
        .transform
        .getMaxScaleOnAxis();
    expect(scale, greaterThan(1));
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('the board itself is not repainted while a clear bursts', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(tester, runIn(const .playing()));
    final boundaries = find.descendant(
      of: find.byType(BoardView),
      matching: find.byType(RepaintBoundary),
    );
    int paints(int index) {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        boundaries.at(index),
      );

      return boundary.debugSymmetricPaintCount +
          boundary.debugAsymmetricPaintCount;
    }

    await playMove(tester, rules);
    final board = paints(0);
    final effects = paints(1);

    // When: through the burst
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 30));
    }

    // Then
    expect(paints(0), board);
    expect(paints(1), greaterThan(effects));
    await tester.pump(const Duration(seconds: 2));
  });

  for (final (name, disableAnimations, reduceMotion) in const [
    ('the phone’s reduce motion', true, false),
    ('the app’s reduce motion setting', false, true),
  ]) {
    testWidgets('with $name on, nothing bursts and the score still lands', (
      tester,
    ) async {
      // Given
      final rules = await pumpGame(
        tester,
        runIn(const .playing()),
        disableAnimations: disableAnimations,
        reduceMotion: reduceMotion,
      );

      // When
      await playMove(tester, rules);
      final drawn = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((paint) => paint.painter)
          .whereType<BoardEffectsPainter>()
          .single;

      // Then
      expect(drawn.beat, isNull);
      await tester.pump(const Duration(milliseconds: 500));
      expect(roundScore(tester), '81 / 250');
    });
  }
}
