import 'package:network/src/error/network_error.br.dart';
import 'package:network/src/models/network_request.br.dart';
import 'package:network/src/models/network_response.br.dart';

abstract class NetworkRequestInterceptorHandler {
  void next(NetworkRequest request);
  void reject(NetworkError error);
  void resolve(NetworkResponse<dynamic> response);
}

abstract class NetworkResponseInterceptorHandler {
  void next(NetworkResponse<dynamic> response);
  void reject(NetworkError error);
}

abstract class NetworkErrorInterceptorHandler {
  void next(NetworkError error);
  void resolve(NetworkResponse<dynamic> response);

  /// Re-issues the request and resolves with the new result. Passing
  /// [NetworkRequest.reuseOriginal] means "resend the original, merging only
  /// the supplied headers" — the transport re-runs the request phase, so an
  /// interceptor that rewrites headers there sees the retry too.
  void retry(NetworkRequest request);
}

/// Chain-of-responsibility hook over the three transport phases. Implementations
/// must call exactly one handler method per invocation.
abstract interface class NetworkInterceptor {
  Future<void> onError(
    NetworkError error,
    NetworkErrorInterceptorHandler handler,
  );
  Future<void> onRequest(
    NetworkRequest request,
    NetworkRequestInterceptorHandler handler,
  );
  Future<void> onResponse(
    NetworkResponse<dynamic> response,
    NetworkResponseInterceptorHandler handler,
  );
}
