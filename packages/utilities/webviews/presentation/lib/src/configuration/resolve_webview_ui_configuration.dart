import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webviews_domain/webviews_domain.dart';
import 'package:webviews_presentation/src/configuration/webview_ui_configuration.br.dart';

/// Turns a declarative [WebViewConfiguration] into what the engine is actually started with.
///
/// Returns the value directly when the configuration already carries one, so a plain-`String`
/// URL never costs the widget a loading frame; only a configuration built around a [Future]
/// resolves asynchronously.
FutureOr<WebViewUiConfiguration> resolveWebviewUiConfiguration(
  WebViewConfiguration configuration,
) => switch (configuration) {
  WebViewConfigurationFromUrl() => _fromUrl(configuration.url),
  WebViewConfigurationFromData() => _fromData(configuration),
  WebViewConfigurationFromLocalFile() => _urlConfiguration(
    Uri.file(configuration.filePath).toString(),
  ),
};

FutureOr<WebViewUiConfiguration> _fromUrl(FutureOr<String> url) =>
    url is String ? _urlConfiguration(url) : url.then(_urlConfiguration);

WebViewUiConfiguration _urlConfiguration(String url) =>
    WebViewUiConfiguration(initialUrlRequest: URLRequest(url: WebUri(url)));

FutureOr<WebViewUiConfiguration> _fromData(
  WebViewConfigurationFromData configuration,
) {
  final baseUrl = configuration.baseUrl;
  final htmlData = configuration.htmlData;

  WebViewUiConfiguration build(String data) => WebViewUiConfiguration(
    initialData: InAppWebViewInitialData(
      data: data,
      baseUrl: baseUrl != null ? WebUri(baseUrl) : null,
    ),
  );

  return htmlData is String ? build(htmlData) : htmlData.then(build);
}
