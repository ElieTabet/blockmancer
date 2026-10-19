/// Where a version too old to play goes once the app is open, implemented in
/// the composition layer (app_router).
///
/// No `BuildContext`: what triggers it is a value published remotely, not a
/// widget, and it lands wherever the player is.
abstract interface class AppUpdateRouting {
  /// The update screen in place of everything, with no way back.
  void onUpdateRequired();
}
