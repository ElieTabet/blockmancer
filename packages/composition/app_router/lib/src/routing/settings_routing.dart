import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_presentation/settings_presentation.dart'
    show SettingsRouting;

final class SettingsRoutingImpl implements SettingsRouting {
  const SettingsRoutingImpl();

  @override
  void onCloseRequested(BuildContext context) =>
      AutoRouter.of(context).maybePop();
}
