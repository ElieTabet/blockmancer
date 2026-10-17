import 'package:flutter/widgets.dart';

/// Where Home's choices lead, implemented in the composition layer
/// (app_router).
abstract interface class HomeRouting {
  void onDailyRequested(BuildContext context);

  void onPracticeRequested(BuildContext context);
}
