import 'package:flutter/widgets.dart';

/// Navigation intents the splash screen can trigger, implemented in the
/// composition layer (app_router). The split exists because the whole point of
/// the cold-start check is choosing between them: a signed-in member reopening
/// the app should never see the login screen.
abstract interface class SplashRouting {
  void onSessionMissing(BuildContext context);

  void onSessionValid(BuildContext context);
}
