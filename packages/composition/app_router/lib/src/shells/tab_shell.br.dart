import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:home_presentation/home_presentation.dart' show HomeRoute;
import 'package:l10n_application/l10n_application.dart';

/// Root path for the tab shell. Splash owns the initial `/`, so the shell gets
/// its own segment; its tab children resolve under it (`/main/home`, …).
enum TabShellRoutePath {
  shell('/main');

  const TabShellRoutePath(this.path);

  final String path;
}

/// The app's tab shell.
///
/// One tab today, so no bar. The bar renders from [_routes] and
/// [_destinationsOf] alone: a new tab is an entry in each and nothing else
/// here, and the bar appears with the second.
@RoutePage(name: 'TabShellRoute')
final class TabShellPage extends StatelessWidget {
  const TabShellPage({super.key});

  static const _barElevation = 0.0;
  static const _barHeight = 44.0;
  static const _iconSize = 32.0;

  /// Tab routes, in bar order. AutoTabsScaffold matches these to
  /// [_destinationsOf] by index, so the two must stay in the same order.
  static const _routes = <PageRouteInfo<void>>[HomeRoute()];

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
    routes: _routes,
    animationDuration: .zero,
    bottomNavigationBuilder: (context, tabsRouter) {
      final destinations = _destinationsOf(context);

      // NavigationBar asserts `destinations.length >= 2` — Material has no
      // one-destination bar, and a bar with nothing to switch to would be noise
      // regardless.
      if (destinations.length < 2) return const SizedBox.shrink();

      return NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              size: _iconSize,
              // Not the brand primary: a dark primary on the charcoal bar
              // reads darker than the inactive tabs.
              color: states.contains(WidgetState.selected)
                  ? DSColor.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          height: _barHeight,
          labelBehavior: .alwaysHide,
          // The same token the header band is painted with, not a theme role
          // that happens to resolve near it: the two are the app's top and
          // bottom edge and have to be the one colour.
          backgroundColor: DSColor.charcoal,
          surfaceTintColor: Colors.transparent,
          elevation: _barElevation,
          indicatorColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          destinations: destinations,
        ),
      );
    },
  );

  List<NavigationDestination> _destinationsOf(BuildContext context) => [
    NavigationDestination(
      icon: const Icon(Icons.grid_view_outlined),
      selectedIcon: const Icon(Icons.grid_view),
      label: context.t.home.tabLabel,
      // Empty rather than omitted: disables the long-press tooltip, which the
      // always-hidden labels make redundant.
      tooltip: '',
    ),
  ];
}
