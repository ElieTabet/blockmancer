import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/routing/splash_routing.dart';

part 'providers_di.br.g.dart';

// splash_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

@riverpod
SplashRouting splashRouting(Ref ref) => throw UnimplementedError(
  'splashRoutingProvider must be overridden by the composition layer (app_router)',
);
