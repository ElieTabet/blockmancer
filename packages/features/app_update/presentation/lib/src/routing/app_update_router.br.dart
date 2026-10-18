import 'package:app_update_presentation/src/widgets/update_required_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

part 'app_update_router.br.gr.dart';

/// Path segments for the app_update feature's routes.
enum AppUpdateRoutePath {
  updateRequired('/update-required');

  const AppUpdateRoutePath(this.path);

  final String path;
}

// Empty codegen anchor — auto_route generates `UpdateRequiredRoute` from the
// @RoutePage below. The route table is declared once by AppRouter.
@AutoRouterConfig()
abstract class AppUpdateRouter extends RootStackRouter {}

@RoutePage(name: 'UpdateRequiredRoute')
final class UpdateRequiredPage extends StatelessWidget {
  const UpdateRequiredPage({super.key});

  @override
  Widget build(BuildContext context) => const UpdateRequiredWidget();
}
