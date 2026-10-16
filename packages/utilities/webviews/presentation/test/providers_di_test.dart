import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_presentation/src/providers_di.br.dart' as di;

void main() {
  group('Webview certificate trust', () {
    test('Given an app with no certificate-trust override applied '
        'When a webview decides whether to trust an untrusted TLS certificate '
        'Then the untrusted certificate is rejected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(di.untrustedWebviewCertificatesAllowedProvider),
        isFalse,
      );
    });
  });
}
