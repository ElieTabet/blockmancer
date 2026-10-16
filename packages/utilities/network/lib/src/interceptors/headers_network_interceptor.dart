import 'package:network/src/error/network_error.br.dart';
import 'package:network/src/interceptors/network_interceptor.dart';
import 'package:network/src/models/network_request.br.dart';
import 'package:network/src/models/network_response.br.dart';

final class HeadersNetworkInterceptor implements NetworkInterceptor {
  final Map<String, String> headers;

  const HeadersNetworkInterceptor(this.headers);

  @override
  Future<void> onRequest(
    NetworkRequest request,
    NetworkRequestInterceptorHandler handler,
  ) async {
    if (headers.isEmpty) {
      handler.next(request);
      return;
    }

    final newHeaders = Map<String, String>.from(request.headers)
      ..addAll(headers);

    handler.next(request.copyWith(headers: newHeaders));
  }

  @override
  Future<void> onResponse(
    NetworkResponse<dynamic> response,
    NetworkResponseInterceptorHandler handler,
  ) async => handler.next(response);

  @override
  Future<void> onError(
    NetworkError error,
    NetworkErrorInterceptorHandler handler,
  ) async => handler.next(error);
}
