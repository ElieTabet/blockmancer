import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.br.freezed.dart';

@freezed
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({
    required String accessToken,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
  }) = _TokenPair;

  const TokenPair._();

  bool get isAccessTokenExpired =>
      !accessTokenExpiresAt.isAfter(DateTime.now());

  /// The one that decides whether a session is over. An expired *access* token
  /// is routine — the interceptor renews it — but once this has passed there is
  /// nothing left to renew with.
  bool get isRefreshTokenExpired =>
      !refreshTokenExpiresAt.isAfter(DateTime.now());
}
