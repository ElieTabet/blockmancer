import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_error.br.freezed.dart';

/// Why an authentication call failed, in the domain's own vocabulary.
///
/// Transport-free on purpose: no `NetworkError` reaches this layer, so nothing
/// above the data layer depends on how the call is made. `auth_data` maps
/// whatever the transport throws onto these.
@freezed
sealed class AuthError with _$AuthError {
  /// Wrong email, wrong password, or a deactivated account — collapsed into one
  /// case server-side on purpose, so this app can never guess which.
  const factory AuthError.invalidCredentials() = InvalidCredentialsAuthError;

  /// This device is already logged in as a different member. An expected state
  /// on a shared or borrowed device, not a bug.
  const factory AuthError.deviceConflict() = DeviceConflictAuthError;

  /// The request never reached the server, or timed out.
  const factory AuthError.noConnection() = NoConnectionAuthError;

  const factory AuthError.unexpected() = UnexpectedAuthError;
}
