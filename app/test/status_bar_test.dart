// The status bar over a screen that has no app bar.
//
// Splash and login are both bare Scaffolds, so nothing in them annotates the
// strip the clock and battery sit in. Application wraps the whole app in one
// AnnotatedRegion to cover exactly that; this pumps the same wrapper — the way
// widget_test.dart mirrors Application's wiring — and asserts what the platform
// is actually told, rather than that the widget is present.

import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';

void main() {
  testWidgets('Given a screen with no app bar '
      'When it is on screen '
      'Then the status bar over it is drawn light', (tester) async {
    final appRouter = AppRouter();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appOverrides(collectsTelemetry: false, router: appRouter),
        ],
        child: TranslationProvider(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: DSTheme.instance.lightTheme,
              darkTheme: DSTheme.instance.darkTheme,
              routerConfig: appRouter.config(),
            ),
          ),
        ),
      ),
    );

    // Splash first, then the hand-off to the tutorial, as on a fresh install.
    // Neither has an app bar.
    await tester.pump();
    expect(SystemChrome.latestStyle, SystemUiOverlayStyle.light);

    // The stored settings the splash waits for come over a platform channel
    // that the tester's clock doesn't move.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    // The tutorial opens once the progression has come over the same channel.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Drag a piece onto the board'), findsOneWidget);
    expect(SystemChrome.latestStyle, SystemUiOverlayStyle.light);
  });
}
