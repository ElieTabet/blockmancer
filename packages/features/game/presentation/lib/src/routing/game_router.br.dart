import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';

part 'game_router.br.gr.dart';

/// Path segment for the game feature's route.
///
/// Relative, with no leading slash: the page is a tab child, so it resolves
/// under the shell's own segment.
enum GameRoutePath {
  game('game');

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
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) => const GameWidget();
}
