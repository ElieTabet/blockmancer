import 'package:flutter/widgets.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

extension SignOutAuthErrorMessage on AuthError {
  /// Exhaustive by design: a new [AuthError] variant becomes a compile error
  /// here until it has been given a message.
  ///
  /// Only losing the connection gets its own copy. The credential failures can
  /// reach a sign-out in principle, but nothing they say to a member who is
  /// already signed in would help them, so they read as the generic failure.
  String signOutMessageOf(BuildContext context) => switch (this) {
    NoConnectionAuthError() => context.t.session.signOutNoConnection,
    DeviceConflictAuthError() ||
    InvalidCredentialsAuthError() ||
    UnexpectedAuthError() => context.t.session.signOutFailed,
  };
}
