import 'package:app_router/src/shells/tab_shell.br.dart';
import 'package:app_update_presentation/app_update_presentation.dart'
    show AppUpdateRoutePath, UpdateRequiredRoute;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:game_presentation/game_presentation.dart'
    show GameRoute, GameRoutePath;
import 'package:home_presentation/home_presentation.dart'
    show HomeRoute, HomeRoutePath, SpellbookRoute, SpellbookRoutePath;
import 'package:settings_presentation/settings_presentation.dart'
    show SettingsRoute, SettingsRoutePath;
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
    // A side trip from Home rather than a place in the game: it slides up and
    // is closed, where a run is pushed and left.
    CustomRoute(
      path: SettingsRoutePath.settings.path,
      page: SettingsRoute.page,
      fullscreenDialog: true,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    // A side trip from Home's header, like Settings.
    CustomRoute(
      path: SpellbookRoutePath.spellbook.path,
      page: SpellbookRoute.page,
      fullscreenDialog: true,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    // Faded in over the splash, and the only route left: a version too old to
    // play goes nowhere else.
    CustomRoute(
      path: AppUpdateRoutePath.updateRequired.path,
      page: UpdateRequiredRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
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
