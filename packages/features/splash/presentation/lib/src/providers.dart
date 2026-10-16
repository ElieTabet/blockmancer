import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:splash_presentation/src/providers_di.br.dart' as di;
import 'package:splash_presentation/src/routing/splash_routing.dart';

// splash_presentation — public providers exposed by this layer.

/// Binds the splash routing slot to a concrete [SplashRouting] supplied by the
/// composition layer.
List<Override> bindRoutingProviders({
  required SplashRouting Function(Ref ref) splashRouting,
}) => [di.splashRoutingProvider.overrideWith(splashRouting)];

/// Binds the pieces of cold-start work. Composition supplies the sources; how
/// they combine into a verdict is decided by SplashStateNotifier, not here and
/// not there.
List<Override> bindProviders({
  required di.CheckAppStatusFun Function(Ref ref) checkAppStatus,
  required Future<bool> Function(Ref ref) isAuthenticated,
  required di.PrepareDeviceFun Function(Ref ref) prepareDevice,
  required di.RefreshSettingsFun Function(Ref ref) refreshSettings,
}) => [
  di.checkAppStatusProvider.overrideWith(checkAppStatus),
  di.prepareDeviceProvider.overrideWith(prepareDevice),
  di.isAuthenticatedProvider.overrideWith(isAuthenticated),
  di.refreshSettingsProvider.overrideWith(refreshSettings),
];
