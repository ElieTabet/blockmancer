// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiBaseUrl)
final apiBaseUrlProvider = ApiBaseUrlProvider._();

final class ApiBaseUrlProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  ApiBaseUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiBaseUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiBaseUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return apiBaseUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$apiBaseUrlHash() => r'9d8eb81a3da73fb4cca7e7e9f491671e37684893';

@ProviderFor(networkAuthToken)
final networkAuthTokenProvider = NetworkAuthTokenProvider._();

final class NetworkAuthTokenProvider
    extends
        $FunctionalProvider<
          AuthTokenProvider,
          AuthTokenProvider,
          AuthTokenProvider
        >
    with $Provider<AuthTokenProvider> {
  NetworkAuthTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkAuthTokenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkAuthTokenHash();

  @$internal
  @override
  $ProviderElement<AuthTokenProvider> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthTokenProvider create(Ref ref) {
    return networkAuthToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthTokenProvider value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthTokenProvider>(value),
    );
  }
}

String _$networkAuthTokenHash() => r'10733c550f16b788675ffab0df1e01ac3d3482ac';

/// `host:port` of an HTTP debugging proxy, or null for a direct connection.
///
/// Unlike the slots above this one does **not** throw when left unbound: no
/// proxy is the correct answer for every build that isn't being inspected, so
/// an app that never binds it simply talks to the API directly.

@ProviderFor(httpProxy)
final httpProxyProvider = HttpProxyProvider._();

/// `host:port` of an HTTP debugging proxy, or null for a direct connection.
///
/// Unlike the slots above this one does **not** throw when left unbound: no
/// proxy is the correct answer for every build that isn't being inspected, so
/// an app that never binds it simply talks to the API directly.

final class HttpProxyProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// `host:port` of an HTTP debugging proxy, or null for a direct connection.
  ///
  /// Unlike the slots above this one does **not** throw when left unbound: no
  /// proxy is the correct answer for every build that isn't being inspected, so
  /// an app that never binds it simply talks to the API directly.
  HttpProxyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpProxyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpProxyHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return httpProxy(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$httpProxyHash() => r'ac27b03a2c6289749b63a4b599389b33d06bf416';

/// Told when any call meets the API's maintenance answer.
///
/// Like [httpProxy] it does **not** throw when left unbound: hearing nothing is
/// safe — the call still fails as it always did — so a harness that never binds
/// it behaves exactly as before.

@ProviderFor(networkMaintenance)
final networkMaintenanceProvider = NetworkMaintenanceProvider._();

/// Told when any call meets the API's maintenance answer.
///
/// Like [httpProxy] it does **not** throw when left unbound: hearing nothing is
/// safe — the call still fails as it always did — so a harness that never binds
/// it behaves exactly as before.

final class NetworkMaintenanceProvider
    extends $FunctionalProvider<OnMaintenance, OnMaintenance, OnMaintenance>
    with $Provider<OnMaintenance> {
  /// Told when any call meets the API's maintenance answer.
  ///
  /// Like [httpProxy] it does **not** throw when left unbound: hearing nothing is
  /// safe — the call still fails as it always did — so a harness that never binds
  /// it behaves exactly as before.
  NetworkMaintenanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkMaintenanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkMaintenanceHash();

  @$internal
  @override
  $ProviderElement<OnMaintenance> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OnMaintenance create(Ref ref) {
    return networkMaintenance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnMaintenance value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnMaintenance>(value),
    );
  }
}

String _$networkMaintenanceHash() =>
    r'fe112b3fc29706b7571cd1f3a0f297687399c3db';
