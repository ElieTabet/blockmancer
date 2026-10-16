import 'package:flutter/widgets.dart';

/// Where the header's session control can send someone, implemented in the
/// composition layer (app_router).
///
/// Signing *out* is deliberately absent. A session ending already has one
/// policy, wherever it ended, and routing it a second time from here would
/// replace the stack twice.
abstract interface class ScreenHeaderRouting {
  void onSignInRequested(BuildContext context);
}
