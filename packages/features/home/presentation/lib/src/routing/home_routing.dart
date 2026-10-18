import 'package:flutter/widgets.dart';
import 'package:shared_domain/shared_domain.dart';

/// Where Home's choices lead, implemented in the composition layer
/// (app_router).
abstract interface class HomeRouting {
  /// Replays [world]'s boss card over the screen.
  void onBossCardRequested(BuildContext context, WorldId world);

  void onContinueRequested(BuildContext context);

  void onDailyRequested(BuildContext context);

  void onPracticeRequested(BuildContext context);

  void onSettingsRequested(BuildContext context);

  void onSpellbookCloseRequested(BuildContext context);

  void onSpellbookRequested(BuildContext context);

  void onWorldRequested(BuildContext context, WorldId world);
}
