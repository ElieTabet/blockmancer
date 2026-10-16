import 'package:flutter/widgets.dart';

/// Where the splash hands off to, implemented in the composition layer
/// (app_router).
abstract interface class SplashRouting {
  void onInitialized(BuildContext context);
}
