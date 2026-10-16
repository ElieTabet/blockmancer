import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_header/src/providers_di.br.dart' as di;
import 'package:screen_header/src/states/session_action_ui_state.br.dart';

part 'session_action_notifier.br.g.dart';

/// Drives the header's one session control: sign in for a guest, sign out for a
/// member.
///
/// It does not navigate on a sign-out. Ending a session already has a policy
/// bound once in composition, and it runs off the session state this call
/// flips — so routing from here as well would replace the stack twice. Signing
/// *in* ends nothing, which is why that one goes through the routing interface.
///
/// One notifier serves every screen that draws the header, which is what makes
/// a sign-out started on one tab show its spinner on whichever tab is in front
/// when it lands.
@riverpod
class SessionActionNotifier extends _$SessionActionNotifier {
  @override
  SessionActionUiState build() => const SessionActionUiState.idle();

  void onSignInPressed(BuildContext context) =>
      ref.read(di.screenHeaderRoutingProvider).onSignInRequested(context);

  /// Called once the member has confirmed. The dialog itself is the widget's,
  /// because a dialog is UI; what happens after it is this.
  Future<void> onSignOutConfirmed() async {
    if (state is SigningOutSessionActionUiState) return;

    // Resolved before the await: the widget only `read`s this notifier, so the
    // provider can be disposed while the call is in flight and a `ref` reached
    // for afterwards would throw.
    final logout = ref.read(di.logoutProvider);

    state = const SessionActionUiState.signingOut();

    final result = await logout();

    // On success the stack is already being replaced, so returning to idle is
    // only for the failure path — but setting it unconditionally keeps the
    // control usable if navigation is ever made someone else's job.
    state = result.fold(
      (_) => const SessionActionUiState.idle(),
      SessionActionUiState.failed,
    );
  }
}
