import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

// copyWithRequest is implemented once per variant, so the failure mode is a
// copy-paste that drops a variant's own field while still compiling. The auth
// interceptor depends on the request surviving that copy.
void main() {
  const request = NetworkRequest(url: '/publications', method: 'GET');

  test('every variant attaches the request and keeps its own fields', () {
    final errors = <NetworkError>[
      const NetworkTimeoutError(
        timeout: Duration(seconds: 7),
        originalError: 'e',
      ),
      const NetworkConnectionError(reason: 'refused', originalError: 'e'),
      const NetworkNoInternetError(reason: 'offline', originalError: 'e'),
      const NetworkServerError(
        statusCode: 503,
        data: {'error': 'internal_error'},
        serverMessage: 'boom',
        originalError: 'e',
      ),
      const NetworkClientError(
        statusCode: 404,
        clientMessage: 'missing',
        data: {'error': 'forbidden'},
        originalError: 'e',
      ),
      const NetworkForbiddenError(
        data: {'error': 'forbidden'},
        originalError: 'e',
      ),
      const NetworkUnauthorizedError(
        data: {'error': 'unauthorized'},
        originalError: 'e',
      ),
      const NetworkDecodingError(originalError: 'e'),
      const NetworkUnknownError(originalError: 'e'),
      const NetworkCancelledError(reason: 'cancelled', originalError: 'e'),
    ];

    for (final error in errors) {
      final copy = error.copyWithRequest(request);

      expect(
        copy.request,
        request,
        reason: '${error.runtimeType} lost the request',
      );
      expect(
        copy.runtimeType,
        error.runtimeType,
        reason: '${error.runtimeType} changed type',
      );
      expect(
        copy.originalError,
        'e',
        reason: '${error.runtimeType} lost originalError',
      );
      expect(
        copy.message,
        error.message,
        reason: '${error.runtimeType} lost a field its message reads',
      );
    }
  });

  test('messages fall back when the optional detail is absent', () {
    expect(const NetworkTimeoutError().message, 'Request timed out');
    expect(
      const NetworkTimeoutError(timeout: Duration(seconds: 3)).message,
      'Request timed out after 3s',
    );
    expect(const NetworkConnectionError().message, 'Connection failed');
    expect(const NetworkNoInternetError().message, 'No internet connection');
    expect(
      const NetworkServerError(statusCode: 500).message,
      'Server error: 500',
    );
    expect(
      const NetworkClientError(statusCode: 404).message,
      'Client error: 404',
    );
    expect(const NetworkCancelledError().message, 'Request cancelled');
  });

  // Freezed's generated toString dumps every field, and `request` carries the
  // headers. Timber renders an exception through toString, so generating one
  // would print the bearer token of every failed authenticated call straight
  // into the debug log — silently, because nothing else would look wrong. That
  // is why the union is annotated `@Freezed(toStringOverride: false)`, and this
  // is what stops the annotation being "tidied away" later.
  test('toString carries the message and never the request', () {
    const error = NetworkUnauthorizedError(
      data: {'error': 'unauthorized'},
      request: NetworkRequest(
        method: 'GET',
        url: '/publications',
        headers: {'authorization': 'Bearer super-secret-token'},
      ),
    );

    expect(error.toString(), 'NetworkError: Unauthorized');
    expect(error.toString(), isNot(contains('super-secret-token')));
    expect(error.toString(), isNot(contains('authorization')));
  });
}
