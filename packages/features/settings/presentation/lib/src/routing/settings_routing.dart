import 'package:flutter/widgets.dart';

/// Where Settings leads, implemented in the composition layer (app_router).
abstract interface class SettingsRouting {
  void onBackRequested(BuildContext context);
}
