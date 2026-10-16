import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webviews_presentation/src/testing/fake_webview_platform.dart';

// webviews_presentation/testing — test support for anything that renders a
// Webview.
//
// A separate entry point so a feature can widget-test a screen containing one
// without depending on the engine: no feature may name flutter_inappwebview,
// and installing a platform stub would otherwise force it to.

/// Stands a fake native webview in for the real one, which asserts that a
/// platform implementation is registered — something a widget test has none of.
///
/// Call once, from `setUpAll`.
void installFakeWebviewPlatform() =>
    InAppWebViewPlatform.instance = FakeWebviewPlatform();
