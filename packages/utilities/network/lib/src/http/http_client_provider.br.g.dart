// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_client_provider.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The client every data layer talks to. Interceptor order matters: headers
/// first, auth second, so the bearer token isn't overwritten by the defaults.

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

/// The client every data layer talks to. Interceptor order matters: headers
/// first, auth second, so the bearer token isn't overwritten by the defaults.

final class HttpClientProvider
    extends $FunctionalProvider<HttpClient, HttpClient, HttpClient>
    with $Provider<HttpClient> {
  /// The client every data layer talks to. Interceptor order matters: headers
  /// first, auth second, so the bearer token isn't overwritten by the defaults.
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<HttpClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HttpClient create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpClient>(value),
    );
  }
}

String _$httpClientHash() => r'994d332018374b60b6ebdb171b05531cd194173c';

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

@ProviderFor(publicHttpClient)
final publicHttpClientProvider = PublicHttpClientProvider._();

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

final class PublicHttpClientProvider
    extends $FunctionalProvider<HttpClient, HttpClient, HttpClient>
    with $Provider<HttpClient> {
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
  PublicHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicHttpClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicHttpClientHash();

  @$internal
  @override
  $ProviderElement<HttpClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HttpClient create(Ref ref) {
    return publicHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpClient>(value),
    );
  }
}

String _$publicHttpClientHash() => r'f295415cb353fe5c4eadda2c9812ee1d893f5aed';
