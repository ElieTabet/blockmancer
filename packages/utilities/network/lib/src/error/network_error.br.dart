import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:network/src/models/network_request.br.dart';

part 'network_error.br.freezed.dart';

/// Every failure the transport can surface, as a closed set so callers can
/// switch exhaustively. [request] is attached by the transport's error phase —
/// [AuthNetworkInterceptor] reads it to compare the failing request's token
/// against the latest one.
///
/// **The `toString` at the bottom is a safety measure, not a nicety.** Freezed's
/// generated one dumps every field, and [request] carries the headers —
/// `authorization: Bearer …` among them. `Timber` renders an exception through
/// its `toString`, so a generated one would print the bearer token of every
/// failed authenticated call straight into the debug log, silently. Defining it
/// here is what stops freezed generating one at all.
///
/// `toStringOverride: false` is the backstop for the day someone deletes that
/// method: without the flag, removing it hands the field dump straight back;
/// with it, the worst case is an uninformative `Instance of …`. Belt and
/// braces on the same hazard, and `network_error_test` pins the outcome.
@Freezed(toStringOverride: false)
sealed class NetworkError with _$NetworkError implements Exception {
  const factory NetworkError.timeout({
    Duration? timeout,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkTimeoutError;

  const factory NetworkError.connection({
    String? reason,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkConnectionError;

  const factory NetworkError.noInternet({
    String? reason,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkNoInternetError;

  /// [data] is the decoded body, so a caller can read the API's
  /// `{"error": "<code>"}` envelope without re-parsing the response.
  const factory NetworkError.server({
    required int statusCode,
    dynamic data,
    String? serverMessage,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkServerError;

  const factory NetworkError.client({
    required int statusCode,
    String? clientMessage,
    dynamic data,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkClientError;

  /// Never produced by the exception mapper — a 403 maps to [NetworkClientError].
  /// [AuthNetworkInterceptor] raises this when a 401 arrives on a session that
  /// cannot be refreshed.
  const factory NetworkError.forbidden({
    dynamic data,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkForbiddenError;

  const factory NetworkError.unauthorized({
    dynamic data,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkUnauthorizedError;

  const factory NetworkError.decoding({
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkDecodingError;

  const factory NetworkError.unknown({
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkUnknownError;

  const factory NetworkError.cancelled({
    String? reason,
    Object? originalError,
    NetworkRequest? request,
  }) = NetworkCancelledError;

  const NetworkError._();

  String get message => switch (this) {
    NetworkTimeoutError(:final timeout) when timeout != null =>
      'Request timed out after ${timeout.inSeconds}s',
    NetworkTimeoutError() => 'Request timed out',
    NetworkConnectionError(:final reason) => reason ?? 'Connection failed',
    NetworkNoInternetError(:final reason) => reason ?? 'No internet connection',
    NetworkServerError(:final serverMessage, :final statusCode) =>
      serverMessage ?? 'Server error: $statusCode',
    NetworkClientError(:final clientMessage, :final statusCode) =>
      clientMessage ?? 'Client error: $statusCode',
    NetworkForbiddenError() => 'Forbidden',
    NetworkUnauthorizedError() => 'Unauthorized',
    NetworkDecodingError(:final originalError) when originalError != null =>
      'Failed to decode response: $originalError',
    NetworkDecodingError() => 'Failed to decode response',
    NetworkUnknownError(:final originalError) when originalError != null =>
      'Unknown network error: $originalError',
    NetworkUnknownError() => 'Unknown network error',
    NetworkCancelledError(:final reason) => reason ?? 'Request cancelled',
  };

  /// Attaches the failing request without disturbing anything else the variant
  /// carries.
  ///
  /// Ten hand-written copies of this were the obvious place for a copy-paste to
  /// drop a field — which the tests still check for, but which generated
  /// `copyWith` now makes unwritable.
  NetworkError copyWithRequest(NetworkRequest request) => switch (this) {
    final NetworkTimeoutError e => e.copyWith(request: request),
    final NetworkConnectionError e => e.copyWith(request: request),
    final NetworkNoInternetError e => e.copyWith(request: request),
    final NetworkServerError e => e.copyWith(request: request),
    final NetworkClientError e => e.copyWith(request: request),
    final NetworkForbiddenError e => e.copyWith(request: request),
    final NetworkUnauthorizedError e => e.copyWith(request: request),
    final NetworkDecodingError e => e.copyWith(request: request),
    final NetworkUnknownError e => e.copyWith(request: request),
    final NetworkCancelledError e => e.copyWith(request: request),
  };

  @override
  String toString() => 'NetworkError: $message';
}
