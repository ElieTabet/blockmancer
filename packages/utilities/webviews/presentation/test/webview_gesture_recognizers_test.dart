import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

/// The recognizer types the webview was built with, which is what decides who wins a drag started over
/// the page: the platform view claims what it is given, and the gesture arena hands the rest to whoever
/// else is competing — the host's scrollable.
Future<Set<Type>> _recognizersOf(
  WidgetTester tester, {
  required bool scrollsWithHost,
  bool interactive = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Webview(
          configuration: _configuration,
          interactive: interactive,
          scrollsWithHost: scrollsWithHost,
        ),
      ),
    ),
  );
  await tester.pump();

  final webview = tester.widget<InAppWebView>(find.byType(InAppWebView));
  final recognizers =
      webview.platform.params.gestureRecognizers ??
      const <Factory<OneSequenceGestureRecognizer>>{};

  return {for (final factory in recognizers) factory.type};
}

void main() {
  setUpAll(() => installFakeWebviewPlatform());

  group('Scrolling a page that hosts a webview', () {
    testWidgets(
      'Given a page whose host owns the scroll '
      'When the reader drags from over the page '
      'Then only the tap is claimed, so the drag is left to the host',
      (tester) async => expect(
        await _recognizersOf(tester, scrollsWithHost: true),
        {TapGestureRecognizer},
      ),
    );

    testWidgets(
      'Given a page that owns its own gestures '
      'When the reader drags from over the page '
      'Then every touch is claimed, and nothing around it can scroll',
      (tester) async => expect(
        await _recognizersOf(tester, scrollsWithHost: false),
        {EagerGestureRecognizer},
      ),
    );

    testWidgets(
      'Given an inert preview of a page '
      'When the reader touches it '
      'Then nothing is claimed, so the shell around it handles the touch',
      (tester) async => expect(
        await _recognizersOf(tester, interactive: false, scrollsWithHost: true),
        isEmpty,
      ),
    );
  });
}
