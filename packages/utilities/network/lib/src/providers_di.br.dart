import 'package:network/src/auth/auth_token_provider.dart';
import 'package:network/src/interceptors/maintenance_network_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// network — inbound dependency-injection slots, overridden by the composition
// layer (app_providers) via bindProviders(...).

@riverpod
String apiBaseUrl(Ref ref) => throw UnimplementedError(
  'apiBaseUrlProvider must be overridden by the composition layer (app_providers)',
);

@riverpod
AuthTokenProvider networkAuthToken(Ref ref) => throw UnimplementedError(
  'networkAuthTokenProvider must be overridden by the composition layer (app_providers)',
);

/// `host:port` of an HTTP debugging proxy, or null for a direct connection.
///
/// Unlike the slots above this one does **not** throw when left unbound: no
/// proxy is the correct answer for every build that isn't being inspected, so
/// an app that never binds it simply talks to the API directly.
@riverpod
String? httpProxy(Ref ref) => null;

/// Told when any call meets the API's maintenance answer.
///
/// Like [httpProxy] it does **not** throw when left unbound: hearing nothing is
/// safe — the call still fails as it always did — so a harness that never binds
/// it behaves exactly as before.
@riverpod
OnMaintenance networkMaintenance(Ref ref) => (_) {};
