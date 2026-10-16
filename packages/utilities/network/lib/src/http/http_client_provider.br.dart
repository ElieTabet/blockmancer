import 'package:network/src/auth/auth_network_interceptor.dart';
import 'package:network/src/dio/dio_http_client.dart';
import 'package:network/src/http/http_client.dart';
import 'package:network/src/interceptors/headers_network_interceptor.dart';
import 'package:network/src/interceptors/maintenance_network_interceptor.dart';
import 'package:network/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.br.g.dart';

const _defaultHeaders = HeadersNetworkInterceptor({
  'Accept': 'application/json',
});

/// The client every data layer talks to. Interceptor order matters: headers
/// first, auth second, so the bearer token isn't overwritten by the defaults.
@riverpod
HttpClient httpClient(Ref ref) => DioHttpClient.create(
  baseUrl: ref.watch(di.apiBaseUrlProvider),
  proxy: ref.watch(di.httpProxyProvider),
  networkInterceptors: [
    _defaultHeaders,
    AuthNetworkInterceptor(ref.watch(di.networkAuthTokenProvider)),
    MaintenanceNetworkInterceptor(ref.watch(di.networkMaintenanceProvider)),
  ],
);

/// The same transport with **no** auth interceptor, for the endpoints that
/// establish an identity rather than use one — device registration, login,
/// token refresh. The backend marks all three PUBLIC.
///
/// This is not just an optimisation. Sending a bearer token to `/auth/login`
/// means a wrong password comes back 401, and [AuthNetworkInterceptor] reads
/// any 401 as the session expiring — so a typo would clear the stored tokens
/// and fire the session-expired callback mid-login. Identity-establishing
/// calls must not travel through the interceptor that reacts to identity
/// failures.
///
/// Maintenance is watched here too: registration and login are exactly the
/// calls a launch makes, and the API blocks them like any other — only
/// `/app-status` keeps answering.
@riverpod
HttpClient publicHttpClient(Ref ref) => DioHttpClient.create(
  baseUrl: ref.watch(di.apiBaseUrlProvider),
  proxy: ref.watch(di.httpProxyProvider),
  networkInterceptors: [
    _defaultHeaders,
    MaintenanceNetworkInterceptor(ref.watch(di.networkMaintenanceProvider)),
  ],
);
