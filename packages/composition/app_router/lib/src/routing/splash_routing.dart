import 'package:app_router/src/app_router.dart' show TabShellRoute;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:splash_presentation/splash_presentation.dart'
    show SplashRouting;

/// Binds the splash screen's hand-off to the app route tree.
final class SplashRoutingImpl implements SplashRouting {
  const SplashRoutingImpl();

  @override
  void onInitialized(BuildContext context) {
    assert(context.mounted, 'onInitialized called with an unmounted context');
    AutoRouter.of(context).replaceAll([const TabShellRoute()]);
  }
}
