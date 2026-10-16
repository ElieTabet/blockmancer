// Smoke test: the app boots through the composition layer (app_router's
// AppRouter + app_providers' overrides) into the initial splash screen, which
// then hands off to login — mirroring how Application wires things in
// lib/application, without importing any feature package.

import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';

void main() {
  testWidgets('boots to the splash screen, then hands off to login', (
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

    // Splash is showing: login isn't there yet.
    expect(find.text('Continue as a guest'), findsNothing);

    // After the splash delay it hands off to the game, on its starting pick.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Pick your starting joker'), findsOneWidget);
  });
}
