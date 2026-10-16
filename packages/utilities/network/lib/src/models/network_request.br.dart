import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_request.br.freezed.dart';

@freezed
abstract class NetworkRequest with _$NetworkRequest {
  const factory NetworkRequest({
    required String method,
    required String url,
    dynamic data,
    @Default({}) Map<String, dynamic> extra,
    @Default({}) Map<String, String> headers,
    Map<String, dynamic>? queryParameters,
  }) = _NetworkRequest;

  const NetworkRequest._();

  /// Sentinel for [NetworkErrorInterceptorHandler.retry] meaning: reuse the
  /// originating request, overlaying only [headers]. Recognised by the
  /// transport via the empty `url`.
  factory NetworkRequest.reuseOriginal({
    Map<String, String> headers = const {},
  }) => NetworkRequest(method: '', url: '', headers: headers);
}
