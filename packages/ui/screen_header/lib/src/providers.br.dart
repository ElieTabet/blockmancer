import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_header/src/providers_di.br.dart' as di;
import 'package:screen_header/src/routing/screen_header_routing.dart';

// screen_header — public providers exposed by this package.

export 'package:screen_header/src/providers_di.br.dart' show LogoutFun;

/// Binds the routing slot to a concrete [ScreenHeaderRouting] supplied by the
/// composition layer.
List<Override> bindRoutingProviders({
  required ScreenHeaderRouting Function(Ref ref) screenHeaderRouting,
}) => [di.screenHeaderRoutingProvider.overrideWith(screenHeaderRouting)];

/// Binds what the header reads. It never names `auth` or `app_settings` —
/// composition points these at whatever owns the session and the settings.
List<Override> bindProviders({
  required Future<bool> Function(Ref ref) isAuthenticated,
  required di.LogoutFun Function(Ref ref) logout,
  required String? Function(Ref ref) organizationName,
}) => [
  di.isAuthenticatedProvider.overrideWith(isAuthenticated),
  di.logoutProvider.overrideWith(logout),
  di.organizationNameProvider.overrideWith(organizationName),
];
