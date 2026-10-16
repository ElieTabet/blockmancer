import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// The response to a native WebView server-trust challenge, or `null` to keep
/// the WebView's default TLS validation (reject untrusted certificates).
///
/// A MITM proxy in non-prod automation presents a certificate the native WebView
/// rejects. Returns `null` when [untrustedCertificatesAllowed] is `false`
/// (production always takes this path); when `true`, proceeds through the challenge.
ServerTrustAuthResponse? serverTrustAuthResponse({
  required bool untrustedCertificatesAllowed,
}) => untrustedCertificatesAllowed
    ? ServerTrustAuthResponse(action: .PROCEED)
    : null;
