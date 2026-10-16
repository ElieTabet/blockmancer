// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_action_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(SessionActionNotifier)
final sessionActionProvider = SessionActionNotifierProvider._();

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
final class SessionActionNotifierProvider
    extends $NotifierProvider<SessionActionNotifier, SessionActionUiState> {
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
  SessionActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionActionNotifierHash();

  @$internal
  @override
  SessionActionNotifier create() => SessionActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionActionUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionActionUiState>(value),
    );
  }
}

String _$sessionActionNotifierHash() =>
    r'abd9cb88afe343829458afe5a830362f6055f3f7';

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

abstract class _$SessionActionNotifier extends $Notifier<SessionActionUiState> {
  SessionActionUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SessionActionUiState, SessionActionUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionActionUiState, SessionActionUiState>,
              SessionActionUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
