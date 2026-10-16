// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether webviews may proceed on an untrusted TLS server certificate.
///
/// Native WebViews (WKWebView / android.webkit) do their own TLS validation and
/// are not covered by a Dio `HttpOverrides.global` certificate bypass. Unlike the
/// other DI slots in this workspace this one does not throw: rejecting untrusted
/// certificates is the correct behaviour, so an app that never binds it is safe.
/// Composition overrides it to `true` only for non-production automation behind a
/// MITM proxy.

@ProviderFor(untrustedWebviewCertificatesAllowed)
final untrustedWebviewCertificatesAllowedProvider =
    UntrustedWebviewCertificatesAllowedProvider._();

/// Whether webviews may proceed on an untrusted TLS server certificate.
///
/// Native WebViews (WKWebView / android.webkit) do their own TLS validation and
/// are not covered by a Dio `HttpOverrides.global` certificate bypass. Unlike the
/// other DI slots in this workspace this one does not throw: rejecting untrusted
/// certificates is the correct behaviour, so an app that never binds it is safe.
/// Composition overrides it to `true` only for non-production automation behind a
/// MITM proxy.

final class UntrustedWebviewCertificatesAllowedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether webviews may proceed on an untrusted TLS server certificate.
  ///
  /// Native WebViews (WKWebView / android.webkit) do their own TLS validation and
  /// are not covered by a Dio `HttpOverrides.global` certificate bypass. Unlike the
  /// other DI slots in this workspace this one does not throw: rejecting untrusted
  /// certificates is the correct behaviour, so an app that never binds it is safe.
  /// Composition overrides it to `true` only for non-production automation behind a
  /// MITM proxy.
  UntrustedWebviewCertificatesAllowedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'untrustedWebviewCertificatesAllowedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$untrustedWebviewCertificatesAllowedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return untrustedWebviewCertificatesAllowed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$untrustedWebviewCertificatesAllowedHash() =>
    r'cf3ec2801622319ed26f83e6dfc8b92d1896df9e';
