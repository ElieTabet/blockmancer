import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_presentation/src/webview_url_redaction.dart';

void main() {
  group('Logging where a webview navigated', () {
    test('Given a page address that carries the session tokens '
        'When the navigation is recorded '
        'Then the page it went to is recorded without the tokens', () {
      final redacted = redactUrlForLog(
        'https://app.example.com/publications/42/read?token=single-use-secret&refreshtoken=refresh-secret',
      );

      expect(redacted, 'https://app.example.com/publications/42/read');
      expect(redacted, isNot(contains('single-use-secret')));
      expect(redacted, isNot(contains('refresh-secret')));
    });

    test(
      'Given a page address whose fragment carries reader data '
      'When the navigation is recorded '
      'Then only the page it went to is recorded',
      () => expect(
        redactUrlForLog('https://app.example.com/library#reader-42'),
        'https://app.example.com/library',
      ),
    );

    test(
      'Given an address the app cannot make sense of '
      'When the navigation is recorded '
      'Then nothing of it is recorded',
      () => expect(redactUrlForLog(':::not a url:::'), '<unparseable url>'),
    );
  });
}
