part of 'webview.dart';

extension _WebviewJsDialogHandler on _WebviewState {
  Future<JsAlertResponse?> _handleJsAlert(
    InAppWebViewController controller,
    JsAlertRequest jsAlertRequest,
  ) async {
    final message = jsAlertRequest.message ?? '';
    if (_configuration.onJsAlert == null) return null;

    final handled = await _configuration.onJsAlert!(message);

    return handled ? JsAlertResponse(handledByClient: true) : null;
  }

  Future<JsConfirmResponse?> _handleJsConfirm(
    InAppWebViewController controller,
    JsConfirmRequest jsConfirmRequest,
  ) async {
    final message = jsConfirmRequest.message ?? '';
    if (_configuration.onJsConfirm == null) return null;

    final confirmed = await _configuration.onJsConfirm!(message);

    return JsConfirmResponse(
      action: confirmed
          ? JsConfirmResponseAction.CONFIRM
          : JsConfirmResponseAction.CANCEL,
      handledByClient: true,
    );
  }

  Future<JsPromptResponse?> _handleJsPrompt(
    InAppWebViewController controller,
    JsPromptRequest jsPromptRequest,
  ) async {
    final message = jsPromptRequest.message ?? '';
    final defaultValue = jsPromptRequest.defaultValue ?? '';
    if (_configuration.onJsPrompt == null) return null;

    final result = await _configuration.onJsPrompt!(message, defaultValue);

    return JsPromptResponse(
      value: result ?? '',
      action: result != null
          ? JsPromptResponseAction.CONFIRM
          : JsPromptResponseAction.CANCEL,
      handledByClient: true,
    );
  }
}
