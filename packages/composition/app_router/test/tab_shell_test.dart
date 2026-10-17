import 'package:app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart' show GameRoute;

import 'pump_app_router.dart';
import 'stub_features.dart';

// Drives the real route tree rather than the shell widget alone: the thing worth
// pinning is that `/main` resolves to a tab whose initial child is Home, and
// that a run opens over the shell, which is route-table wiring, not layout.
void main() {
  testWidgets('the shell opens on Home', (tester) async {
    await pumpAppRouter(tester, deepLink: [const TabShellRoute()]);

    expect(find.text(homeDailyTitle), findsOneWidget);
  });

  // NavigationBar asserts `destinations.length >= 2`, so with one tab the
  // shell draws none. A second tab is what brings the bar.
  testWidgets('draws no bar with a single tab', (tester) async {
    await pumpAppRouter(tester, deepLink: [const TabShellRoute()]);

    expect(find.byType(NavigationBar), findsNothing);
  });

  for (final card in const ['Daily run', 'Practice']) {
    testWidgets('$card opens a run over the shell, and back returns Home', (
      tester,
    ) async {
      // Given
      final router = await pumpAppRouter(
        tester,
        deepLink: [const TabShellRoute()],
      );

      // When
      await tester.tap(find.text(card));
      await tester.pumpAndSettle();

      // Then
      expect(rootStackNames(router), [TabShellRoute.name, GameRoute.name]);
      expect(find.text('Pick your starting joker'), findsOneWidget);

      // When
      await tester.tap(find.byTooltip(gameLeaveTooltip));
      await tester.pumpAndSettle();

      // Then
      expect(rootStackNames(router), [TabShellRoute.name]);
      expect(find.text(homeDailyTitle), findsOneWidget);
    });
  }
}
