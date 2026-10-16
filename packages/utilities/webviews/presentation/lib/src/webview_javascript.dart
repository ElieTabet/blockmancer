part of 'webview.dart';

extension _WebviewJavascript on _WebviewState {
  void _registerJavascriptBridges(InAppWebViewController controller) {
    for (final bridge in _configuration.javascriptBridges) {
      Timber.d(
        tag: packageName,
        logMessage: 'Registering JS bridge: ${bridge.name}',
      );
      controller.addJavaScriptHandler(
        handlerName: bridge.name,
        callback: (args) {
          // InAppWebView hands us the decoded argument (a Map/List for object
          // payloads). Serialize it back to valid JSON — `toString()` would emit
          // an unquoted, lossy form that breaks on nested arrays/objects.
          final first = args.isNotEmpty ? args.first : null;
          final message = switch (first) {
            null => '',
            final String string => string,
            _ => jsonEncode(first),
          };

          // Returning the future lets InAppWebView resolve the web page's
          // `callHandler` promise with the handler result. Fire-and-forget
          // bridges resolve it with null.
          return bridge.onMessageReceived(message);
        },
      );
    }

    _registerContentHeightHandler(controller);
  }

  void _unregisterJavascriptBridges(InAppWebViewController controller) {
    for (final bridge in _configuration.javascriptBridges) {
      controller.removeJavaScriptHandler(handlerName: bridge.name);
      Timber.d(
        tag: packageName,
        logMessage: 'Unregistering JS bridge: ${bridge.name}',
      );
    }

    controller.removeJavaScriptHandler(handlerName: _contentHeightHandlerName);
  }

  /// The counterpart of the measuring script, registered here so it is torn down with the bridges: a
  /// kept-alive webview keeps its handlers, and its page goes on reporting into whatever host it was
  /// last attached to.
  void _registerContentHeightHandler(InAppWebViewController controller) {
    final onContentHeightChanged = widget.onContentHeightChanged;
    if (onContentHeightChanged == null) return;

    controller.addJavaScriptHandler(
      handlerName: _contentHeightHandlerName,
      callback: (arguments) {
        final height = arguments.firstOrNull;
        if (height is num && height > 0) {
          onContentHeightChanged(height.toDouble());
        }

        return null;
      },
    );
  }
}
