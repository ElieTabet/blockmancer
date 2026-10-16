import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

class _RecordingErrorHandler implements NetworkErrorInterceptorHandler {
  final List<NetworkError> nexted = [];
  final List<NetworkRequest> retried = [];

  @override
  void next(NetworkError error) => nexted.add(error);

  @override
  void resolve(NetworkResponse<dynamic> response) {}

  @override
  void retry(NetworkRequest request) => retried.add(request);
}

class _RecordingRequestHandler implements NetworkRequestInterceptorHandler {
  final List<NetworkRequest> nexted = [];

  @override
  void next(NetworkRequest request) => nexted.add(request);

  @override
  void reject(NetworkError error) {}

  @override
  void resolve(NetworkResponse<dynamic> response) {}
}

class _RecordingResponseHandler implements NetworkResponseInterceptorHandler {
  final List<NetworkResponse<dynamic>> nexted = [];

  @override
  void next(NetworkResponse<dynamic> response) => nexted.add(response);

  @override
  void reject(NetworkError error) {}
}

class _FakeAuthProvider implements AuthTokenProvider {
  int expiredCount = 0;
  String? token;

  _FakeAuthProvider({this.token});

  @override
  String? get accessToken => token;

  @override
  Future<void> onAuthenticationExpired() async => expiredCount++;
}

class _FakeRefreshableAuthProvider implements RefreshableAuthTokenProvider {
  final Object? refreshThrows;
  final String? refreshedToken;

  int expiredCount = 0;
  int refreshCount = 0;
  String? token;

  _FakeRefreshableAuthProvider({
    this.refreshThrows,
    this.refreshedToken,
    this.token,
  });

  @override
  String? get accessToken => token;

  @override
  Future<void> onAuthenticationExpired() async => expiredCount++;

  @override
  Future<String?> refreshToken(String? requestToken) async {
    refreshCount++;

    if (refreshThrows != null) throw refreshThrows!;

    return refreshedToken;
  }
}

NetworkUnauthorizedError _unauthorizedWith(String? token) =>
    NetworkUnauthorizedError(
      request: NetworkRequest(
        url: '/publications',
        method: 'GET',
        headers: token == null ? const {} : {'authorization': 'Bearer $token'},
      ),
    );

void main() {
  group('attaching the token', () {
    test('adds the bearer header when a token is available', () async {
      final interceptor = AuthNetworkInterceptor(
        _FakeAuthProvider(token: 'test-token'),
      );
      final handler = _RecordingRequestHandler();

      await interceptor.onRequest(
        const NetworkRequest(url: '/publications', method: 'GET'),
        handler,
      );

      expect(
        handler.nexted.single.headers['authorization'],
        'Bearer test-token',
      );
    });

    test('sends no authorization header when there is no token', () async {
      final interceptor = AuthNetworkInterceptor(_FakeAuthProvider());
      final handler = _RecordingRequestHandler();

      await interceptor.onRequest(
        const NetworkRequest(url: '/publications', method: 'GET'),
        handler,
      );

      expect(
        handler.nexted.single.headers.containsKey('authorization'),
        isFalse,
      );
    });
  });

  group('recovering from a 401', () {
    test('passes a non-401 through without touching the session', () async {
      final provider = _FakeRefreshableAuthProvider(token: 'token');
      final interceptor = AuthNetworkInterceptor(provider);
      final handler = _RecordingErrorHandler();

      await interceptor.onError(
        const NetworkConnectionError(reason: 'Connection failed'),
        handler,
      );

      expect(handler.nexted, hasLength(1));
      expect(handler.retried, isEmpty);
      expect(provider.refreshCount, 0);
      expect(provider.expiredCount, 0);
    });

    test(
      'refreshes once and retries when the token is genuinely stale',
      () async {
        final provider = _FakeRefreshableAuthProvider(
          token: 'old-token',
          refreshedToken: 'new-token',
        );
        final interceptor = AuthNetworkInterceptor(provider);
        final handler = _RecordingErrorHandler();

        await interceptor.onError(_unauthorizedWith('old-token'), handler);

        expect(provider.refreshCount, 1);
        expect(handler.retried, hasLength(1));
        expect(provider.expiredCount, 0);
      },
    );

    test(
      'expires the session and converts to forbidden when refresh is unsupported',
      () async {
        final provider = _FakeAuthProvider(token: 'token');
        final interceptor = AuthNetworkInterceptor(provider);
        final handler = _RecordingErrorHandler();

        await interceptor.onError(_unauthorizedWith('token'), handler);

        expect(provider.expiredCount, 1);
        expect(handler.nexted.single, isA<NetworkForbiddenError>());
        expect(handler.retried, isEmpty);
      },
    );

    // Race 1: a sibling request already refreshed while this one was in flight.
    test(
      'replays without refreshing or logging out when a sibling already refreshed',
      () async {
        final provider = _FakeRefreshableAuthProvider(token: 'new-token');
        final interceptor = AuthNetworkInterceptor(provider);
        final handler = _RecordingErrorHandler();

        await interceptor.onError(_unauthorizedWith('old-token'), handler);

        expect(handler.retried, hasLength(1));
        expect(provider.refreshCount, 0);
        expect(provider.expiredCount, 0);
      },
    );

    // Race 2: the freshly refreshed token is itself rejected — must not loop.
    test('refreshes once, then signs out rather than looping', () async {
      final provider = _FakeRefreshableAuthProvider(
        token: 'new-token',
        refreshedToken: 'new-token',
      );
      final interceptor = AuthNetworkInterceptor(provider);
      final handler = _RecordingErrorHandler();
      final error = _unauthorizedWith('new-token');

      await interceptor.onError(error, handler);
      await interceptor.onError(error, handler);

      expect(provider.refreshCount, 1);
      expect(handler.retried, hasLength(1));
      expect(provider.expiredCount, 1);
    });

    // Race 3: the refresh call itself failed transiently — not a rejection.
    test('keeps the session when the refresh call throws', () async {
      final provider = _FakeRefreshableAuthProvider(
        token: 'token',
        refreshThrows: const NetworkTimeoutError(),
      );
      final interceptor = AuthNetworkInterceptor(provider);
      final handler = _RecordingErrorHandler();

      await interceptor.onError(_unauthorizedWith('token'), handler);

      expect(handler.nexted, hasLength(1));
      expect(handler.retried, isEmpty);
      expect(provider.expiredCount, 0);
    });

    test('signs out when the server rejects the refresh', () async {
      final provider = _FakeRefreshableAuthProvider(token: 'token');
      final interceptor = AuthNetworkInterceptor(provider);
      final handler = _RecordingErrorHandler();

      await interceptor.onError(_unauthorizedWith('token'), handler);

      expect(provider.refreshCount, 1);
      expect(provider.expiredCount, 1);
      expect(handler.retried, isEmpty);
    });

    test(
      'a success clears the loop guard so a later 401 can refresh again',
      () async {
        final provider = _FakeRefreshableAuthProvider(
          token: 'new-token',
          refreshedToken: 'new-token',
        );
        final interceptor = AuthNetworkInterceptor(provider);
        final errorHandler = _RecordingErrorHandler();
        final error = _unauthorizedWith('new-token');

        await interceptor.onError(error, errorHandler);
        await interceptor.onResponse(
          const NetworkResponse<dynamic>(statusCode: 200),
          _RecordingResponseHandler(),
        );
        await interceptor.onError(error, errorHandler);

        expect(provider.refreshCount, 2);
        expect(provider.expiredCount, 0);
      },
    );
  });
}
