import 'package:app_router/src/app_router.dart' show AppRouter;
import 'package:app_router/src/routing/once_settled.dart';
import 'package:app_update_presentation/app_update_presentation.dart'
    show AppUpdateRouting, UpdateRequiredRoute;
import 'package:splash_presentation/splash_presentation.dart' show SplashRoute;

/// Where a version too old to play goes once the app is open: the update
/// screen in place of everything, so back has nowhere to go.
///
/// Navigates through the [AppRouter] instance rather than a `BuildContext`,
/// like `PushNotificationsRoutingImpl`: what triggers it is a value published
/// remotely, wherever the player is. The splash decides for itself, so it is
/// waited out, and a screen the splash already put up is left as it is.
final class AppUpdateRoutingImpl implements AppUpdateRouting {
  final AppRouter _router;

  static final _waitsOut = {SplashRoute.name};

  const AppUpdateRoutingImpl(this._router);

  @override
  void onUpdateRequired() {
    final root = _router.root;

    onceSettled(
      root,
      open: (top) => top == UpdateRequiredRoute.name
          ? null
          : root.replaceAll([const UpdateRequiredRoute()]),
      waitsOut: _waitsOut,
    );
  }
}
