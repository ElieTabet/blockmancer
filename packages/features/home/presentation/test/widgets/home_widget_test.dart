import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:result/result.dart';
import 'package:screen_header/screen_header.dart' as screen_header;

final class _NoRouting implements screen_header.ScreenHeaderRouting {
  @override
  void onSignInRequested(BuildContext context) {}
}

void main() {
  late int asks;

  setUp(() => asks = 0);

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...bindProviders(
            askForNotifications: (ref) =>
                () async => asks++,
          ),
          ...screen_header.bindProviders(
            isAuthenticated: (ref) async => false,
            logout: (ref) =>
                () async => const Success(unit),
            organizationName: (ref) => 'Acme Club',
          ),
          ...screen_header.bindRoutingProviders(
            screenHeaderRouting: (ref) => _NoRouting(),
          ),
        ],
        child: TranslationProvider(
          child: MaterialApp(
            theme: DSTheme.instance.lightTheme,
            home: const HomeWidget(),
          ),
        ),
      ),
    );
  }

  testWidgets('wears the shared header, naming the organization', (
    tester,
  ) async {
    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Acme Club'), findsOneWidget);
  });

  // Asked from the first frame's post-frame callback, so the OS prompt lands
  // over a drawn screen — and never again as the screen rebuilds.
  testWidgets('asks for notifications once it is drawn, and only once', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(asks, 1);

    await tester.pumpAndSettle();

    expect(asks, 1);
  });
}
