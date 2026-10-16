import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/score_banner.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';

void main() {
  /// Mounts the banner alone and plays one placement that answers [events].
  Future<void> playMove(WidgetTester tester, List<GameEvent> events) async {
    final rules = FakeGameRules(start: runIn(const .playing()))
      ..next = (runIn(const .playing()), events);

    await tester.pumpWidget(
      ProviderScope(
        overrides: bindProviders(gameRules: (ref) => rules),
        child: TranslationProvider(
          child: MaterialApp(
            theme: DSTheme.instance.darkTheme,
            home: const Scaffold(body: ScoreBanner()),
          ),
        ),
      ),
    );

    ProviderScope.containerOf(tester.element(find.byType(ScoreBanner)))
        .read(gameProvider.notifier)
        .place(anchor: const Cell(col: 0, row: 0), trayIndex: 0);
    await tester.pump();
  }

  double opacity(WidgetTester tester) =>
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;

  testWidgets('a clear names the jokers that fired and chips × mult = total', (
    tester,
  ) async {
    // Given / When
    await playMove(tester, const [
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
    ]);

    // Then
    expect(find.text('150 chips × 9 mult = 1350'), findsOneWidget);
    expect(
      find.text('Combo King +1 mult · Twin Lines ×3 mult'),
      findsOneWidget,
    );
    expect(opacity(tester), 1);
  });

  testWidgets('a flat bonus is shown beside the line score', (tester) async {
    // Given / When
    await playMove(tester, const [
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

    // Then
    expect(find.text('80 chips × 1 mult = 80 · +500 bonus'), findsOneWidget);
    expect(find.text('Clean Sweep +500'), findsOneWidget);
  });

  testWidgets('a quiet move shows its points and what Patience stored', (
    tester,
  ) async {
    // Given / When
    await playMove(tester, const [
      GameEvent.jokerFired(delta: .multStored(total: 4), joker: .patience),
      GameEvent.scoreAdded(
        bonusPoints: 0,
        chips: 0,
        lineScore: 0,
        mult: 0,
        piecePoints: 3,
        total: 3,
      ),
    ]);

    // Then
    expect(find.text('+3'), findsOneWidget);
    expect(find.text('Patience mult stored · 4 ready'), findsOneWidget);
  });

  testWidgets('fades a moment after the move', (tester) async {
    // Given
    await playMove(tester, const [
      GameEvent.scoreAdded(
        bonusPoints: 0,
        chips: 0,
        lineScore: 0,
        mult: 0,
        piecePoints: 1,
        total: 1,
      ),
    ]);

    // When
    await tester.pump(const Duration(seconds: 3));

    // Then
    expect(opacity(tester), 0);
  });
}
