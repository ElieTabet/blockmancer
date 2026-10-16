/// Reduces a webview URL to the part that identifies the page, for logging.
///
/// A webview URL can carry credentials or reader identity in its query string, so
/// logging a navigation verbatim would put them in the logs. Scheme, host and path
/// are kept — enough to tell which page was navigated to — while the query and
/// fragment, which is where secrets live, are dropped.
String redactUrlForLog(String url) {
  final uri = Uri.tryParse(url);

  if (uri == null) return '<unparseable url>';

  return Uri(
    scheme: uri.scheme.isEmpty ? null : uri.scheme,
    host: uri.host.isEmpty ? null : uri.host,
    path: uri.path,
    port: uri.hasPort ? uri.port : null,
  ).toString();
}
