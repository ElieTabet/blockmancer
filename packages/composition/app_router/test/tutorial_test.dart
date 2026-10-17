import 'package:app_router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:splash_presentation/splash_presentation.dart' show SplashRoute;

import 'pump_app_router.dart';
import 'stub_features.dart';

// The real route tree and the real engine: what is under test is where the
// tutorial opens in the stack, and where leaving it lands.
void main() {
  Future<AppRouter> launch(
    WidgetTester tester, {
    required bool tutorialSeen,
  }) async {
    final router = await pumpAppRouter(
      tester,
      deepLink: [const SplashRoute()],
      tutorialSeen: tutorialSeen,
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    return router;
  }

  testWidgets('a fresh install lands in the tutorial, and back returns Home', (
    tester,
  ) async {
    // Given / When
    final router = await launch(tester, tutorialSeen: false);

    // Then
    expect(rootStackNames(router), [TabShellRoute.name, GameRoute.name]);
    expect(find.text(tutorialFirstLine), findsOneWidget);

    // When
    await tester.tap(find.bySemanticsLabel(gameLeaveLabel));
    await tester.pumpAndSettle();

    // Then
    expect(rootStackNames(router), [TabShellRoute.name]);
    expect(find.text(homeDailyTitle), findsOneWidget);
  });

  testWidgets('a second launch goes Home, with no tutorial', (tester) async {
    // Given / When
    final router = await launch(tester, tutorialSeen: true);

    // Then
    expect(rootStackNames(router), [TabShellRoute.name]);
    expect(find.text(tutorialFirstLine), findsNothing);
  });
}
