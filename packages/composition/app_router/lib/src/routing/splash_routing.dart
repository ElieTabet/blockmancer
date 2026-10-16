import 'package:app_router/src/app_router.dart' show TabShellRoute;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:splash_presentation/splash_presentation.dart'
    show SplashRouting;

/// Binds the splash screen's navigation intents to the app route tree.
final class SplashRoutingImpl implements SplashRouting {
  const SplashRoutingImpl();

  // A live session goes straight to the shelf; only a missing one sees login.
  @override
  void onSessionValid(BuildContext context) {
    assert(context.mounted, 'onSessionValid called with an unmounted context');
    AutoRouter.of(context).replaceAll([const TabShellRoute()]);
  }

  @override
  void onSessionMissing(BuildContext context) {
    assert(
      context.mounted,
      'onSessionMissing called with an unmounted context',
    );
    // No login screen: everyone uses the app as a guest.
    AutoRouter.of(context).replaceAll([const TabShellRoute()]);
  }
}
