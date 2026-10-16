/// Where a tapped push takes the app, implemented in the composition layer
/// (app_router).
///
/// No `BuildContext`: what triggers it is the OS handing over a tap, not a
/// widget — and at a cold start there is no screen yet to borrow one from.
abstract interface class PushNotificationsRouting {
  void onHomeOpened();
}
