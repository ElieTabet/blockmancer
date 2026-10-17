// Smoke test: the app boots through the composition layer (app_router's
// AppRouter + app_providers' overrides) into the initial splash screen, which
// then hands off — mirroring how Application wires things in lib/application,
// without importing any feature package. Nothing is stored in a test, so this
// is a fresh install, and the hand-off is to the tutorial.

import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';

void main() {
  testWidgets('a fresh install boots to the splash, then to the tutorial', (
    WidgetTester tester,
  ) async {
    final appRouter = AppRouter();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appOverrides(collectsTelemetry: false, router: appRouter),
        ],
        child: TranslationProvider(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.config(),
          ),
        ),
      ),
    );
    await tester.pump(); // first frame — splash schedules its hand-off

    // Splash is showing: the tutorial isn't there yet.
    expect(find.text('Drag a piece onto the board'), findsNothing);

    // The splash waits for the stored settings, which come over a platform
    // channel that the tester's clock doesn't move: a real moment lets them in.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );

    // After the splash delay it hands off to the tutorial, which opens once
    // the progression has come over the same channel.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Drag a piece onto the board'), findsOneWidget);
  });
}
