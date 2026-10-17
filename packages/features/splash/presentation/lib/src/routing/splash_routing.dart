import 'package:flutter/widgets.dart';

/// Where the splash hands off to, implemented in the composition layer
/// (app_router).
abstract interface class SplashRouting {
  /// The player has never been through the tutorial: it opens over Home.
  void onFirstLaunch(BuildContext context);

  void onInitialized(BuildContext context);
}
