import 'package:app_router/src/app_router.dart' show TabShellRoute;
import 'package:app_update_presentation/app_update_presentation.dart'
    show UpdateRequiredRoute;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:splash_presentation/splash_presentation.dart'
    show SplashRouting;

/// Binds the splash screen's hand-off to the app route tree.
final class SplashRoutingImpl implements SplashRouting {
  const SplashRoutingImpl();

  /// Over the shell, so leaving the tutorial lands on Home.
  @override
  void onFirstLaunch(BuildContext context) {
    assert(context.mounted, 'onFirstLaunch called with an unmounted context');
    AutoRouter.of(
      context,
    ).replaceAll([const TabShellRoute(), GameRoute(launch: .tutorial)]);
  }

  @override
  void onInitialized(BuildContext context) {
    assert(context.mounted, 'onInitialized called with an unmounted context');
    AutoRouter.of(context).replaceAll([const TabShellRoute()]);
  }

  /// Everything replaced, so back has nowhere to go.
  @override
  void onUpdateRequired(BuildContext context) {
    assert(
      context.mounted,
      'onUpdateRequired called with an unmounted context',
    );
    AutoRouter.of(context).replaceAll([const UpdateRequiredRoute()]);
  }
}
