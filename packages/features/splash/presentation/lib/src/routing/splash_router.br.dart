import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:splash_presentation/src/widgets/splash_widget.dart';

part 'splash_router.br.gr.dart';

/// Path segments for the splash feature's routes. Splash is the app entry.
enum SplashRoutePath {
  splash('/splash');

  const SplashRoutePath(this.path);

  final String path;
}

// Empty codegen anchor — auto_route generates `SplashRoute` from the @RoutePage
// below. The actual route table is declared once by AppRouter (composition),
// never per feature.
@AutoRouterConfig()
abstract class SplashRouter extends RootStackRouter {}

@RoutePage(name: 'SplashRoute')
final class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const SplashWidget();
}
