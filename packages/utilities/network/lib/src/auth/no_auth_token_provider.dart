import 'package:network/src/auth/auth_token_provider.dart';

/// For an app with no sign-in at all: there is never a token to attach, and
/// nothing to do when a server says one expired.
final class NoAuthTokenProvider implements AuthTokenProvider {
  const NoAuthTokenProvider();

  @override
  String? get accessToken => null;

  @override
  Future<void> onAuthenticationExpired() async {}
}
