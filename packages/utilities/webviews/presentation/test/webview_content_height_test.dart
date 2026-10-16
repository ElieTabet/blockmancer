import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';
import 'package:webviews_presentation/webviews_presentation.dart';

import 'package:webviews_presentation/testing.dart';

const _configuration = WebViewConfigurationFromUrl(
  url: 'https://example.com',
  javascriptBridges: [],
);

const _fullscreenBlockingConfiguration = WebViewConfigurationFromUrl(
  url: 'https://example.com',
  javascriptBridges: [],
  preventFullscreen: true,
);

/// The page-side script that measures the content and pushes the number out. Nothing else the widget
/// injects mentions the handler, so its presence is what says the measuring is actually wired.
bool _measures(UserScript script) =>
    script.source.contains('appWebviewContentHeight');

/// The scripts the page is loaded with — where everything the widget decided to inject ends up.
Future<List<UserScript>> _scriptsOf(
  WidgetTester tester, {
  required bool reportsContentHeight,
  bool preventFullscreen = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Webview(
          configuration: preventFullscreen
              ? _fullscreenBlockingConfiguration
              : _configuration,
          onContentHeightChanged: reportsContentHeight ? (_) {} : null,
        ),
      ),
    ),
  );
  await tester.pump();

  final webview = tester.widget<InAppWebView>(find.byType(InAppWebView));

  return webview.platform.params.initialUserScripts?.toList() ?? [];
}

void main() {
  setUpAll(() => installFakeWebviewPlatform());

  group('Sizing a host slot to the page inside it', () {
    testWidgets('Given a host that sizes its slot to what the page draws '
        'When the page is loaded '
        'Then it carries the script that measures the content and reports it back', (
      tester,
    ) async {
      final scripts = await _scriptsOf(tester, reportsContentHeight: true);

      expect(scripts.where(_measures), hasLength(1));
      // The main frame's document is what the host sizes to; an iframe measuring itself would race
      // it and win half the time, so the host would size to whichever answered last.
      expect(scripts.singleWhere(_measures).forMainFrameOnly, isTrue);
    });

    testWidgets(
      'Given a host that also stops the page going fullscreen '
      'When the page is loaded '
      'Then it still measures itself, rather than one of the two silently replacing the other',
      (tester) async {
        final scripts = await _scriptsOf(
          tester,
          reportsContentHeight: true,
          preventFullscreen: true,
        );

        expect(scripts.where(_measures), hasLength(1));
        expect(scripts, hasLength(2));
      },
    );

    testWidgets('Given a host that reserves its own room and never asks '
        'When the page is loaded '
        'Then nothing measures it, so no page pays for a report nobody reads', (
      tester,
    ) async {
      final scripts = await _scriptsOf(tester, reportsContentHeight: false);

      expect(scripts.where(_measures), isEmpty);
    });
  });
}
