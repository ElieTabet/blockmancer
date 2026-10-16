import 'package:freezed_annotation/freezed_annotation.dart';

part 'webview_errors.br.freezed.dart';

@freezed
sealed class WebviewError with _$WebviewError {
  const factory WebviewError.runtimeError({
    required String description,
    required bool isMainFrame,
    required String requestUrl,
  }) = RuntimeWebviewError;

  const factory WebviewError.httpError({
    required bool isMainFrame,
    required String requestUrl,
    int? statusCode,
  }) = HttpWebviewError;
}
