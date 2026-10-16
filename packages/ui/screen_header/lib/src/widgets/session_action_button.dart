import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:screen_header/src/entities/auth_error.dart';
import 'package:screen_header/src/notifiers/session_action_notifier.br.dart';
import 'package:screen_header/src/providers_di.br.dart' as di;
import 'package:screen_header/src/states/session_action_ui_state.br.dart';

/// The app's one session control: sign in for a guest, sign out for a member,
/// with the confirmation, the spinner and the failure popup that go with it.
///
/// Nothing is drawn until the session is known, so nothing ever shows the wrong
/// verb for a frame and then swaps it.
///
/// Public because a second screen now places it: the header takes it as its
/// trailing slot at [DSButtonSize.medium], and the account page stands it
/// full-width at [DSButtonSize.large]. It stays one widget rather than two
/// because "confirm, spin, fail, retry" is one behaviour, and a copy of it
/// would be a second place to get that wrong.
final class SessionActionButton extends ConsumerWidget {
  final DSButtonSize size;

  const SessionActionButton({this.size = .medium, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(
      di.isAuthenticatedProvider.select((session) => session.value),
    );

    return switch (isAuthenticated) {
      null => const SizedBox.shrink(),
      true => _SignOutButton(size: size),
      false => _SignInButton(size: size),
    };
  }
}

final class _SignInButton extends ConsumerWidget {
  final DSButtonSize size;

  const _SignInButton({required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) => _sized(
    size,
    context: context,
    title: context.t.session.signIn,
    onPressed: () =>
        ref.read(sessionActionProvider.notifier).onSignInPressed(context),
  );
}

/// The design system exposes each size as its own constructor, so choosing one
/// is a switch rather than an argument.
DSPrimaryButton _sized(
  DSButtonSize size, {
  required BuildContext context,
  required String title,
  required VoidCallback onPressed,
  bool isLoading = false,
}) => switch (size) {
  .small => DSPrimaryButton.small(
    context: context,
    title: title,
    isLoading: isLoading,
    onPressed: onPressed,
  ),
  .medium => DSPrimaryButton.medium(
    context: context,
    title: title,
    isLoading: isLoading,
    onPressed: onPressed,
  ),
  .large => DSPrimaryButton.large(
    context: context,
    title: title,
    isLoading: isLoading,
    onPressed: onPressed,
  ),
};

final class _SignOutButton extends ConsumerWidget {
  final DSButtonSize size;

  const _SignOutButton({required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sessionActionProvider, (_, next) {
      if (next case FailedSessionActionUiState(:final error)) {
        unawaited(
          DSPopup.showError(
            context,
            title: context.t.session.signOutFailedTitle,
            message: error.signOutMessageOf(context),
            buttonLabel: context.t.session.signOutFailedButtonLabel,
          ),
        );
      }
    });

    final isSigningOut = ref.watch(
      sessionActionProvider.select(
        (state) => state is SigningOutSessionActionUiState,
      ),
    );

    // `isLoading` alone: DSButton swaps the label for a spinner *and* refuses
    // the tap while it is set, so it both shows the work and prevents a second
    // sign-out being sent on top of the first. Passing `enabled: false` as well
    // would only dim a label nothing is drawing.
    return _sized(
      size,
      context: context,
      title: context.t.session.signOut,
      isLoading: isSigningOut,
      onPressed: () => unawaited(_confirmThenSignOut(context, ref)),
    );
  }

  /// The dialog lives here because a dialog is UI; what happens once it is
  /// answered is the notifier's.
  Future<void> _confirmThenSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await DSPopup.showConfirm(
      context,
      title: context.t.session.signOutConfirmTitle,
      message: context.t.session.signOutConfirmMessage,
      confirmLabel: context.t.session.signOutConfirmAction,
      cancelLabel: context.t.session.signOutCancel,
      isDestructive: true,
    );

    if (!confirmed || !context.mounted) return;

    await ref.read(sessionActionProvider.notifier).onSignOutConfirmed();
  }
}
