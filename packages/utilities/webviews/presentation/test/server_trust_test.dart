import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_presentation/src/server_trust.dart';

void main() {
  group('Webview server-trust challenge', () {
    test(
      'Given an app that has not opted into trusting untrusted certificates '
      'When the webview is challenged to trust the server certificate '
      'Then no handler is installed, so the native default rejects it',
      () => expect(
        serverTrustAuthResponse(untrustedCertificatesAllowed: false),
        isNull,
      ),
    );

    test(
      'Given an app that trusts untrusted certificates for non-production automation '
      'When the webview faces a proxy presenting an untrusted certificate '
      'Then the webview proceeds through the challenge',
      () {
        final response = serverTrustAuthResponse(
          untrustedCertificatesAllowed: true,
        );

        expect(response, isNotNull);
        expect(response!.action, ServerTrustAuthResponseAction.PROCEED);
      },
    );
  });
}
