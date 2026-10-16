import 'dart:async';
import 'dart:convert';

typedef JavascriptBridgeFromJson<T extends Object?> =
    T Function(Map<String, dynamic> json);

class JavascriptBridge<T extends Object?> {
  final String name;
  final FutureOr<Object?> Function(T data) _onParsed;
  final JavascriptBridgeFromJson<T> _parser;
  final FutureOr<Object?> Function(Object? error, StackTrace? stackTrace)?
  _onError;

  /// Fire-and-forget bridge: the handler reacts to the message but does not
  /// return anything to the web page.
  JavascriptBridge({
    required this.name,
    required void Function(T data) onParsed,
    required JavascriptBridgeFromJson<T> parser,
    void Function(Object? error, StackTrace? stackTrace)? onError,
  }) : _onParsed = onParsed,
       _parser = parser,
       _onError = onError;

  /// Async bridge: the handler may return a value (or a [Future]) that is
  /// delivered back to the web page as the result of its `callHandler` call.
  ///
  /// Use this for request/response bridges where the web page awaits the native
  /// answer instead of receiving it through a separate callback.
  JavascriptBridge.async({
    required this.name,
    required FutureOr<Object?> Function(T data) onParsed,
    required JavascriptBridgeFromJson<T> parser,
    FutureOr<Object?> Function(Object? error, StackTrace? stackTrace)? onError,
  }) : _onParsed = onParsed,
       _parser = parser,
       _onError = onError;

  /// Decodes [message], runs the handler, and returns whatever the handler (or
  /// its error callback) produces so it can be forwarded back to the web page.
  ///
  /// Fire-and-forget bridges return `null`; their side effects still run
  /// synchronously before the returned future completes.
  Future<Object?> onMessageReceived(String message) async {
    final trimmed = message.trim();

    // A fire-and-forget signal can arrive with no payload (empty message) or an
    // explicit `null`; deliver it as a null parse when the bridge accepts a
    // nullable payload, instead of mistaking it for a decode error.
    if ((trimmed.isEmpty || trimmed == 'null') && null is T) {
      return _onParsed(null as T);
    }

    final decodedMap = _decodeJavascriptBridgeMessageToMap(trimmed);

    if (decodedMap == null) {
      return _onError?.call(null, null);
    }

    try {
      return await _onParsed(_parser(decodedMap));
    } catch (error, stackTrace) {
      return _onError?.call(error, stackTrace);
    }
  }

  Map<String, dynamic>? _decodeJavascriptBridgeMessageToMap(String trimmed) {
    if (trimmed.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(trimmed) as Map<String, dynamic>?;
    } catch (_) {
      try {
        return jsonDecode(_quoteBareJsonKeys(trimmed)) as Map<String, dynamic>?;
      } catch (_) {
        return null;
      }
    }
  }
}

/// Quotes the bare keys and values of a JavaScript object literal so `jsonDecode`
/// can read it — a page that hands its payload to `callHandler` unstringified sends
/// `{key: value}`, which is valid JS and invalid JSON. Booleans are left alone, so
/// they stay booleans rather than becoming the strings `"true"` / `"false"`.
String _quoteBareJsonKeys(String value) =>
    value.replaceAllMapped(RegExp(r'(?<=\{| )\w(.*?)(?=\: |, |})'), (match) {
      final matched = match.group(0);

      if (matched == 'true' || matched == 'false') {
        return matched!;
      }

      return '"$matched"';
    });
