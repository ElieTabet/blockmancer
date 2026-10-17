import 'package:flutter/widgets.dart';

/// Where the game screen leads, implemented in the composition layer
/// (app_router).
abstract interface class GameRouting {
  void onLeaveRequested(BuildContext context);
}
