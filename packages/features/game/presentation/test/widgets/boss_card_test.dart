import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../pump_game.dart';

void main() {
  testWidgets(
    "Given a world run's first boss, When the pick starts it, Then its card "
    'explains the rule until the player puts it away',
    (tester) async {
      // Given
      final config = testConfig.copyWith(world: .fog);
      final rules = await pumpGame(
        tester,
        runIn(const .pickingJoker(offers: [.twin])).copyWith(config: config),
        launch: .world,
        world: .fog,
      );
      rules.next = (
        runIn(const .playing(), roundIndex: 1).copyWith(config: config),
        const [GameEvent.roundStarted(pieces: 22, roundIndex: 1, target: 2000)],
      );

      // When
      await tester.tap(find.text('Take').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Then
      expect(find.text('The Fog boss'), findsOneWidget);
      expect(
        find.text(
          "Fog hides the board. Fill next to it to see what's underneath.",
        ),
        findsOneWidget,
      );

      // When
      await tester.tap(find.text('Got it'));
      await tester.pump();

      // Then
      expect(find.text('The Fog boss'), findsNothing);
    },
  );

  testWidgets(
    "Given a world's sheet, When its boss card is replayed, Then it shows over "
    'the screen and closes',
    (tester) async {
      // Given
      await tester.pumpWidget(
        ProviderScope(
          overrides: [reduceMotionSettingProvider.overrideWithValue(true)],
          child: TranslationProvider(
            child: MaterialApp(
              theme: DSTheme.instance.darkTheme,
              home: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showBossCard(context, world: .mirror),
                  child: const Text('replay'),
                ),
              ),
            ),
          ),
        ),
      );

      // When
      await tester.tap(find.text('replay'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Everything you place lands mirrored.'), findsOneWidget);

      // When
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Everything you place lands mirrored.'), findsNothing);
    },
  );
}
