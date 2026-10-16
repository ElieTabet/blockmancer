import 'package:network/src/http/download_progress.dart';
import 'package:network/src/http/http_headers.dart';
import 'package:network/src/interceptors/network_interceptor.dart';
import 'package:network/src/models/network_response.br.dart';

abstract interface class HttpClient {
  HttpHeaders get headers;

  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<NetworkResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<NetworkResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<NetworkResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<void> delete(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  /// Raw bytes from a plain GET — an image, or anything else served as a file
  /// rather than as JSON.
  ///
  /// Separate from [downloadBytes] because that one is a POST: it was shaped
  /// around the publication bundle, whose endpoint takes a body. A GET-only
  /// route answers a POST with 405, so the verb is the difference and it is not
  /// one a caller can paper over.
  Future<NetworkResponse<List<int>>> getBytes(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  /// Raw bytes plus response headers — for `POST /publications/{id}/download`,
  /// the one endpoint that answers with `application/octet-stream` and carries
  /// the decryption key and size in headers rather than a JSON body.
  ///
  /// [onProgress] reports transfer progress. Completing [cancelOn] aborts the
  /// request in flight, surfacing as a [NetworkCancelledError] — a plain future
  /// rather than a token type, so a caller that may not depend on this package
  /// can still trigger it.
  Future<NetworkResponse<List<int>>> downloadBytes(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    ProgressFun? onProgress,
    Future<void>? cancelOn,
  });

  HttpClient copyWith({
    String? baseUrl,
    Map<String, dynamic>? headers,
    List<NetworkInterceptor>? networkInterceptors,
  });
}
