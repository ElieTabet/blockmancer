import 'package:app_router/src/app_router.dart' show AppRouter, TabShellRoute;
import 'package:app_router/src/routing/once_settled.dart';
import 'package:app_update_presentation/app_update_presentation.dart'
    show UpdateRequiredRoute;
import 'package:auto_route/auto_route.dart';
import 'package:home_presentation/home_presentation.dart' show HomeRoute;
import 'package:push_notifications_presentation/push_notifications_presentation.dart'
    show PushNotificationsRouting;
import 'package:splash_presentation/splash_presentation.dart' show SplashRoute;

/// Where a tapped push takes the app.
///
/// Navigates through the [AppRouter] instance rather than a `BuildContext`,
/// like `AppUpdateRoutingImpl`: the trigger is the OS handing over a tap, and
/// at a cold start there is no screen yet to borrow a context from.
///
/// Each push lands on a clean stack: whatever was open is dismissed and the
/// shell is brought to the tab the push belongs to. A push about one item
/// should push its page over that tab, so back leads to the tab rather than to
/// wherever the member happened to be.
///
/// What the push is about is opened over the shell, never under the splash —
/// whose hand-off replaces the whole stack and would sweep it away — nor over a
/// blocking screen or login, which have a question to settle first. It waits
/// those out and opens once they are gone. The update screen is never gone,
/// so a tap that finds it is dropped.
final class PushNotificationsRoutingImpl implements PushNotificationsRouting {
  final void Function() _revealDailyCard;
  final AppRouter _router;

  static final _waitsOut = {SplashRoute.name};

  /// [revealDailyCard] scrolls Home back to the daily run's card.
  const PushNotificationsRoutingImpl(
    this._router, {
    required void Function() revealDailyCard,
  }) : _revealDailyCard = revealDailyCard;

  @override
  void onDailyRunOpened() => _openOnceSettled((root) async {
    await _home(root);
    _revealDailyCard();
  });

  @override
  void onHomeOpened() => _openOnceSettled(_home);

  Future<void> _home(StackRouter root) =>
      root.navigate(const TabShellRoute(children: [HomeRoute()]));

  void _openOnceSettled(Future<void> Function(StackRouter root) open) {
    final root = _router.root;

    onceSettled(
      root,
      // A tap while the update screen is up is dropped: it has no way out.
      open: (top) => top == UpdateRequiredRoute.name ? null : open(root),
      waitsOut: _waitsOut,
    );
  }
}
