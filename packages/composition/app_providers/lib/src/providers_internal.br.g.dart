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

/// One for the app's life, so its writes stay in order. Its days are the
/// game's clock's.

@ProviderFor(playStats)
final playStatsProvider = PlayStatsProvider._();

/// One for the app's life, so its writes stay in order. Its days are the
/// game's clock's.

final class PlayStatsProvider
    extends $FunctionalProvider<LocalPlayStats, LocalPlayStats, LocalPlayStats>
    with $Provider<LocalPlayStats> {
  /// One for the app's life, so its writes stay in order. Its days are the
  /// game's clock's.
  PlayStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playStatsHash();

  @$internal
  @override
  $ProviderElement<LocalPlayStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalPlayStats create(Ref ref) {
    return playStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalPlayStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalPlayStats>(value),
    );
  }
}

String _$playStatsHash() => r'bfd028f255ae2f84003c617895f3db9a8a906fb7';
