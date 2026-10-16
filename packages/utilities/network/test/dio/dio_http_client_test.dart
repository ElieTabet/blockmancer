import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

/// Stubs the transport at the adapter seam, so every test still runs through the
/// real Dio pipeline (options merging, the interceptor chain, response mapping)
/// rather than around it.
class _FakeAdapter implements HttpClientAdapter {
  Object? body;
  List<int>? bytes;

  /// Held open so a test can cancel a download that is genuinely in flight.
  Completer<void>? gate;

  final List<RequestOptions> received = [];
  Map<String, List<String>> responseHeaders = const {};
  int statusCode = 200;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    received.add(options);

    if (gate != null) await gate!.future;

    final payload = bytes ?? utf8.encode(jsonEncode(body ?? {'status': 'ok'}));

    return ResponseBody.fromBytes(
      payload,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [
          bytes != null ? Headers.jsonContentType : Headers.jsonContentType,
        ],
        ...responseHeaders,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

({DioHttpClient client, _FakeAdapter adapter}) _build({
  String baseUrl = 'http://localhost:8888/api/mobile/v1',
  List<NetworkInterceptor>? interceptors,
}) {
  final adapter = _FakeAdapter();
  final dio = Dio()..httpClientAdapter = adapter;

  return (
    client: DioHttpClient(
      dio: dio,
      baseUrl: baseUrl,
      networkInterceptors: interceptors,
    ),
    adapter: adapter,
  );
}

void main() {
  test('get issues a GET against the base URL and maps the response', () async {
    final sut = _build();
    sut.adapter.body = {'items': []};

    final response = await sut.client.get<Map<String, dynamic>>(
      '/publications',
      queryParameters: {'cursor': 'abc'},
    );

    final sent = sut.adapter.received.single;
    expect(sent.method, 'GET');
    expect(
      sent.uri.toString(),
      'http://localhost:8888/api/mobile/v1/publications?cursor=abc',
    );
    expect(response.statusCode, 200);
    expect(response.data, {'items': <dynamic>[]});
  });

  // A raw `+` decodes to a space server-side, so a value carrying one — a
  // Flutter `1.0.0+1` version, say — would be read as something else.
  test('a + in a query parameter goes out encoded as %2B', () async {
    final sut = _build();

    await sut.client.get<dynamic>(
      '/app-status',
      queryParameters: {'version': '1.0.0+1'},
    );

    expect(sut.adapter.received.single.uri.query, 'version=1.0.0%2B1');
  });

  test('a 503 maintenance body reaches the maintenance interceptor', () async {
    final heard = <String?>[];
    final sut = _build(
      interceptors: [MaintenanceNetworkInterceptor(heard.add)],
    );
    sut.adapter
      ..statusCode = 503
      ..body = {'error': 'maintenance', 'message': 'Back at noon'};

    await expectLater(
      sut.client.get<dynamic>('/publications'),
      throwsA(isA<NetworkServerError>()),
    );
    expect(heard, ['Back at noon']);
  });

  test('post, put and patch each send their verb and body', () async {
    for (final entry in {
      'POST': (DioHttpClient c) => c.post<dynamic>('/x', data: {'a': 1}),
      'PUT': (DioHttpClient c) => c.put<dynamic>('/x', data: {'a': 1}),
      'PATCH': (DioHttpClient c) => c.patch<dynamic>('/x', data: {'a': 1}),
    }.entries) {
      final sut = _build();

      await entry.value(sut.client);

      final sent = sut.adapter.received.single;
      expect(sent.method, entry.key);
      expect(sent.data, {'a': 1});
    }
  });

  // The verb is the whole reason this exists next to downloadBytes: the image
  // route is registered GET-only, and a POST to it is a 405 rather than a
  // picture.
  test('getBytes issues a GET and returns the raw bytes', () async {
    final sut = _build();
    sut.adapter.bytes = [1, 2, 3];

    final response = await sut.client.getBytes(
      'https://acme.example/api/mobile/v1/news-items/2/image',
    );

    expect(sut.adapter.received.single.method, 'GET');
    expect(response.data, [1, 2, 3]);
  });

  // An absolute URL is what the news image fetch passes, having resolved an
  // origin-relative path itself; Dio must not graft the base onto it.
  test('getBytes leaves an absolute url alone', () async {
    final sut = _build();
    sut.adapter.bytes = [1];

    await sut.client.getBytes('https://cdn.example/news/2.png');

    expect(
      sut.adapter.received.single.uri.toString(),
      'https://cdn.example/news/2.png',
    );
  });

  test('delete issues a DELETE', () async {
    final sut = _build();

    await sut.client.delete('/publications/1');

    expect(sut.adapter.received.single.method, 'DELETE');
  });

  test(
    'a failing response surfaces as a mapped NetworkError, not a DioException',
    () async {
      final sut = _build();
      sut.adapter.statusCode = 503;

      await expectLater(
        sut.client.get<dynamic>('/publications'),
        throwsA(isA<NetworkServerError>()),
      );
    },
  );

  // The download endpoint answers with octet-stream and carries the decryption
  // key and plaintext size in headers, so dropping headers here would silently
  // break it.
  test(
    'downloadBytes returns the raw bytes alongside the response headers',
    () async {
      final sut = _build();
      sut.adapter.bytes = [1, 2, 3, 4];
      sut.adapter.responseHeaders = {
        'x-publication-key': ['a2V5'],
        'x-publication-size': ['4096'],
        'x-publication-downloads': ['1'],
        'x-publication-download-limit': ['3'],
      };

      final response = await sut.client.downloadBytes(
        '/publications/1/download',
      );

      expect(sut.adapter.received.single.method, 'POST');
      expect(sut.adapter.received.single.responseType, ResponseType.bytes);
      expect(response.data, [1, 2, 3, 4]);
      expect(response.headers['x-publication-key'], 'a2V5');
      expect(response.headers['x-publication-size'], '4096');
      expect(response.headers['x-publication-download-limit'], '3');
    },
  );

  test('downloadBytes reports transfer progress', () async {
    final sut = _build();
    sut.adapter.bytes = [1, 2, 3, 4];
    sut.adapter.responseHeaders = {
      'content-length': ['4'],
    };

    final reports = <({int received, int total})>[];

    await sut.client.downloadBytes(
      '/publications/1/download',
      onProgress: (received, total) =>
          reports.add((received: received, total: total)),
    );

    expect(reports, isNotEmpty);
    expect(reports.last.received, 4);
    expect(reports.last.total, 4);
  });

  // Each attempt spends one of the member's download units, so abandoning a
  // transfer has to actually stop it rather than let the body finish arriving.
  test('an already-completed cancelOn cancels the request', () async {
    final sut = _build();

    await expectLater(
      sut.client.downloadBytes(
        '/publications/1/download',
        cancelOn: Future<void>.value(),
      ),
      throwsA(isA<NetworkCancelledError>()),
    );
  });

  test('a cancelOn completing mid-flight cancels the request', () async {
    final sut = _build();
    sut.adapter.gate = Completer<void>();
    final cancel = Completer<void>();

    final pending = sut.client.downloadBytes(
      '/publications/1/download',
      cancelOn: cancel.future,
    );

    cancel.complete();
    sut.adapter.gate!.complete();

    await expectLater(pending, throwsA(isA<NetworkCancelledError>()));
  });

  test('the interceptor chain runs on the way out', () async {
    final sut = _build(
      interceptors: const [
        HeadersNetworkInterceptor({'Accept': 'application/json'}),
      ],
    );

    await sut.client.get<dynamic>('/publications');

    expect(sut.adapter.received.single.headers['Accept'], 'application/json');
  });

  test('headers exposes the client-wide defaults', () {
    final adapter = _FakeAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final client = DioHttpClient(dio: dio, headers: {'X-App': 'foundation'});

    expect(client.headers.toMap()['X-App'], 'foundation');
  });

  test('copyWith returns a new client pointed at the new base URL', () async {
    final sut = _build();
    final copy = sut.client.copyWith(baseUrl: 'https://example.test/v2');

    expect(copy, isNot(same(sut.client)));

    await copy.get<dynamic>('/health');

    expect(
      sut.adapter.received.single.uri.toString(),
      'https://example.test/v2/health',
    );
  });
}
