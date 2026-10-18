import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/providers_di.br.dart' as di;
import 'package:splash_presentation/src/routing/splash_routing.dart';

// splash_presentation — public providers exposed by this layer.

List<Override> bindProviders({
  required Future<bool> Function(Ref ref) tutorialSeen,
  required Future<bool> Function(Ref ref) updateRequired,
}) => [
  di.tutorialSeenProvider.overrideWith(tutorialSeen),
  di.updateRequiredProvider.overrideWith(updateRequired),
];

/// Binds the splash routing slot to a concrete [SplashRouting] supplied by the
/// composition layer.
List<Override> bindRoutingProviders({
  required SplashRouting Function(Ref ref) splashRouting,
}) => [di.splashRoutingProvider.overrideWith(splashRouting)];
