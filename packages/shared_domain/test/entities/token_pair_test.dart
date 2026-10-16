import 'package:test/test.dart';
import 'package:shared_domain/shared_domain.dart';

TokenPair _pair(Duration accessExpiresIn) => TokenPair(
  accessToken: 'a',
  accessTokenExpiresAt: DateTime.now().add(accessExpiresIn),
  refreshToken: 'r',
  refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 14)),
);

// The pair carries both expiries but interprets only the access one, because
// that is the only question anything asks: whether the launch handshake has
// anything to fetch. `refreshTokenExpiresAt` is stored and sent, never read.
void main() {
  test('an access token with time left is not expired', () {
    expect(_pair(const Duration(hours: 1)).isAccessTokenExpired, isFalse);
  });

  test('an access token past its expiry is expired', () {
    expect(_pair(const Duration(hours: -1)).isAccessTokenExpired, isTrue);
  });

  // The boundary must not leave a token that is simultaneously "valid" and
  // unusable.
  test('an expiry exactly now counts as expired', () {
    final now = DateTime.now();
    final pair = TokenPair(
      accessToken: 'a',
      accessTokenExpiresAt: now,
      refreshToken: 'r',
      refreshTokenExpiresAt: now,
    );

    expect(pair.isAccessTokenExpired, isTrue);
  });
}
