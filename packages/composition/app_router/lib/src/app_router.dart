import 'package:app_router/src/shells/tab_shell.br.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:game_presentation/game_presentation.dart'
    show GameRoute, GameRoutePath;
import 'package:home_presentation/home_presentation.dart'
    show HomeRoute, HomeRoutePath;
import 'package:splash_presentation/splash_presentation.dart'
    show SplashRoute, SplashRoutePath;

part 'app_router.gr.dart';

@AutoRouterConfig()
final class AppRouter extends RootStackRouter implements AutoRouteGuard {
  final List<AutoRoute> _extraRoutes;

  /// [extraRoutes] lets a test mount a screen of its own over the shell — the
  /// table is otherwise closed, and the class final.
  AppRouter({@visibleForTesting List<AutoRoute> extraRoutes = const []})
    : _extraRoutes = extraRoutes;

  @override
  List<AutoRoute> get routes => [
    _tabConfiguration,
    // Over the shell, not a tab: a run fills the screen, and back returns to
    // the tab it was started from.
    AutoRoute(path: GameRoutePath.game.path, page: GameRoute.page),
    // Faded in, not pushed: the launch shows it with no transition at all, but
    // lifting a block brings it back over the blocking screen.
    CustomRoute(
      path: SplashRoutePath.splash.path,
      page: SplashRoute.page,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    ..._extraRoutes,
  ];

  /// The tab shell and its children. Each tab's path segment comes from that
  /// feature's own `<Feature>RoutePath`, so a feature still owns its URL even
  /// though only composition knows the tree.
  AutoRoute get _tabConfiguration => CustomRoute(
    path: TabShellRoutePath.shell.path,
    page: TabShellRoute.page,
    transitionsBuilder: TransitionsBuilders.fadeIn,
    children: [
      AutoRoute(
        path: HomeRoutePath.home.path,
        page: HomeRoute.page,
        initial: true,
      ),
    ],
  );

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // Check if user is authenticated
    // final user = FirebaseAuth.instance.currentUser;

    // if (user == null) {
    //   resolver.redirect(const LoginRoute(), replace: true);
    //   return;
    // }

    resolver.next(true);
  }
}
