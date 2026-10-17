import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';

part 'game_router.br.gr.dart';

/// Path for the game feature's route. Absolute: the game is pushed over the
/// tab shell, not one of its tabs.
enum GameRoutePath {
  game('/game');

  const GameRoutePath(this.path);

  final String path;
}

// Empty codegen anchor — auto_route generates the route from the @RoutePage
// class below. The actual route table is declared once by AppRouter
// (composition), never per feature.
@AutoRouterConfig()
abstract class GameRouter extends RootStackRouter {}

@RoutePage(name: 'GameRoute')
final class GamePage extends StatelessWidget {
  const GamePage({required this.launch, super.key});

  final GameLaunch launch;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [gameLaunchProvider.overrideWithValue(launch)],
    child: const GameWidget(),
  );
}
