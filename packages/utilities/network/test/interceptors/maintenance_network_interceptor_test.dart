import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';
import 'package:network/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

class _RecordingErrorHandler implements NetworkErrorInterceptorHandler {
  final List<NetworkError> nexted = [];

  @override
  void next(NetworkError error) => nexted.add(error);

  @override
  void resolve(NetworkResponse<dynamic> response) {}

  @override
  void retry(NetworkRequest request) {}
}

void main() {
  late List<String?> heard;
  late _RecordingErrorHandler handler;
  late MaintenanceNetworkInterceptor interceptor;

  setUp(() {
    heard = [];
    handler = _RecordingErrorHandler();
    interceptor = MaintenanceNetworkInterceptor(heard.add);
  });

  group('Given a 503 carrying the maintenance envelope', () {
    test(
      'When it passes, Then the message is told and the error goes on',
      () async {
        const error = NetworkServerError(
          statusCode: 503,
          data: {'error': 'maintenance', 'message': 'Back at noon'},
        );

        await interceptor.onError(error, handler);

        expect(heard, ['Back at noon']);
        expect(handler.nexted, [error]);
      },
    );

    test('When the message is null, Then null is told', () async {
      await interceptor.onError(
        const NetworkServerError(
          statusCode: 503,
          data: {'error': 'maintenance', 'message': null},
        ),
        handler,
      );

      expect(heard, [null]);
    });

    test('When the message is not text, Then null is told', () async {
      await interceptor.onError(
        const NetworkServerError(
          statusCode: 503,
          data: {'error': 'maintenance', 'message': 42},
        ),
        handler,
      );

      expect(heard, [null]);
    });
  });

  group('Given a failure that is not maintenance', () {
    for (final (label, error) in [
      (
        'a 503 with another error',
        const NetworkServerError(statusCode: 503, data: {'error': 'down'}),
      ),
      ('a 503 with no body', const NetworkServerError(statusCode: 503)),
      (
        'a 503 with a text body',
        const NetworkServerError(statusCode: 503, data: 'maintenance'),
      ),
      (
        'a 500 saying maintenance',
        const NetworkServerError(
          statusCode: 500,
          data: {'error': 'maintenance'},
        ),
      ),
      (
        'a 4xx',
        const NetworkClientError(
          statusCode: 422,
          data: {'error': 'maintenance'},
        ),
      ),
      ('no connection', const NetworkNoInternetError()),
    ]) {
      test('When $label passes, Then nothing is told and it goes on', () async {
        await interceptor.onError(error, handler);

        expect(heard, isEmpty);
        expect(handler.nexted, [error]);
      });
    }
  });

  test('Given no binding, When the slot is read, Then it is a no-op', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(di.networkMaintenanceProvider)('x'),
      returnsNormally,
    );
  });
}
