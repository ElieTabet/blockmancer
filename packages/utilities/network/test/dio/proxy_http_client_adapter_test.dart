import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  test('no adapter is built when no proxy is configured', () {
    expect(proxyHttpClientAdapter(null), isNull);
    expect(proxyHttpClientAdapter(''), isNull);
  });

  test('every request is handed to the proxy instead of the target', () async {
    final proxy = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => proxy.close(force: true));

    final received = <HttpRequest>[];

    unawaited(
      proxy.forEach((request) {
        received.add(request);
        request.response
          ..statusCode = 200
          ..headers.contentType = ContentType.json
          ..write('{"ok":true}');

        unawaited(request.response.close());
      }),
    );

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)))
      ..httpClientAdapter = proxyHttpClientAdapter('127.0.0.1:${proxy.port}')!;

    // TEST-NET-1 on a discard port: nothing can answer this, so a response
    // proves the request never left for the target.
    final response = await dio.get<Map<String, dynamic>>(
      'http://192.0.2.1:9/api/ping',
    );

    expect(response.data, {'ok': true});
    expect(received.single.uri.path, '/api/ping');
    expect(received.single.headers.host, '192.0.2.1');
    expect(received.single.headers.port, 9);
  });
}
