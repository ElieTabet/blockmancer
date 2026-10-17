// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Today's daily best on this device, or null before today's first run.

@ProviderFor(dailyBest)
final dailyBestProvider = DailyBestProvider._();

/// Today's daily best on this device, or null before today's first run.

final class DailyBestProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Today's daily best on this device, or null before today's first run.
  DailyBestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyBestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyBestHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return dailyBest(ref);
  }
}

String _$dailyBestHash() => r'99f6b064bcfa6424ae4bba7dd926d2515c872a39';

/// The UTC day today's daily run is played on, at its midnight.

@ProviderFor(dailyDate)
final dailyDateProvider = DailyDateProvider._();

/// The UTC day today's daily run is played on, at its midnight.

final class DailyDateProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// The UTC day today's daily run is played on, at its midnight.
  DailyDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyDateHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return dailyDate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$dailyDateHash() => r'55123a6c1c22d532c641b08fb3c3c6caafcad3d2';

/// Whether a run is saved to pick up again.

@ProviderFor(hasSavedRun)
final hasSavedRunProvider = HasSavedRunProvider._();

/// Whether a run is saved to pick up again.

final class HasSavedRunProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether a run is saved to pick up again.
  HasSavedRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasSavedRunProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasSavedRunHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return hasSavedRun(ref);
  }
}

String _$hasSavedRunHash() => r'918350938391fcd7292c4d3c2229a328a2bfd023';

@ProviderFor(homeRouting)
final homeRoutingProvider = HomeRoutingProvider._();

final class HomeRoutingProvider
    extends $FunctionalProvider<HomeRouting, HomeRouting, HomeRouting>
    with $Provider<HomeRouting> {
  HomeRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRoutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRoutingHash();

  @$internal
  @override
  $ProviderElement<HomeRouting> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRouting create(Ref ref) {
    return homeRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRouting>(value),
    );
  }
}

String _$homeRoutingHash() => r'f4b1c7ede18731892790e8691cb0907802710838';

/// Forgets the jokers [Progression.unannouncedJokers] holds, once the map has
/// announced them.

@ProviderFor(markJokersAnnounced)
final markJokersAnnouncedProvider = MarkJokersAnnouncedProvider._();

/// Forgets the jokers [Progression.unannouncedJokers] holds, once the map has
/// announced them.

final class MarkJokersAnnouncedProvider
    extends
        $FunctionalProvider<
          MarkJokersAnnouncedFun,
          MarkJokersAnnouncedFun,
          MarkJokersAnnouncedFun
        >
    with $Provider<MarkJokersAnnouncedFun> {
  /// Forgets the jokers [Progression.unannouncedJokers] holds, once the map has
  /// announced them.
  MarkJokersAnnouncedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markJokersAnnouncedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markJokersAnnouncedHash();

  @$internal
  @override
  $ProviderElement<MarkJokersAnnouncedFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkJokersAnnouncedFun create(Ref ref) {
    return markJokersAnnounced(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkJokersAnnouncedFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkJokersAnnouncedFun>(value),
    );
  }
}

String _$markJokersAnnouncedHash() =>
    r'133e313d0b7fa007ed68932613a15566e4b2b77a';

/// The practice best on this device, or null before a first practice run.

@ProviderFor(practiceBest)
final practiceBestProvider = PracticeBestProvider._();

/// The practice best on this device, or null before a first practice run.

final class PracticeBestProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// The practice best on this device, or null before a first practice run.
  PracticeBestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'practiceBestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$practiceBestHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return practiceBest(ref);
  }
}

String _$practiceBestHash() => r'2deb1d6d0fd5edca1aa7c03da3a598ab3c6443de';

/// What the player has earned across runs. Refreshed when a run earns
/// something, so the map is up to date when the run is left.

@ProviderFor(progression)
final progressionProvider = ProgressionProvider._();

/// What the player has earned across runs. Refreshed when a run earns
/// something, so the map is up to date when the run is left.

final class ProgressionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Progression>,
          Progression,
          FutureOr<Progression>
        >
    with $FutureModifier<Progression>, $FutureProvider<Progression> {
  /// What the player has earned across runs. Refreshed when a run earns
  /// something, so the map is up to date when the run is left.
  ProgressionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressionHash();

  @$internal
  @override
  $FutureProviderElement<Progression> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Progression> create(Ref ref) {
    return progression(ref);
  }
}

String _$progressionHash() => r'21793847971f59b8c7dafcbadcf84d3372bf8650';

/// Whether the player turned reduce motion on in the app's settings. The
/// platform's own setting is read by the widget that moves.

@ProviderFor(reduceMotionSetting)
final reduceMotionSettingProvider = ReduceMotionSettingProvider._();

/// Whether the player turned reduce motion on in the app's settings. The
/// platform's own setting is read by the widget that moves.

final class ReduceMotionSettingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the player turned reduce motion on in the app's settings. The
  /// platform's own setting is read by the widget that moves.
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
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return reduceMotionSetting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reduceMotionSettingHash() =>
    r'288b31179f7651dc7a5cf694da8d5fe3420ec312';

/// Every world of the map, in the map's order.

@ProviderFor(worlds)
final worldsProvider = WorldsProvider._();

/// Every world of the map, in the map's order.

final class WorldsProvider
    extends
        $FunctionalProvider<
          List<WorldSummary>,
          List<WorldSummary>,
          List<WorldSummary>
        >
    with $Provider<List<WorldSummary>> {
  /// Every world of the map, in the map's order.
  WorldsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'worldsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$worldsHash();

  @$internal
  @override
  $ProviderElement<List<WorldSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<WorldSummary> create(Ref ref) {
    return worlds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WorldSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WorldSummary>>(value),
    );
  }
}

String _$worldsHash() => r'867b7d3a700ba4081ea00269b23e37edf6c3b48f';
