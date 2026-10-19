// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_guard_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Puts the update screen up the moment this version stops playing, wherever
/// the player is, once the game has finished with its last move.
///
/// `keepAlive`, and listened to from boot for the app's life (a read would
/// leave it paused): the minimum can be raised at any moment the app is open.
/// The splash decides at launch; the screen has no way out, so it is put up
/// once.

@ProviderFor(UpdateGuardNotifier)
final updateGuardProvider = UpdateGuardNotifierProvider._();

/// Puts the update screen up the moment this version stops playing, wherever
/// the player is, once the game has finished with its last move.
///
/// `keepAlive`, and listened to from boot for the app's life (a read would
/// leave it paused): the minimum can be raised at any moment the app is open.
/// The splash decides at launch; the screen has no way out, so it is put up
/// once.
final class UpdateGuardNotifierProvider
    extends $NotifierProvider<UpdateGuardNotifier, void> {
  /// Puts the update screen up the moment this version stops playing, wherever
  /// the player is, once the game has finished with its last move.
  ///
  /// `keepAlive`, and listened to from boot for the app's life (a read would
  /// leave it paused): the minimum can be raised at any moment the app is open.
  /// The splash decides at launch; the screen has no way out, so it is put up
  /// once.
  UpdateGuardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateGuardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateGuardNotifierHash();

  @$internal
  @override
  UpdateGuardNotifier create() => UpdateGuardNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$updateGuardNotifierHash() =>
    r'3f0a16adeb36df7fa7dd58baae6010c60ab987c6';

/// Puts the update screen up the moment this version stops playing, wherever
/// the player is, once the game has finished with its last move.
///
/// `keepAlive`, and listened to from boot for the app's life (a read would
/// leave it paused): the minimum can be raised at any moment the app is open.
/// The splash decides at launch; the screen has no way out, so it is put up
/// once.

abstract class _$UpdateGuardNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
