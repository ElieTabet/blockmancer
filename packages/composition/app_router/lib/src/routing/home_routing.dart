import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:home_presentation/home_presentation.dart' show HomeRouting;

/// Home's choices each push a run over the shell.
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
}
