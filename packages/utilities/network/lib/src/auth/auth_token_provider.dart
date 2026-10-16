import 'dart:async';

/// Supplies the bearer token for outgoing requests and decides what an expired
/// session means. The implementation lives outside this package — `network`
/// knows nothing about `/auth/refresh`, device registration or guest tokens.
abstract interface class AuthTokenProvider {
  FutureOr<String?> get accessToken;

  Future<void> onAuthenticationExpired();
}

abstract interface class RefreshableAuthTokenProvider
    implements AuthTokenProvider {
  /// Returns the new access token, or `null` when the server rejected the
  /// refresh. Throwing means a transient failure (timeout, no connection) and
  /// deliberately does *not* end the session.
  Future<String?> refreshToken(String? requestToken);
}
