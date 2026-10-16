import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/routing/splash_routing.dart';

part 'providers_di.br.g.dart';

// splash_presentation — inbound dependency-injection slots. All throw until the
// composition layer overrides them.
//
// None of them names another feature's vocabulary. That is deliberate: splash
// triggers the cold start, it does not participate in it, so a type it cannot
// act on has no business in its public surface.

/// Whether this build may launch at all — asked first, before anything else
/// runs. False means something else has already put up the screen that says
/// why, so splash has nothing left to do.
///
/// A bool for the same reason as the other slots: splash must not learn what
/// can stop a launch, only that one was stopped.
typedef CheckAppStatusFun = Future<bool> Function();

@riverpod
CheckAppStatusFun checkAppStatus(Ref ref) => throw UnimplementedError(
  'checkAppStatusProvider must be overridden by the composition layer',
);

/// The once-per-launch device work, whatever that turns out to be.
///
/// Deliberately `Future<void>` and argument-less: splash neither supplies what
/// is done nor interprets how it failed. What fills this slot returns a richer
/// type, and is assignable here precisely because that is a widening.
typedef PrepareDeviceFun = Future<void> Function();

@riverpod
PrepareDeviceFun prepareDevice(Ref ref) => throw UnimplementedError(
  'prepareDeviceProvider must be overridden by the composition layer',
);

/// Asks the server for the settings the screens show, once per launch.
///
/// Runs after [prepareDevice], because the route wants the token registration
/// mints. A failure is no reason not to launch — the last stored settings
/// stand in.
typedef RefreshSettingsFun = Future<void> Function();

@riverpod
RefreshSettingsFun refreshSettings(Ref ref) => throw UnimplementedError(
  'refreshSettingsProvider must be overridden by the composition layer',
);

/// Whether a member is authenticated. Deliberately a bool, not a token: splash
/// must not learn what a session is made of, and must not have to know that an
/// install which never signed in still holds a perfectly live guest token.
@riverpod
Future<bool> isAuthenticated(Ref ref) => throw UnimplementedError(
  'isAuthenticatedProvider must be overridden by the composition layer',
);

@riverpod
SplashRouting splashRouting(Ref ref) => throw UnimplementedError(
  'splashRoutingProvider must be overridden by the composition layer (app_router)',
);
