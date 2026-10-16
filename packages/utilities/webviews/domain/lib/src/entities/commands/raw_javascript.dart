/// A raw JavaScript expression passed as a `FunctionWebviewCommand` argument
/// **verbatim**, without the string quoting/escaping applied to plain `String`s.
///
/// Use this when the web page expects the argument to be a JS value rather than a
/// string literal — e.g. forwarding a JSON payload so the page receives an object.
/// The wrapped [code] is the caller's responsibility to be valid, safe JavaScript.
class RawJavascript {
  final String code;

  const RawJavascript(this.code);
}
