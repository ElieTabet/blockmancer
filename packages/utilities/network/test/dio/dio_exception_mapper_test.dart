import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

final _options = RequestOptions(path: '/publications');

DioException _exception(
  DioExceptionType type, {
  Object? error,
  Response<dynamic>? response,
}) => DioException(
  requestOptions: _options,
  type: type,
  error: error,
  response: response,
  message: 'boom',
);

Response<dynamic> _response(int statusCode, {dynamic data}) =>
    Response<dynamic>(
      requestOptions: _options,
      statusCode: statusCode,
      statusMessage: 'status',
      data: data,
    );

void main() {
  test('every timeout type maps to a timeout error keeping the duration', () {
    final options = RequestOptions(
      path: '/publications',
      connectTimeout: const Duration(seconds: 9),
    );

    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.transformTimeout,
    ]) {
      final result = mapDioException(
        DioException(requestOptions: options, type: type),
      );

      expect(result, isA<NetworkTimeoutError>(), reason: '$type');
      expect(
        (result as NetworkTimeoutError).timeout,
        const Duration(seconds: 9),
      );
    }
  });

  test(
    'a socket failure maps to no-internet rather than a generic connection error',
    () {
      final result = mapDioException(
        _exception(
          DioExceptionType.connectionError,
          error: const SocketException('failed host lookup'),
        ),
      );

      expect(result, isA<NetworkNoInternetError>());
      expect((result as NetworkNoInternetError).reason, 'boom');
    },
  );

  test('a non-socket connection failure maps to a connection error', () {
    final result = mapDioException(
      DioException(
        requestOptions: _options,
        type: DioExceptionType.connectionError,
        message: 'boom',
      ),
    );

    expect(result, isA<NetworkConnectionError>());
  });

  test('a 401 maps to unauthorized and carries the decoded body', () {
    final result = mapDioException(
      _exception(
        DioExceptionType.badResponse,
        response: _response(401, data: {'error': 'unauthorized'}),
      ),
    );

    expect(result, isA<NetworkUnauthorizedError>());
    expect((result as NetworkUnauthorizedError).data, {
      'error': 'unauthorized',
    });
  });

  test('a 5xx maps to a server error', () {
    final result = mapDioException(
      _exception(
        DioExceptionType.badResponse,
        response: _response(503, data: {'error': 'internal_error'}),
      ),
    );

    expect(result, isA<NetworkServerError>());
    expect((result as NetworkServerError).statusCode, 503);
    expect(result.data, {'error': 'internal_error'});
  });

  test('a 4xx maps to a client error — including 403', () {
    for (final status in [403, 404, 422, 429]) {
      final result = mapDioException(
        _exception(DioExceptionType.badResponse, response: _response(status)),
      );

      // 403 deliberately stays a client error: NetworkForbiddenError means
      // "this session cannot be refreshed" and is raised only by the auth
      // interceptor.
      expect(result, isA<NetworkClientError>(), reason: '$status');
      expect((result as NetworkClientError).statusCode, status);
    }
  });

  test('a bad certificate maps to a connection error', () {
    final result = mapDioException(_exception(DioExceptionType.badCertificate));

    expect(result, isA<NetworkConnectionError>());
    expect((result as NetworkConnectionError).reason, 'Bad certificate');
  });

  test('a cancellation maps to cancelled, unwrapping an existing one', () {
    expect(
      mapDioException(_exception(DioExceptionType.cancel)),
      isA<NetworkCancelledError>(),
    );

    const original = NetworkCancelledError(reason: 'user navigated away');

    expect(
      mapDioException(_exception(DioExceptionType.cancel, error: original)),
      same(original),
    );
  });

  test('anything else maps to unknown', () {
    expect(
      mapDioException(_exception(DioExceptionType.unknown)),
      isA<NetworkUnknownError>(),
    );
  });

  test('the original exception is preserved for diagnostics', () {
    final exception = _exception(DioExceptionType.unknown);

    expect(mapDioException(exception).originalError, same(exception));
  });
}
