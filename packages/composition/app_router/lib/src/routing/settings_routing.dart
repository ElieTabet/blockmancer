import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:settings_presentation/settings_presentation.dart'
    show SettingsRouting;

final class SettingsRoutingImpl implements SettingsRouting {
  const SettingsRoutingImpl();

  @override
  void onCloseRequested(BuildContext context) =>
      AutoRouter.of(context).maybePop();

  /// Settings closes first, so leaving the tutorial lands where Settings was
  /// opened from.
  @override
  void onReplayTutorialRequested(BuildContext context) =>
      AutoRouter.of(context).popAndPush(GameRoute(launch: .tutorial));
}
