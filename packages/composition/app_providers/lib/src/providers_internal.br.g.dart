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

/// One for the app's life. A test build fetches every few minutes, so a value
/// published in the console reaches a tester's next run; a release build twice
/// a day, as Remote Config's quotas expect.

@ProviderFor(remoteValues)
final remoteValuesProvider = RemoteValuesProvider._();

/// One for the app's life. A test build fetches every few minutes, so a value
/// published in the console reaches a tester's next run; a release build twice
/// a day, as Remote Config's quotas expect.

final class RemoteValuesProvider
    extends $FunctionalProvider<RemoteValues, RemoteValues, RemoteValues>
    with $Provider<RemoteValues> {
  /// One for the app's life. A test build fetches every few minutes, so a value
  /// published in the console reaches a tester's next run; a release build twice
  /// a day, as Remote Config's quotas expect.
  RemoteValuesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValuesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValuesHash();

  @$internal
  @override
  $ProviderElement<RemoteValues> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteValues create(Ref ref) {
    return remoteValues(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteValues value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteValues>(value),
    );
  }
}

String _$remoteValuesHash() => r'ab342150e1666424c2a6fdcc1101192d9fd741e3';

/// The launch's fetch, started at boot and kept: the update check waits for
/// it, briefly, before deciding.

@ProviderFor(remoteValuesFetched)
final remoteValuesFetchedProvider = RemoteValuesFetchedProvider._();

/// The launch's fetch, started at boot and kept: the update check waits for
/// it, briefly, before deciding.

final class RemoteValuesFetchedProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// The launch's fetch, started at boot and kept: the update check waits for
  /// it, briefly, before deciding.
  RemoteValuesFetchedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValuesFetchedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValuesFetchedHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return remoteValuesFetched(ref);
  }
}

String _$remoteValuesFetchedHash() =>
    r'ff6b71abd56498cac0306923798f52de5737b122';

/// Whether this is a test build: `TEST_TOOLS`, the app's to say.

@ProviderFor(testTools)
final testToolsProvider = TestToolsProvider._();

/// Whether this is a test build: `TEST_TOOLS`, the app's to say.

final class TestToolsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this is a test build: `TEST_TOOLS`, the app's to say.
  TestToolsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testToolsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testToolsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return testTools(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$testToolsHash() => r'a7ebc1fc60064bcd31f69ad1aa8bae7a2c38e29d';
