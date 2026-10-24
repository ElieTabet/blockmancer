// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the player turned motion down in the app's settings. A future: the
/// logo's entrance waits for the stored answer rather than play on a guess.

@ProviderFor(reduceMotionSetting)
final reduceMotionSettingProvider = ReduceMotionSettingProvider._();

/// Whether the player turned motion down in the app's settings. A future: the
/// logo's entrance waits for the stored answer rather than play on a guess.

final class ReduceMotionSettingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the player turned motion down in the app's settings. A future: the
  /// logo's entrance waits for the stored answer rather than play on a guess.
  ReduceMotionSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reduceMotionSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reduceMotionSettingHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return reduceMotionSetting(ref);
  }
}

String _$reduceMotionSettingHash() =>
    r'5c62f367b99991bfa3313ff4ffe17b706dd27d0c';

@ProviderFor(splashRouting)
final splashRoutingProvider = SplashRoutingProvider._();

final class SplashRoutingProvider
    extends $FunctionalProvider<SplashRouting, SplashRouting, SplashRouting>
    with $Provider<SplashRouting> {
  SplashRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashRoutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashRoutingHash();

  @$internal
  @override
  $ProviderElement<SplashRouting> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SplashRouting create(Ref ref) {
    return splashRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplashRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplashRouting>(value),
    );
  }
}

String _$splashRoutingHash() => r'ba8ad3557c45a961cb69859c0098734e1ee39364';

/// Whether the player has been through the tutorial. A future: the launch
/// waits for the stored answer rather than guess.

@ProviderFor(tutorialSeen)
final tutorialSeenProvider = TutorialSeenProvider._();

/// Whether the player has been through the tutorial. A future: the launch
/// waits for the stored answer rather than guess.

final class TutorialSeenProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the player has been through the tutorial. A future: the launch
  /// waits for the stored answer rather than guess.
  TutorialSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tutorialSeenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tutorialSeenHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return tutorialSeen(ref);
  }
}

String _$tutorialSeenHash() => r'ada51d30091de4d3aab440ea6f8f12d5a3bf3fa1';

/// Whether this version is too old to play: the launch goes no further than
/// the update screen. A future, for the launch's Remote Config fetch.

@ProviderFor(updateRequired)
final updateRequiredProvider = UpdateRequiredProvider._();

/// Whether this version is too old to play: the launch goes no further than
/// the update screen. A future, for the launch's Remote Config fetch.

final class UpdateRequiredProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether this version is too old to play: the launch goes no further than
  /// the update screen. A future, for the launch's Remote Config fetch.
  UpdateRequiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateRequiredProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateRequiredHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return updateRequired(ref);
  }
}

String _$updateRequiredHash() => r'dbc5e4aecfb9682f9db8a61e49a225fc7fc78ff9';
