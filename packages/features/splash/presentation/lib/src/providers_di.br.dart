import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/routing/splash_routing.dart';

part 'providers_di.br.g.dart';

// splash_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// Whether the player turned motion down in the app's settings. A future: the
/// logo's entrance waits for the stored answer rather than play on a guess.
@riverpod
Future<bool> reduceMotionSetting(Ref ref) => throw UnimplementedError(
  'reduceMotionSettingProvider must be overridden by the composition layer',
);

@riverpod
SplashRouting splashRouting(Ref ref) => throw UnimplementedError(
  'splashRoutingProvider must be overridden by the composition layer (app_router)',
);

/// Whether the player has been through the tutorial. A future: the launch
/// waits for the stored answer rather than guess.
@riverpod
Future<bool> tutorialSeen(Ref ref) => throw UnimplementedError(
  'tutorialSeenProvider must be overridden by the composition layer',
);

/// Whether this version is too old to play: the launch goes no further than
/// the update screen. A future, for the launch's Remote Config fetch.
@riverpod
Future<bool> updateRequired(Ref ref) => throw UnimplementedError(
  'updateRequiredProvider must be overridden by the composition layer',
);
