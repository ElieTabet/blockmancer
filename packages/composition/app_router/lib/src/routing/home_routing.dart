import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:home_presentation/home_presentation.dart' show HomeRouting;
import 'package:settings_presentation/settings_presentation.dart'
    show SettingsRoute;

/// Home's choices each push a screen over the shell: a run, or Settings.
final class HomeRoutingImpl implements HomeRouting {
  const HomeRoutingImpl();

  @override
  void onContinueRequested(BuildContext context) =>
      AutoRouter.of(context).push(GameRoute(launch: .resume));

  @override
  void onDailyRequested(BuildContext context) =>
      AutoRouter.of(context).push(GameRoute(launch: .daily));

  @override
  void onPracticeRequested(BuildContext context) =>
      AutoRouter.of(context).push(GameRoute(launch: .practice));

  @override
  void onSettingsRequested(BuildContext context) =>
      AutoRouter.of(context).push(const SettingsRoute());
}
