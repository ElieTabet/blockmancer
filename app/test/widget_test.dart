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
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications;

void main() {
  testWidgets('boots to the splash screen, then hands off to login', (
    WidgetTester tester,
  ) async {
    final appRouter = AppRouter();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appOverrides(
            androidPackageName: 'com.elietabet.blockmancer',
            apiBaseUrl: 'http://localhost:8888/api/mobile/v1',
            appVersion: '1.0.0',
            collectsTelemetry: false,
            router: appRouter,
          ),
          // With no login screen the splash hands off to Home, which asks for
          // notifications — a platform channel the test has no answer for.
          push_notifications.askForNotificationsProvider.overrideWithValue(
            () async {},
          ),
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

    // After the splash delay it replaces the stack with login.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.textContaining('Your app starts here'), findsOneWidget);
  });
}
