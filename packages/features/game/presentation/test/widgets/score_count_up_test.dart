import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/score_count_up.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';

void main() {
  const oneLine = GameEvent.linesCleared(cells: [], cols: [], rows: [0]);

  /// Mounts the count-up alone and plays one placement that answers [events].
  Future<void> playMove(WidgetTester tester, List<GameEvent> events) async {
    final rules = FakeGameRules(start: runIn(const .playing()))
      ..next = (runIn(const .playing()), events);

    await tester.pumpWidget(
      ProviderScope(
        overrides: gameOverrides(rules),
        child: TranslationProvider(
          child: MaterialApp(
            theme: DSTheme.instance.darkTheme,
            home: const Scaffold(body: ScoreCountUp()),
          ),
        ),
      ),
    );

    ProviderScope.containerOf(tester.element(find.byType(ScoreCountUp)))
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
    await tester.pump();
  }

  // The test's clear plays the burst for 350 ms, the chips until 600, the
  // mult until 800, each joker for 180 and the product for 250.
  const jokersClear = [
    oneLine,
    GameEvent.jokerFired(delta: .multAdded(amount: 1), joker: .combo),
    GameEvent.jokerFired(delta: .multMultiplied(factor: 3), joker: .twin),
    GameEvent.scoreAdded(
      bonusPoints: 0,
      chips: 150,
      lineScore: 1350,
      mult: 9,
      piecePoints: 1,
      total: 1351,
    ),
  ];

  testWidgets('the chips count up before the mult appears', (tester) async {
    // Given
    await playMove(tester, jokersClear);

    // When: part way through the chips
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 75));

    // Then
    expect(find.text('45 chips'), findsOneWidget);
    expect(find.textContaining('mult'), findsNothing);
  });

  testWidgets('then the mult, and each joker that fired, in order', (
    tester,
  ) async {
    // Given
    await playMove(tester, jokersClear);

    // When: into the second joker
    await tester.pump(const Duration(milliseconds: 1050));

    // Then
    expect(find.text('150 chips'), findsOneWidget);
    expect(find.text('× 9 mult'), findsOneWidget);
    expect(find.textContaining('='), findsNothing);
    expect(
      find.text('Combo King +1 mult · Twin Lines ×3 mult'),
      findsOneWidget,
    );
  });

  testWidgets('then chips × mult appears', (tester) async {
    // Given
    await playMove(tester, jokersClear);

    // When: the product is in
    await tester.pump(const Duration(milliseconds: 1400));

    // Then
    expect(find.text('150 chips'), findsOneWidget);
    expect(find.text('× 9 mult'), findsOneWidget);
    expect(find.text('= 1,350'), findsOneWidget);
  });

  testWidgets('a flat bonus is shown beside the line score', (tester) async {
    // Given
    await playMove(tester, const [
      oneLine,
      GameEvent.jokerFired(delta: .pointsAdded(amount: 500), joker: .sweep),
      GameEvent.scoreAdded(
        bonusPoints: 500,
        chips: 80,
        lineScore: 80,
        mult: 1,
        piecePoints: 1,
        total: 581,
      ),
    ]);

    // When: the product is in
    await tester.pump(const Duration(milliseconds: 1200));

    // Then
    expect(find.text('= 80'), findsOneWidget);
    expect(find.text('+500 bonus'), findsOneWidget);
    expect(find.text('Clean Sweep +500'), findsOneWidget);
  });

  testWidgets(
    'a move that clears nothing shows its points and what Patience stored, '
    'for a moment',
    (tester) async {
      // Given
      await playMove(tester, const [
        GameEvent.scoreAdded(
          bonusPoints: 0,
          chips: 0,
          lineScore: 0,
          mult: 0,
          piecePoints: 3,
          total: 3,
        ),
        GameEvent.jokerFired(delta: .multStored(total: 4), joker: .patience),
      ]);

      // When
      await tester.pump(const Duration(milliseconds: 200));

      // Then
      expect(find.text('+3'), findsOneWidget);
      expect(find.text('Patience mult stored · 4 ready'), findsOneWidget);
      expect(find.textContaining('chips'), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.byType(Text), findsNothing);
    },
  );

  testWidgets('the score is gone once it has landed', (tester) async {
    // Given
    await playMove(tester, jokersClear);

    // When
    await tester.pump(const Duration(seconds: 2));

    // Then
    expect(find.byType(Text), findsNothing);
  });
}
