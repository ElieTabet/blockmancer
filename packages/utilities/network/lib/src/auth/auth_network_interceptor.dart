import 'package:network/src/auth/auth_token_provider.dart';
import 'package:network/src/error/network_error.br.dart';
import 'package:network/src/interceptors/network_interceptor.dart';
import 'package:network/src/models/network_request.br.dart';
import 'package:network/src/models/network_response.br.dart';

/// Attaches the bearer token, and on a 401 decides between replaying,
/// refreshing, and ending the session. The branch order in [onError] is the
/// whole point of this class: it keeps two requests that 401 within the same
/// moment from each triggering a refresh, or from one of them forcing a logout
/// just because it raced.
final class AuthNetworkInterceptor implements NetworkInterceptor {
  final AuthTokenProvider _authProvider;

  /// Access token produced by the most recent refresh on this client. If a
  /// request that used exactly this token still comes back 401 — with no
  /// successful response in between — the freshly refreshed token is already
  /// rejected, so the session is over and refreshing again would loop. Cleared
  /// on any successful response.
  String? _lastRefreshedToken;

  AuthNetworkInterceptor(this._authProvider);

  RefreshableAuthTokenProvider? get _refreshableProvider =>
      _authProvider is RefreshableAuthTokenProvider ? _authProvider : null;

  @override
  Future<void> onRequest(
    NetworkRequest request,
    NetworkRequestInterceptorHandler handler,
  ) async {
    final token = await _authProvider.accessToken;

    if (token == null) {
      handler.next(request);
      return;
    }

    final newHeaders = Map<String, String>.from(request.headers)
      ..['authorization'] = 'Bearer $token';

    handler.next(request.copyWith(headers: newHeaders));
  }

  @override
  Future<void> onResponse(
    NetworkResponse<dynamic> response,
    NetworkResponseInterceptorHandler handler,
  ) async {
    _lastRefreshedToken = null;

    handler.next(response);
  }

  @override
  Future<void> onError(
    NetworkError error,
    NetworkErrorInterceptorHandler handler,
  ) async {
    if (error is! NetworkUnauthorizedError) {
      handler.next(error);
      return;
    }

    final refreshableProvider = _refreshableProvider;

    if (refreshableProvider == null) {
      await _authProvider.onAuthenticationExpired();
      handler.next(
        NetworkForbiddenError(
          data: error.data,
          originalError: error.originalError,
          request: error.request,
        ),
      );
      return;
    }

    final requestToken = _bearerToken(error.request?.headers);
    final latestToken = await _authProvider.accessToken;

    // The token was already refreshed after this request was sent (typically by
    // a sibling request on the same client). Replay with the current token —
    // no extra refresh, and crucially no logout.
    if (requestToken != null &&
        latestToken != null &&
        requestToken != latestToken) {
      handler.retry(NetworkRequest.reuseOriginal());
      return;
    }

    // The request already carried the freshly refreshed token and still failed:
    // the new token is rejected too, so the session is genuinely expired.
    if (requestToken != null && requestToken == _lastRefreshedToken) {
      _lastRefreshedToken = null;
      await _authProvider.onAuthenticationExpired();
      handler.next(error);
      return;
    }

    try {
      final newToken = await refreshableProvider.refreshToken(requestToken);

      if (newToken == null) {
        _lastRefreshedToken = null;
        await _authProvider.onAuthenticationExpired();
        handler.next(error);
        return;
      }

      _lastRefreshedToken = newToken;
      handler.retry(NetworkRequest.reuseOriginal());
    } catch (_) {
      // A transient failure while refreshing (timeout, no connection, 5xx) is
      // not a rejection: keep the session and just fail this request — a later
      // request can refresh again.
      handler.next(error);
    }
  }

  String? _bearerToken(Map<String, String>? headers) {
    final value = headers?['authorization'] ?? headers?['Authorization'];

    if (value == null) return null;

    const prefix = 'Bearer ';

    return value.startsWith(prefix) ? value.substring(prefix.length) : value;
  }
}
