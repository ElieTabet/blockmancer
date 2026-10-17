import 'package:app_router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_presentation/settings_presentation.dart'
    show SettingsRoute;

import 'pump_app_router.dart';
import 'stub_features.dart';

// The real route tree: what is under test is that Settings opens over the
// shell, and that closing it lands on the tab it was opened from.
void main() {
  testWidgets(
    'the gear opens Settings over the shell, and closing it returns Home',
    (tester) async {
      // Given
      final router = await pumpAppRouter(
        tester,
        deepLink: [const TabShellRoute()],
      );

      // When
      await tester.tap(find.bySemanticsLabel(homeSettingsLabel));
      await tester.pumpAndSettle();

      // Then
      expect(rootStackNames(router), [TabShellRoute.name, SettingsRoute.name]);
      expect(find.text('Reset progress'), findsOneWidget);

      // When
      await tester.tap(find.bySemanticsLabel(settingsCloseLabel));
      await tester.pumpAndSettle();

      // Then
      expect(rootStackNames(router), [TabShellRoute.name]);
      expect(find.text(homeDailyTitle), findsOneWidget);
    },
  );
}
