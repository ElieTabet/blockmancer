import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';
import 'package:webviews_presentation/src/configuration/resolve_webview_ui_configuration.dart';
import 'package:webviews_presentation/src/configuration/webview_ui_configuration.br.dart';

void main() {
  group('Starting a webview from a local document', () {
    test('Given a document already extracted to disk '
        'When the UI configuration is resolved '
        'Then the initial request is a file URL for it', () {
      final resolved = resolveWebviewUiConfiguration(
        const WebViewConfigurationFromLocalFile(
          filePath: '/tmp/publications/12/index.html',
          readAccessRoot: '/tmp/publications/12',
          javascriptBridges: [],
        ),
      );

      expect(
        (resolved as WebViewUiConfiguration).initialUrlRequest!.url.toString(),
        'file:///tmp/publications/12/index.html',
      );
    });

    // Nothing is left to wait for once the bytes are on disk, and a loading
    // frame between "extracted" and "rendered" would only ever be a flash.
    test('Given a local document '
        'When the UI configuration is resolved '
        'Then it is available synchronously', () {
      expect(
        resolveWebviewUiConfiguration(
          const WebViewConfigurationFromLocalFile(
            filePath: '/tmp/publications/12/index.html',
            readAccessRoot: '/tmp/publications/12',
            javascriptBridges: [],
          ),
        ),
        isA<WebViewUiConfiguration>(),
      );
    });
  });

  group('Starting a webview from a URL', () {
    test(
      'Given a webview configured with a URL already in hand '
      'When the UI configuration is resolved '
      'Then it is available synchronously, so the widget never shows a loading frame',
      () {
        final resolved = resolveWebviewUiConfiguration(
          const WebViewConfigurationFromUrl(
            url: 'https://example.com',
            javascriptBridges: [],
          ),
        );

        expect(resolved, isA<WebViewUiConfiguration>());
        expect(
          (resolved as WebViewUiConfiguration).initialUrlRequest!.url
              .toString(),
          'https://example.com',
        );
      },
    );

    test('Given a webview whose URL still has to be computed '
        'When the URL resolves '
        'Then the initial request targets it', () async {
      final resolved = await resolveWebviewUiConfiguration(
        WebViewConfigurationFromUrl(
          url: Future.value('https://example.com/late'),
          javascriptBridges: const [],
        ),
      );

      expect(
        resolved.initialUrlRequest!.url.toString(),
        'https://example.com/late',
      );
    });

    test(
      'Given a webview whose URL cannot be computed '
      'When the resolution fails '
      'Then the failure surfaces rather than being swallowed',
      () => expectLater(
        resolveWebviewUiConfiguration(
          WebViewConfigurationFromUrl(
            url: Future<String>.error(Exception('no url')),
            javascriptBridges: const [],
          ),
        ),
        throwsA(isA<Exception>()),
      ),
    );
  });

  group('Starting a webview from HTML data', () {
    test('Given a webview configured to render inline HTML without a base URL '
        'When the UI configuration is resolved '
        'Then it carries the HTML content and no base URL', () {
      final resolved =
          resolveWebviewUiConfiguration(
                const WebViewConfigurationFromData(
                  htmlData: '<h1>Hello</h1>',
                  javascriptBridges: [],
                ),
              )
              as WebViewUiConfiguration;

      expect(resolved.initialData!.data, '<h1>Hello</h1>');
      expect(resolved.initialData!.baseUrl, isNull);
    });

    test('Given a webview configured to render inline HTML with a base URL '
        'When the UI configuration is resolved '
        'Then it carries the HTML content and the base URL', () {
      final resolved =
          resolveWebviewUiConfiguration(
                const WebViewConfigurationFromData(
                  htmlData: '<h1>Hello</h1>',
                  baseUrl: 'https://example.com',
                  javascriptBridges: [],
                ),
              )
              as WebViewUiConfiguration;

      expect(resolved.initialData!.data, '<h1>Hello</h1>');
      expect(resolved.initialData!.baseUrl.toString(), 'https://example.com');
    });

    test('Given a webview whose HTML is still being read '
        'When the data resolves '
        'Then the initial data carries it', () async {
      final resolved = await resolveWebviewUiConfiguration(
        WebViewConfigurationFromData(
          htmlData: Future.value('<h1>Late</h1>'),
          javascriptBridges: const [],
        ),
      );

      expect(resolved.initialData!.data, '<h1>Late</h1>');
    });
  });
}
