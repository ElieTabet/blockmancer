import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Stands in for the native webview so the widget can be built at all: the real one asserts a platform
/// implementation is registered, which a unit test has none of. It keeps the creation params, which is
/// where everything the widget decided — recognizers, injected scripts — ends up.
final class FakeWebviewPlatform extends InAppWebViewPlatform {
  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) => _FakeWebViewWidget(params);
}

final class _FakeWebViewWidget extends PlatformInAppWebViewWidget {
  _FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) =>
      controller as T;

  @override
  void dispose() {}
}
