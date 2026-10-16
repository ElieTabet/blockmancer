import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'webview_ui_configuration.br.freezed.dart';

@freezed
abstract class WebViewUiConfiguration with _$WebViewUiConfiguration {
  @Assert(
    '(initialUrlRequest != null ? 1 : 0) + (initialData != null ? 1 : 0) == 1',
    'Exactly one of initialUrlRequest or initialData must be set.',
  )
  const factory WebViewUiConfiguration({
    URLRequest? initialUrlRequest,
    InAppWebViewInitialData? initialData,
  }) = _WebViewUiConfiguration;
}
