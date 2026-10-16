part of 'webview.dart';

extension _WebviewUrlHandler on _WebviewState {
  Future<NavigationActionPolicy?> _handleShouldOverrideUrlLoading(
    NavigationAction navigationAction,
  ) async {
    final url = navigationAction.request.url?.toString() ?? '';
    Timber.d(
      tag: packageName,
      logMessage: 'shouldOverrideUrlLoading: ${redactUrlForLog(url)}',
    );

    return resolveNavigationPolicy(
      isForMainFrame: navigationAction.isForMainFrame,
      shouldOverrideUrlLoading: _configuration.shouldOverrideUrlLoading,
      url: url,
    );
  }

  Future<bool?> _handleCreateWindow(
    InAppWebViewController controller,
    CreateWindowAction createWindowAction,
  ) async {
    final url = createWindowAction.request.url?.toString() ?? '';

    return _configuration.onCreateWindow?.call(url);
  }
}
