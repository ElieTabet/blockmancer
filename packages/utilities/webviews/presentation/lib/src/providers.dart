import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webviews_presentation/src/providers_di.br.dart' as di;

// webviews_presentation — public providers exposed by this package.

/// Binds the webview DI slots to sources supplied by the composition layer.
List<Override> bindProviders({
  required bool Function(Ref ref) untrustedCertificatesAllowed,
}) => [
  di.untrustedWebviewCertificatesAllowedProvider.overrideWith(
    untrustedCertificatesAllowed,
  ),
];
