// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
