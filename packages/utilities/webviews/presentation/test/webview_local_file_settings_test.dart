import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';
import 'package:webviews_presentation/webviews_presentation.dart';

import 'package:webviews_presentation/testing.dart';

/// The settings the page is actually started with.
Future<InAppWebViewSettings> _settingsOf(
  WidgetTester tester,
  WebViewConfiguration configuration,
) async {
  await tester.pumpWidget(
    ProviderScope(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Webview(configuration: configuration),
      ),
    ),
  );
  await tester.pump();

  return tester
      .widget<InAppWebView>(find.byType(InAppWebView))
      .platform
      .params
      .initialSettings!;
}

void main() {
  setUpAll(() => installFakeWebviewPlatform());

  // On iOS the plugin only takes WKWebView's loadFileURL(_:allowingReadAccessTo:)
  // path when this setting is present; without it a file:// load is refused
  // outright. So this is what makes a local document render at all, not a
  // hardening extra.
  testWidgets('Given a webview configured with a local document '
      'When it starts '
      'Then it is granted read access to that document\'s directory', (
    tester,
  ) async {
    final settings = await _settingsOf(
      tester,
      const WebViewConfigurationFromLocalFile(
        filePath: '/tmp/publications/12/index.html',
        readAccessRoot: '/tmp/publications/12',
        javascriptBridges: [],
      ),
    );

    expect(settings.allowFileAccess, isTrue);
    expect(
      settings.allowingReadAccessTo.toString(),
      'file:///tmp/publications/12/',
    );
  });

  testWidgets('Given a webview configured with a remote URL '
      'When it starts '
      'Then it is granted no filesystem access at all', (tester) async {
    final settings = await _settingsOf(
      tester,
      const WebViewConfigurationFromUrl(
        url: 'https://example.com',
        javascriptBridges: [],
      ),
    );

    expect(settings.allowFileAccess, isFalse);
    expect(settings.allowingReadAccessTo, isNull);
  });

  // The bundle contract requires these off, which is why a document may use
  // <script src> and <link> but not fetch or ES modules.
  testWidgets('Given a webview configured with a local document '
      'When it starts '
      'Then the page still cannot read siblings from script', (tester) async {
    final settings = await _settingsOf(
      tester,
      const WebViewConfigurationFromLocalFile(
        filePath: '/tmp/publications/12/index.html',
        readAccessRoot: '/tmp/publications/12',
        javascriptBridges: [],
      ),
    );

    expect(settings.allowFileAccessFromFileURLs, isFalse);
    expect(settings.allowUniversalAccessFromFileURLs, isFalse);
  });
}
