import 'package:network/src/auth/auth_token_provider.dart';
import 'package:network/src/interceptors/maintenance_network_interceptor.dart';
import 'package:network/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// network — public providers exposed by this package.

/// Binds the network DI slots to sources supplied by the composition layer.
/// `network` never reads app configuration itself, so the base URL arrives as a
/// value rather than as a dependency on app_config.
List<Override> bindProviders({
  required String Function(Ref ref) apiBaseUrl,
  required AuthTokenProvider Function(Ref ref) networkAuthToken,
  String? Function(Ref ref)? httpProxy,
  OnMaintenance Function(Ref ref)? networkMaintenance,
}) => [
  di.apiBaseUrlProvider.overrideWith(apiBaseUrl),
  di.networkAuthTokenProvider.overrideWith(networkAuthToken),
  if (httpProxy != null) di.httpProxyProvider.overrideWith(httpProxy),
  if (networkMaintenance != null)
    di.networkMaintenanceProvider.overrideWith(networkMaintenance),
];
