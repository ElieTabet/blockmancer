import 'package:app_router/src/routing/splash_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/splash_presentation.dart' as splash_ui;

/// Overrides that bind every feature routing slot to its app_router
/// implementation. Aggregated by app_providers into the app's root container.
///
/// Routing only — non-routing contracts are bound in app_providers, which is
/// the layer that knows the capability packages.
List<Override> routingOverrides() => [
  ...splash_ui.bindRoutingProviders(
    splashRouting: (ref) => const SplashRoutingImpl(),
  ),
];
