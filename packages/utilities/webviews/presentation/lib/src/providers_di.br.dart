import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// webviews_presentation — inbound dependency-injection slots.

/// Whether webviews may proceed on an untrusted TLS server certificate.
///
/// Native WebViews (WKWebView / android.webkit) do their own TLS validation and
/// are not covered by a Dio `HttpOverrides.global` certificate bypass. Unlike the
/// other DI slots in this workspace this one does not throw: rejecting untrusted
/// certificates is the correct behaviour, so an app that never binds it is safe.
/// Composition overrides it to `true` only for non-production automation behind a
/// MITM proxy.
@riverpod
bool untrustedWebviewCertificatesAllowed(Ref ref) => false;
