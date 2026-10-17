import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:game_presentation/game_presentation.dart' show GameRouting;

final class GameRoutingImpl implements GameRouting {
  const GameRoutingImpl();

  @override
  void onLeaveRequested(BuildContext context) =>
      AutoRouter.of(context).maybePop();
}
