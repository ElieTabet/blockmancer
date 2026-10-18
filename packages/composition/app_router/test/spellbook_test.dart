import 'package:app_router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart' show SpellbookRoute;
import 'package:shared_domain/shared_domain.dart';

import 'pump_app_router.dart';
import 'stub_features.dart';

// The real route tree: the Spellbook opens over the shell from Home's header,
// and closing it lands back on Home.
void main() {
  testWidgets(
    "Home's book opens the Spellbook over the shell, and closing it returns "
    'Home',
    (tester) async {
      // Given
      final router = await pumpAppRouter(
        tester,
        deepLink: [const TabShellRoute()],
      );

      // When
      await tester.tap(find.bySemanticsLabel('Spellbook'));
      await tester.pumpAndSettle();

      // Then
      expect(rootStackNames(router), [TabShellRoute.name, SpellbookRoute.name]);
      expect(
        find.text('12 / ${JokerId.values.length} collected'),
        findsOneWidget,
      );

      // When
      await tester.tap(find.bySemanticsLabel('Close'));
      await tester.pumpAndSettle();

      // Then
      expect(rootStackNames(router), [TabShellRoute.name]);
      expect(find.text(homeDailyTitle), findsOneWidget);
    },
  );
}
