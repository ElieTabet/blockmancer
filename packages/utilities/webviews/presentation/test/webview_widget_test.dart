import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';
import 'package:webviews_presentation/webviews_presentation.dart';

import 'package:webviews_presentation/testing.dart';

Future<void> _pumpWebview(
  WidgetTester tester, {
  required FutureOr<String> url,
  Widget? errorWidget,
  Widget? loadingWidget,
}) => tester.pumpWidget(
  ProviderScope(
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Webview(
        configuration: WebViewConfigurationFromUrl(
          url: url,
          javascriptBridges: const [],
        ),
        errorWidget: errorWidget,
        loadingWidget: loadingWidget,
      ),
    ),
  ),
);

void main() {
  setUpAll(() => installFakeWebviewPlatform());

  group('when the webview is displayed', () {
    testWidgets('Given the initial URL is still being computed '
        'When the user views the widget '
        'Then the loading widget is shown', (tester) async {
      await _pumpWebview(
        tester,
        url: Completer<String>().future,
        loadingWidget: const Text('Loading...'),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('Given the initial URL fails to resolve '
        'When the user views the widget '
        'Then the error widget is shown', (tester) async {
      final completer = Completer<String>();

      await _pumpWebview(
        tester,
        url: completer.future,
        errorWidget: const Text('Something went wrong'),
      );
      completer.completeError(Exception('Failed to load'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('Given no custom loading widget is provided '
        'When the initial URL is still being computed '
        'Then nothing is drawn in its place', (tester) async {
      await _pumpWebview(tester, url: Completer<String>().future);

      expect(find.byType(InAppWebView), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('Given no custom error widget is provided '
        'When the initial URL fails to resolve '
        'Then nothing is drawn in its place', (tester) async {
      final completer = Completer<String>();

      await _pumpWebview(tester, url: completer.future);
      completer.completeError(Exception('Network error'));
      await tester.pumpAndSettle();

      expect(find.byType(InAppWebView), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
      'Given a URL the app already has '
      'When the user views the widget '
      'Then the page is mounted straight away, with no loading frame in between',
      (tester) async {
        await _pumpWebview(
          tester,
          url: 'https://example.com',
          loadingWidget: const Text('Loading...'),
        );

        expect(find.text('Loading...'), findsNothing);
        expect(find.byType(InAppWebView), findsOneWidget);
      },
    );
  });
}
