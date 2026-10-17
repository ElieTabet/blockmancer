import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:home_presentation/src/widgets/spellbook_widget.dart';

part 'home_router.br.gr.dart';

/// Path segment for the home feature's route.
///
/// Relative, with no leading slash: the page is a tab child, so it resolves
/// under the shell's own segment.
enum HomeRoutePath {
  home('home');

  const HomeRoutePath(this.path);

  final String path;
}

/// The Spellbook's path: absolute, as it is pushed over the shell like
/// Settings rather than being a tab child.
enum SpellbookRoutePath {
  spellbook('/spellbook');

  const SpellbookRoutePath(this.path);

  final String path;
}

// Empty codegen anchor — auto_route generates the route from the @RoutePage
// class below. The actual route table is declared once by AppRouter
// (composition), never per feature.
@AutoRouterConfig()
abstract class HomeRouter extends RootStackRouter {}

@RoutePage(name: 'HomeRoute')
final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const HomeWidget();
}

@RoutePage(name: 'SpellbookRoute')
final class SpellbookPage extends StatelessWidget {
  const SpellbookPage({super.key});

  @override
  Widget build(BuildContext context) => const SpellbookWidget();
}
