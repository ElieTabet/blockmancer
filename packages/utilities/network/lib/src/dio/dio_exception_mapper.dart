import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network/src/error/network_error.br.dart';

typedef DioExceptionMapper = NetworkError Function(DioException exception);

/// A 403 deliberately maps to [NetworkClientError], not [NetworkForbiddenError]
/// — the latter means "the session cannot be refreshed" and is raised only by
/// [AuthNetworkInterceptor].
NetworkError mapDioException(DioException e) {
  // An interceptor already decided what this failure is (auth converting a 401,
  // or a request-phase rejection). Re-mapping would throw that away.
  if (e.error is NetworkError) return e.error! as NetworkError;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return NetworkTimeoutError(
        timeout:
            e.requestOptions.connectTimeout ?? e.requestOptions.receiveTimeout,
        originalError: e,
      );
    case DioExceptionType.connectionError:
      if (e.error is SocketException) {
        return NetworkNoInternetError(reason: e.message, originalError: e);
      }

      return NetworkConnectionError(reason: e.message, originalError: e);
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 0;

      if (statusCode == HttpStatus.unauthorized) {
        return NetworkUnauthorizedError(
          data: e.response?.data,
          originalError: e,
        );
      }

      if (statusCode >= HttpStatus.internalServerError) {
        return NetworkServerError(
          statusCode: statusCode,
          data: e.response?.data,
          serverMessage: e.response?.statusMessage,
          originalError: e,
        );
      }

      return NetworkClientError(
        statusCode: statusCode,
        clientMessage: e.response?.statusMessage,
        data: e.response?.data,
        originalError: e,
      );
    case DioExceptionType.badCertificate:
      return NetworkConnectionError(
        reason: 'Bad certificate',
        originalError: e,
      );
    case DioExceptionType.cancel:
      return NetworkCancelledError(
        reason: e.message ?? 'Request cancelled',
        originalError: e,
      );
    case DioExceptionType.unknown:
      return NetworkUnknownError(originalError: e);
  }
}
