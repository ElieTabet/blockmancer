import 'package:app_router/src/routing/game_routing.dart';
import 'package:app_router/src/routing/home_routing.dart';
import 'package:app_router/src/routing/splash_routing.dart';
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:home_presentation/home_presentation.dart' as home_ui;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/splash_presentation.dart' as splash_ui;

/// Overrides that bind every feature routing slot to its app_router
/// implementation. Aggregated by app_providers into the app's root container.
///
/// Routing only — non-routing contracts are bound in app_providers, which is
/// the layer that knows the capability packages.
List<Override> routingOverrides() => [
  ...game_ui.bindRoutingProviders(
    gameRouting: (ref) => const GameRoutingImpl(),
  ),
  ...home_ui.bindRoutingProviders(
    homeRouting: (ref) => const HomeRoutingImpl(),
  ),
  ...splash_ui.bindRoutingProviders(
    splashRouting: (ref) => const SplashRoutingImpl(),
  ),
];
