import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Keeps a `Webview`'s underlying native webview alive across widget disposal: its loaded page
/// survives being removed from the widget tree and is re-attached — not reloaded — on re-mount.
///
/// Create one long-lived instance (e.g. behind a keep-alive Riverpod provider) and pass that same
/// instance to every `Webview` that must persist or share the single native webview. Call [dispose]
/// when the page is closed for good — otherwise the native webview is never released.
class WebviewKeepAlive {
  final InAppWebViewKeepAlive delegate = InAppWebViewKeepAlive();

  /// Releases the kept-alive native webview. After this the delegate must not be reused.
  Future<void> dispose() => InAppWebViewController.disposeKeepAlive(delegate);
}
