import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

class _RecordingRequestHandler implements NetworkRequestInterceptorHandler {
  final List<NetworkRequest> nexted = [];

  @override
  void next(NetworkRequest request) => nexted.add(request);

  @override
  void reject(NetworkError error) {}

  @override
  void resolve(NetworkResponse<dynamic> response) {}
}

class _RecordingErrorHandler implements NetworkErrorInterceptorHandler {
  final List<NetworkError> nexted = [];

  @override
  void next(NetworkError error) => nexted.add(error);

  @override
  void resolve(NetworkResponse<dynamic> response) {}

  @override
  void retry(NetworkRequest request) {}
}

class _RecordingResponseHandler implements NetworkResponseInterceptorHandler {
  final List<NetworkResponse<dynamic>> nexted = [];

  @override
  void next(NetworkResponse<dynamic> response) => nexted.add(response);

  @override
  void reject(NetworkError error) {}
}

void main() {
  test(
    'merges its headers over the request without dropping existing ones',
    () async {
      const interceptor = HeadersNetworkInterceptor({
        'Accept': 'application/json',
      });
      final handler = _RecordingRequestHandler();

      await interceptor.onRequest(
        const NetworkRequest(
          url: '/publications',
          method: 'GET',
          headers: {'authorization': 'Bearer t'},
        ),
        handler,
      );

      expect(handler.nexted.single.headers, {
        'authorization': 'Bearer t',
        'Accept': 'application/json',
      });
    },
  );

  test(
    'passes the request through untouched when it carries no headers',
    () async {
      const interceptor = HeadersNetworkInterceptor({});
      final handler = _RecordingRequestHandler();
      const request = NetworkRequest(url: '/publications', method: 'GET');

      await interceptor.onRequest(request, handler);

      expect(handler.nexted.single, request);
    },
  );

  test('passes responses and errors straight through', () async {
    const interceptor = HeadersNetworkInterceptor({
      'Accept': 'application/json',
    });
    final responseHandler = _RecordingResponseHandler();
    final errorHandler = _RecordingErrorHandler();

    await interceptor.onResponse(
      const NetworkResponse<dynamic>(statusCode: 200),
      responseHandler,
    );
    await interceptor.onError(const NetworkUnknownError(), errorHandler);

    expect(responseHandler.nexted, hasLength(1));
    expect(errorHandler.nexted, hasLength(1));
  });
}
