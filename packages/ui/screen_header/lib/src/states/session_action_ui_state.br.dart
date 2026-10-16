import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'session_action_ui_state.br.freezed.dart';

/// What the header's session control is doing.
///
/// It carries no "signed out" case: a completed sign-out replaces the whole
/// navigation stack, so this state has no screen left to describe.
@freezed
sealed class SessionActionUiState with _$SessionActionUiState {
  const factory SessionActionUiState.idle() = IdleSessionActionUiState;

  const factory SessionActionUiState.signingOut() =
      SigningOutSessionActionUiState;

  const factory SessionActionUiState.failed(AuthError error) =
      FailedSessionActionUiState;
}
