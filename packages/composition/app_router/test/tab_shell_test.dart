import 'package:app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pump_app_router.dart';
import 'stub_game.dart';

// Drives the real route tree rather than the shell widget alone: the thing worth
// pinning is that `/main` resolves to a tab whose initial child is the game, which
// is route-table wiring, not layout.
void main() {
  testWidgets('the shell opens on the game tab', (tester) async {
    await pumpAppRouter(tester, deepLink: [const TabShellRoute()]);

    expect(find.text(gameTitle), findsOneWidget);
  });

  // NavigationBar asserts `destinations.length >= 2`, so with one tab the
  // shell draws none. A second tab is what brings the bar.
  testWidgets('draws no bar with a single tab', (tester) async {
    await pumpAppRouter(tester, deepLink: [const TabShellRoute()]);

    expect(find.byType(NavigationBar), findsNothing);
  });
}
