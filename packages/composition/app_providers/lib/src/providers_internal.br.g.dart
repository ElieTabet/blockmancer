// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_internal.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One for the app's life: its sounds are loaded once, at launch.

@ProviderFor(gameSounds)
final gameSoundsProvider = GameSoundsProvider._();

/// One for the app's life: its sounds are loaded once, at launch.

final class GameSoundsProvider
    extends $FunctionalProvider<GameSounds, GameSounds, GameSounds>
    with $Provider<GameSounds> {
  /// One for the app's life: its sounds are loaded once, at launch.
  GameSoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameSoundsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameSoundsHash();

  @$internal
  @override
  $ProviderElement<GameSounds> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameSounds create(Ref ref) {
    return gameSounds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameSounds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameSounds>(value),
    );
  }
}

String _$gameSoundsHash() => r'c35f0d8d6a659d469b30abe45014d2cbe6962b3b';
