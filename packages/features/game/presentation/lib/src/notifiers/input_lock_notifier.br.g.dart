// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_lock_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the screen ignores touches: for [scoreReveal] after a move that
/// clears, so a finger already reaching for the next piece doesn't play it
/// before the breakdown has been seen.

@ProviderFor(InputLockNotifier)
final inputLockProvider = InputLockNotifierProvider._();

/// Whether the screen ignores touches: for [scoreReveal] after a move that
/// clears, so a finger already reaching for the next piece doesn't play it
/// before the breakdown has been seen.
final class InputLockNotifierProvider
    extends $NotifierProvider<InputLockNotifier, bool> {
  /// Whether the screen ignores touches: for [scoreReveal] after a move that
  /// clears, so a finger already reaching for the next piece doesn't play it
  /// before the breakdown has been seen.
  InputLockNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputLockProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[gameProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          InputLockNotifierProvider.$allTransitiveDependencies0,
          InputLockNotifierProvider.$allTransitiveDependencies1,
          InputLockNotifierProvider.$allTransitiveDependencies2,
        ],
      );

  static final $allTransitiveDependencies0 = gameProvider;
  static final $allTransitiveDependencies1 =
      GameNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      GameNotifierProvider.$allTransitiveDependencies1;

  @override
  String debugGetCreateSourceHash() => _$inputLockNotifierHash();

  @$internal
  @override
  InputLockNotifier create() => InputLockNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$inputLockNotifierHash() => r'2b93a52ccf5e4733d34cb2690970908d54bd938d';

/// Whether the screen ignores touches: for [scoreReveal] after a move that
/// clears, so a finger already reaching for the next piece doesn't play it
/// before the breakdown has been seen.

abstract class _$InputLockNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
