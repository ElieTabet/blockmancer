import 'package:app_router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart' show HomeRoute;
import 'package:splash_presentation/splash_presentation.dart' show SplashRoute;

import 'pump_app_router.dart';
import 'stub_deep_route.dart';

String? activeTab(AppRouter router) =>
    router.innerRouterOf<TabsRouter>(TabShellRoute.name)?.current.name;

// The real router, like the app status's: what is under test is where a tapped
// push lands in the stack, and when.
void main() {
  // Back from whatever the push opens must lead to its tab, not to wherever
  // the member happened to be.
  testWidgets('home dismisses whatever was open over the shell', (
    tester,
  ) async {
    final router = await pumpAppRouter(
      tester,
      deepLink: [const TabShellRoute(), const DeepRoute()],
    );

    PushNotificationsRoutingImpl(router).onHomeOpened();
    await tester.pumpAndSettle();

    expect(rootStackNames(router), [TabShellRoute.name]);
    expect(activeTab(router), HomeRoute.name);
  });

  // A cold start from a tap: the push arrives while the splash is still up,
  // and the splash's hand-off replaces the whole stack.
  testWidgets('waits for the splash to hand off', (tester) async {
    final router = await pumpAppRouter(tester, deepLink: [const SplashRoute()]);

    PushNotificationsRoutingImpl(router).onHomeOpened();
    await tester.pump();

    expect(rootStackNames(router), [SplashRoute.name]);

    await router.replaceAll([const TabShellRoute(), const DeepRoute()]);
    await tester.pumpAndSettle();

    expect(rootStackNames(router), [TabShellRoute.name]);

    // The splash's own minimum, left running when it was replaced.
    await tester.pump(const Duration(seconds: 2));
  });
}
