import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

/// Answers with a scripted sequence of status codes so a retry can be observed
/// as a second call that succeeds where the first failed.
class _ScriptedAdapter implements HttpClientAdapter {
  final List<int> statuses;
  final List<RequestOptions> received = [];

  _ScriptedAdapter(this.statuses);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    received.add(options);

    final status = received.length <= statuses.length
        ? statuses[received.length - 1]
        : statuses.last;

    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode({'status': 'ok'})),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _RefreshingAuthProvider implements RefreshableAuthTokenProvider {
  int expiredCount = 0;
  int refreshCount = 0;
  String? token;

  _RefreshingAuthProvider({this.token});

  @override
  String? get accessToken => token;

  @override
  Future<void> onAuthenticationExpired() async => expiredCount++;

  @override
  Future<String?> refreshToken(String? requestToken) async {
    refreshCount++;
    token = 'fresh-token';

    return token;
  }
}

/// Records what reached each phase and passes everything through.
class _SpyInterceptor implements NetworkInterceptor {
  final List<NetworkError> errors = [];
  final List<NetworkRequest> requests = [];
  final List<NetworkResponse<dynamic>> responses = [];

  @override
  Future<void> onRequest(
    NetworkRequest request,
    NetworkRequestInterceptorHandler handler,
  ) async {
    requests.add(request);
    handler.next(request);
  }

  @override
  Future<void> onResponse(
    NetworkResponse<dynamic> response,
    NetworkResponseInterceptorHandler handler,
  ) async {
    responses.add(response);
    handler.next(response);
  }

  @override
  Future<void> onError(
    NetworkError error,
    NetworkErrorInterceptorHandler handler,
  ) async {
    errors.add(error);
    handler.next(error);
  }
}

DioHttpClient _client(
  _ScriptedAdapter adapter,
  List<NetworkInterceptor> interceptors,
) => DioHttpClient(
  dio: Dio()..httpClientAdapter = adapter,
  baseUrl: 'http://localhost:8888/api/mobile/v1',
  networkInterceptors: interceptors,
);

class _GuestAuthProvider implements AuthTokenProvider {
  int expiredCount = 0;

  @override
  String? get accessToken => null;

  @override
  Future<void> onAuthenticationExpired() async => expiredCount++;
}

void main() {
  test('with no interceptors the request passes straight through', () async {
    final adapter = _ScriptedAdapter([200]);

    await _client(adapter, []).get<dynamic>('/health');

    expect(adapter.received, hasLength(1));
  });

  test('all three phases see the traffic', () async {
    final spy = _SpyInterceptor();
    final adapter = _ScriptedAdapter([200]);

    await _client(adapter, [spy]).get<dynamic>('/health');

    expect(spy.requests, hasLength(1));
    expect(spy.responses, hasLength(1));
    expect(spy.errors, isEmpty);
  });

  test(
    'a failure reaches the error phase carrying the failing request',
    () async {
      final spy = _SpyInterceptor();
      final adapter = _ScriptedAdapter([503]);

      await expectLater(
        _client(adapter, [spy]).get<dynamic>('/publications'),
        throwsA(isA<NetworkServerError>()),
      );

      // Without the attached request the auth interceptor cannot compare tokens.
      expect(spy.errors.single.request, isNotNull);
      expect(spy.errors.single.request!.url, contains('/publications'));
    },
  );

  // The whole point of the error-phase retry: a 401 refreshes once and the
  // replayed request carries the new token, through the real Dio pipeline.
  test(
    'a 401 refreshes and replays the request with the fresh token',
    () async {
      final provider = _RefreshingAuthProvider(token: 'stale-token');
      final adapter = _ScriptedAdapter([401, 200]);

      final response = await _client(adapter, [
        AuthNetworkInterceptor(provider),
      ]).get<Map<String, dynamic>>('/publications');

      expect(provider.refreshCount, 1);
      expect(provider.expiredCount, 0);
      expect(adapter.received, hasLength(2));
      expect(
        adapter.received.first.headers['authorization'],
        'Bearer stale-token',
      );
      expect(
        adapter.received.last.headers['authorization'],
        'Bearer fresh-token',
      );
      expect(response.statusCode, 200);
    },
  );

  test('query parameters survive the chain without duplication', () async {
    final adapter = _ScriptedAdapter([200]);

    await _client(adapter, [
      _SpyInterceptor(),
    ]).get<dynamic>('/publications', queryParameters: {'cursor': 'abc'});

    final uri = adapter.received.single.uri;
    expect(uri.queryParametersAll['cursor'], ['abc']);
    // A trailing `?` would make Dio re-append the real query as `?&…`, which
    // strict gateways reject.
    expect(uri.toString(), isNot(contains('?&')));
  });

  test('query parameters embedded in the path are preserved', () async {
    final adapter = _ScriptedAdapter([200]);

    await _client(adapter, [
      _SpyInterceptor(),
    ]).get<dynamic>('/publications?limit=50');

    expect(adapter.received.single.uri.queryParametersAll['limit'], ['50']);
  });

  // An interceptor replacing the error must reach the caller. Forwarding the
  // original Dio exception here instead would silently discard the
  // substitution, and the caller would see a bare 401 with no session decision
  // having been surfaced.
  test(
    'an error replaced by an interceptor is what the caller receives',
    () async {
      final provider = _GuestAuthProvider();
      final adapter = _ScriptedAdapter([401]);

      await expectLater(
        _client(adapter, [
          AuthNetworkInterceptor(provider),
        ]).get<dynamic>('/publications'),
        throwsA(isA<NetworkForbiddenError>()),
      );

      expect(provider.expiredCount, 1);
    },
  );

  test('the replaced error still carries the response envelope', () async {
    final adapter = _ScriptedAdapter([401]);

    try {
      await _client(adapter, [
        AuthNetworkInterceptor(_GuestAuthProvider()),
      ]).get<dynamic>('/publications');
      fail('expected a NetworkForbiddenError');
    } on NetworkForbiddenError catch (e) {
      expect(e.data, {'status': 'ok'});
    }
  });
}
