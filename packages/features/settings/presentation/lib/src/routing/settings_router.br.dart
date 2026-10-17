import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_presentation/src/widgets/settings_widget.dart';

part 'settings_router.br.gr.dart';

/// Path for the settings feature's route.
///
/// Absolute: Settings is pushed over the shell, like a run, not a tab child.
enum SettingsRoutePath {
  settings('/settings');

  const SettingsRoutePath(this.path);

  final String path;
}

// Empty codegen anchor — auto_route generates the route from the @RoutePage
// class below. The actual route table is declared once by AppRouter
// (composition), never per feature.
@AutoRouterConfig()
abstract class SettingsRouter extends RootStackRouter {}

@RoutePage(name: 'SettingsRoute')
final class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => const SettingsWidget();
}
