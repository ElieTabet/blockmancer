import 'dart:async';

import 'package:dio/dio.dart';
import 'package:network/src/dio/dio_exception_mapper.dart';
import 'package:network/src/dio/dio_interceptor_adapter.dart';
import 'package:network/src/dio/proxy_http_client_adapter.dart';
import 'package:network/src/http/download_progress.dart';
import 'package:network/src/http/http_client.dart';
import 'package:network/src/http/http_headers.dart';
import 'package:network/src/interceptors/network_interceptor.dart';
import 'package:network/src/models/network_response.br.dart';

class DioHttpClient implements HttpClient {
  static const _connectTimeout = Duration(seconds: 10);

  late final Dio _dio;

  final DioExceptionMapper _exceptionMapper;

  @override
  HttpHeaders get headers => HttpHeaders.from(_dio.options.headers);

  DioHttpClient({
    required Dio dio,
    String? baseUrl,
    Map<String, dynamic>? headers,
    List<NetworkInterceptor>? networkInterceptors,
  }) : this.inject(
         dio: dio,
         baseUrl: baseUrl,
         headers: headers,
         networkInterceptors: networkInterceptors,
       );

  /// The seam tests use to supply a stubbed [Dio] or a custom mapper.
  DioHttpClient.inject({
    required Dio dio,
    String? baseUrl,
    DioExceptionMapper? exceptionMapper,
    Map<String, dynamic>? headers,
    List<NetworkInterceptor>? networkInterceptors,
  }) : _exceptionMapper = exceptionMapper ?? mapDioException {
    _dio = Dio(
      dio.options.copyWith(
        baseUrl: baseUrl ?? dio.options.baseUrl,
        headers: {...dio.options.headers, ...?headers},
      ),
    )..httpClientAdapter = dio.httpClientAdapter;

    if (networkInterceptors != null && networkInterceptors.isNotEmpty) {
      _dio.interceptors.add(
        DioToNetworkInterceptorAdapter(
          dio: _dio,
          exceptionMapper: _exceptionMapper,
          interceptors: networkInterceptors,
        ),
      );
    }

    _dio.interceptors.addAll(dio.interceptors);
  }

  /// [proxy] is `host:port` of an HTTP debugging proxy; null connects
  /// directly. It is applied to the transport rather than to a request,
  /// because Dart resolves the proxy when it opens the socket.
  factory DioHttpClient.create({
    String? baseUrl,
    Map<String, dynamic>? headers,
    List<NetworkInterceptor>? networkInterceptors,
    String? proxy,
  }) {
    // Without it an unreachable network never fails, and the shelf waiting to
    // fall back to what it has on disk waits forever. Connect only, never
    // receive: a request that never connected never reached the server, but one
    // cut off mid-response may have rotated the refresh token already — and
    // abandoning that answer is what later reads as token reuse.
    final dio = Dio(BaseOptions(connectTimeout: _connectTimeout));
    final adapter = proxyHttpClientAdapter(proxy);

    if (adapter != null) dio.httpClientAdapter = adapter;

    return DioHttpClient(
      dio: dio,
      baseUrl: baseUrl,
      headers: headers,
      networkInterceptors: networkInterceptors,
    );
  }

  @override
  HttpClient copyWith({
    String? baseUrl,
    Map<String, dynamic>? headers,
    List<NetworkInterceptor>? networkInterceptors,
  }) => DioHttpClient.inject(
    dio: _dio,
    baseUrl: baseUrl,
    headers: headers,
    networkInterceptors: networkInterceptors,
    exceptionMapper: _exceptionMapper,
  );

  @override
  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.toNetworkResponse();
    } on DioException catch (e) {
      throw _exceptionMapper(e);
    }
  }

  @override
  Future<NetworkResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.toNetworkResponse();
    } on DioException catch (e) {
      throw _exceptionMapper(e);
    }
  }

  @override
  Future<NetworkResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.toNetworkResponse();
    } on DioException catch (e) {
      throw _exceptionMapper(e);
    }
  }

  @override
  Future<NetworkResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.toNetworkResponse();
    } on DioException catch (e) {
      throw _exceptionMapper(e);
    }
  }

  @override
  Future<void> delete(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await _dio.delete<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _exceptionMapper(e);
    }
  }

  @override
  Future<NetworkResponse<List<int>>> getBytes(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers, responseType: ResponseType.bytes),
      );

      return response.toNetworkResponse();
    } on DioException catch (e) {
      throw _exceptionMapper(e);
    }
  }

  @override
  Future<NetworkResponse<List<int>>> downloadBytes(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    ProgressFun? onProgress,
    Future<void>? cancelOn,
  }) async {
    final token = cancelOn == null ? null : CancelToken();

    // Bridged onto the token, so a cancel arriving mid-flight aborts the socket
    // instead of waiting out the rest of the body.
    if (token != null) unawaited(cancelOn!.then((_) => token.cancel()));

    try {
      final response = await _dio.post<List<int>>(
        path,
        data: data,
        cancelToken: token,
        onReceiveProgress: onProgress,
        options: Options(headers: headers, responseType: ResponseType.bytes),
      );

      return response.toNetworkResponse();
    } on DioException catch (e) {
      throw _exceptionMapper(e);
    }
  }
}

extension NetworkResponseExtension<T> on Response<T> {
  NetworkResponse<T> toNetworkResponse() => NetworkResponse(
    statusCode: statusCode,
    data: data,
    headers: headers.map.map((k, v) => MapEntry(k, v.join(','))),
    statusMessage: statusMessage,
  );
}
