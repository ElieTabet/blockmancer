// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The best run total of [mode] on this device, or null before its first run.

@ProviderFor(bestScore)
final bestScoreProvider = BestScoreFamily._();

/// The best run total of [mode] on this device, or null before its first run.

final class BestScoreProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// The best run total of [mode] on this device, or null before its first run.
  BestScoreProvider._({
    required BestScoreFamily super.from,
    required GameMode super.argument,
  }) : super(
         retry: null,
         name: r'bestScoreProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bestScoreHash();

  @override
  String toString() {
    return r'bestScoreProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as GameMode;
    return bestScore(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BestScoreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bestScoreHash() => r'15c71160cb46af1f6a1d7722ef2fc9bd6e31d028';

/// The best run total of [mode] on this device, or null before its first run.

final class BestScoreFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int?>, GameMode> {
  BestScoreFamily._()
    : super(
        retry: null,
        name: r'bestScoreProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The best run total of [mode] on this device, or null before its first run.

  BestScoreProvider call(GameMode mode) =>
      BestScoreProvider._(argument: mode, from: this);

  @override
  String toString() => r'bestScoreProvider';
}

/// See [ClearProgressBehavior].
///
/// Kept alive because it refreshes the bests and the saved run after an await,
/// by when an auto-disposed provider's ref may be gone.

@ProviderFor(clearProgress)
final clearProgressProvider = ClearProgressProvider._();

/// See [ClearProgressBehavior].
///
/// Kept alive because it refreshes the bests and the saved run after an await,
/// by when an auto-disposed provider's ref may be gone.

final class ClearProgressProvider
    extends
        $FunctionalProvider<
          ClearProgressFun,
          ClearProgressFun,
          ClearProgressFun
        >
    with $Provider<ClearProgressFun> {
  /// See [ClearProgressBehavior].
  ///
  /// Kept alive because it refreshes the bests and the saved run after an await,
  /// by when an auto-disposed provider's ref may be gone.
  ClearProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clearProgressHash();

  @$internal
  @override
  $ProviderElement<ClearProgressFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClearProgressFun create(Ref ref) {
    return clearProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClearProgressFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClearProgressFun>(value),
    );
  }
}

String _$clearProgressHash() => r'00fef86e532af07696c82f61b88d971b991e797b';

/// What the player has earned across runs, as this device keeps it.

@ProviderFor(progression)
final progressionProvider = ProgressionProvider._();

/// What the player has earned across runs, as this device keeps it.

final class ProgressionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Progression>,
          Progression,
          FutureOr<Progression>
        >
    with $FutureModifier<Progression>, $FutureProvider<Progression> {
  /// What the player has earned across runs, as this device keeps it.
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

String _$progressionHash() => r'd5ef8901cb6c69644074bfd17991c4d85b4d3089';

/// Every joker in pairs, with how each pair is unlocked.

@ProviderFor(jokerCollection)
final jokerCollectionProvider = JokerCollectionProvider._();

/// Every joker in pairs, with how each pair is unlocked.

final class JokerCollectionProvider
    extends
        $FunctionalProvider<JokerCollection, JokerCollection, JokerCollection>
    with $Provider<JokerCollection> {
  /// Every joker in pairs, with how each pair is unlocked.
  JokerCollectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jokerCollectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jokerCollectionHash();

  @$internal
  @override
  $ProviderElement<JokerCollection> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JokerCollection create(Ref ref) {
    return jokerCollection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JokerCollection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JokerCollection>(value),
    );
  }
}

String _$jokerCollectionHash() => r'cdb3f224090b309308bfbb824751888c26cbaca2';

/// See [MarkBossCardSeenBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

@ProviderFor(markBossCardSeen)
final markBossCardSeenProvider = MarkBossCardSeenProvider._();

/// See [MarkBossCardSeenBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

final class MarkBossCardSeenProvider
    extends
        $FunctionalProvider<
          MarkBossCardSeenFun,
          MarkBossCardSeenFun,
          MarkBossCardSeenFun
        >
    with $Provider<MarkBossCardSeenFun> {
  /// See [MarkBossCardSeenBehavior].
  ///
  /// Kept alive because it refreshes [progressionProvider] after an await, by
  /// when an auto-disposed provider's ref may be gone.
  MarkBossCardSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markBossCardSeenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markBossCardSeenHash();

  @$internal
  @override
  $ProviderElement<MarkBossCardSeenFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkBossCardSeenFun create(Ref ref) {
    return markBossCardSeen(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkBossCardSeenFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkBossCardSeenFun>(value),
    );
  }
}

String _$markBossCardSeenHash() => r'dc13ee2322433f93e235bc0e15d5326b17f4130a';

/// See [MarkJokersAnnouncedBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

@ProviderFor(markJokersAnnounced)
final markJokersAnnouncedProvider = MarkJokersAnnouncedProvider._();

/// See [MarkJokersAnnouncedBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

final class MarkJokersAnnouncedProvider
    extends
        $FunctionalProvider<
          MarkJokersAnnouncedFun,
          MarkJokersAnnouncedFun,
          MarkJokersAnnouncedFun
        >
    with $Provider<MarkJokersAnnouncedFun> {
  /// See [MarkJokersAnnouncedBehavior].
  ///
  /// Kept alive because it refreshes [progressionProvider] after an await, by
  /// when an auto-disposed provider's ref may be gone.
  MarkJokersAnnouncedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markJokersAnnouncedProvider',
        isAutoDispose: false,
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
    r'bb8cf1d3e4bdfeb0a81cf5f8cb86fdfcc4eb87e8';

/// See [RecordPickBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

@ProviderFor(recordPick)
final recordPickProvider = RecordPickProvider._();

/// See [RecordPickBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

final class RecordPickProvider
    extends $FunctionalProvider<RecordPickFun, RecordPickFun, RecordPickFun>
    with $Provider<RecordPickFun> {
  /// See [RecordPickBehavior].
  ///
  /// Kept alive because it refreshes [progressionProvider] after an await, by
  /// when an auto-disposed provider's ref may be gone.
  RecordPickProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordPickProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordPickHash();

  @$internal
  @override
  $ProviderElement<RecordPickFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecordPickFun create(Ref ref) {
    return recordPick(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordPickFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordPickFun>(value),
    );
  }
}

String _$recordPickHash() => r'35cacbafc5161bd2fa6f4f96bcb2970fcdab27a3';

/// See [RecordProgressionBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

@ProviderFor(recordProgression)
final recordProgressionProvider = RecordProgressionProvider._();

/// See [RecordProgressionBehavior].
///
/// Kept alive because it refreshes [progressionProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

final class RecordProgressionProvider
    extends
        $FunctionalProvider<
          RecordProgressionFun,
          RecordProgressionFun,
          RecordProgressionFun
        >
    with $Provider<RecordProgressionFun> {
  /// See [RecordProgressionBehavior].
  ///
  /// Kept alive because it refreshes [progressionProvider] after an await, by
  /// when an auto-disposed provider's ref may be gone.
  RecordProgressionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordProgressionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordProgressionHash();

  @$internal
  @override
  $ProviderElement<RecordProgressionFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordProgressionFun create(Ref ref) {
    return recordProgression(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordProgressionFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordProgressionFun>(value),
    );
  }
}

String _$recordProgressionHash() => r'e27e77d005e66cf2509ba08a92391c9c6571e21e';

/// Keeps a finished run's total if it beats its mode's best, and says so.
///
/// Kept alive because it refreshes [bestScoreProvider] after an await, by when
/// an auto-disposed provider's ref may be gone.

@ProviderFor(recordRunEnd)
final recordRunEndProvider = RecordRunEndProvider._();

/// Keeps a finished run's total if it beats its mode's best, and says so.
///
/// Kept alive because it refreshes [bestScoreProvider] after an await, by when
/// an auto-disposed provider's ref may be gone.

final class RecordRunEndProvider
    extends
        $FunctionalProvider<RecordRunEndFun, RecordRunEndFun, RecordRunEndFun>
    with $Provider<RecordRunEndFun> {
  /// Keeps a finished run's total if it beats its mode's best, and says so.
  ///
  /// Kept alive because it refreshes [bestScoreProvider] after an await, by when
  /// an auto-disposed provider's ref may be gone.
  RecordRunEndProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordRunEndProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordRunEndHash();

  @$internal
  @override
  $ProviderElement<RecordRunEndFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecordRunEndFun create(Ref ref) {
    return recordRunEnd(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordRunEndFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordRunEndFun>(value),
    );
  }
}

String _$recordRunEndHash() => r'461d567f66da1a419a5c3513924fe0ee55a50cfb';

@ProviderFor(runStartFor)
final runStartForProvider = RunStartForProvider._();

final class RunStartForProvider
    extends $FunctionalProvider<RunStartForFun, RunStartForFun, RunStartForFun>
    with $Provider<RunStartForFun> {
  RunStartForProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runStartForProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runStartForHash();

  @$internal
  @override
  $ProviderElement<RunStartForFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RunStartForFun create(Ref ref) {
    return runStartFor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunStartForFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunStartForFun>(value),
    );
  }
}

String _$runStartForHash() => r'ef3a184b7b3dd7886cb0f42afb542b7eb5048bfe';

/// Whether a run is saved to resume.

@ProviderFor(hasSavedRun)
final hasSavedRunProvider = HasSavedRunProvider._();

/// Whether a run is saved to resume.

final class HasSavedRunProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether a run is saved to resume.
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

String _$hasSavedRunHash() => r'305e7ff8111ee1c05fbc7d7c9dc06a729a67539a';

/// What the player has earned across runs. Throws when the device's storage
/// can't be reached at all.

@ProviderFor(loadProgression)
final loadProgressionProvider = LoadProgressionProvider._();

/// What the player has earned across runs. Throws when the device's storage
/// can't be reached at all.

final class LoadProgressionProvider
    extends
        $FunctionalProvider<
          LoadProgressionFun,
          LoadProgressionFun,
          LoadProgressionFun
        >
    with $Provider<LoadProgressionFun> {
  /// What the player has earned across runs. Throws when the device's storage
  /// can't be reached at all.
  LoadProgressionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadProgressionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadProgressionHash();

  @$internal
  @override
  $ProviderElement<LoadProgressionFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoadProgressionFun create(Ref ref) {
    return loadProgression(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadProgressionFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadProgressionFun>(value),
    );
  }
}

String _$loadProgressionHash() => r'5b64dde1a9ada3163f7f8588b7c1fbd7ca002991';

/// The run saved on this device, or null when there is none to resume.
/// Throws when the device's storage can't be reached at all.

@ProviderFor(loadSavedRun)
final loadSavedRunProvider = LoadSavedRunProvider._();

/// The run saved on this device, or null when there is none to resume.
/// Throws when the device's storage can't be reached at all.

final class LoadSavedRunProvider
    extends
        $FunctionalProvider<LoadSavedRunFun, LoadSavedRunFun, LoadSavedRunFun>
    with $Provider<LoadSavedRunFun> {
  /// The run saved on this device, or null when there is none to resume.
  /// Throws when the device's storage can't be reached at all.
  LoadSavedRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadSavedRunProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadSavedRunHash();

  @$internal
  @override
  $ProviderElement<LoadSavedRunFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoadSavedRunFun create(Ref ref) {
    return loadSavedRun(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadSavedRunFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadSavedRunFun>(value),
    );
  }
}

String _$loadSavedRunHash() => r'bb7af466bee2c0fd1d283086ab75d3006994d760';

/// See [SaveRunBehavior].
///
/// Kept alive so one behavior orders every write, and because it refreshes
/// [hasSavedRunProvider] after an await, by when an auto-disposed provider's
/// ref may be gone.

@ProviderFor(saveRun)
final saveRunProvider = SaveRunProvider._();

/// See [SaveRunBehavior].
///
/// Kept alive so one behavior orders every write, and because it refreshes
/// [hasSavedRunProvider] after an await, by when an auto-disposed provider's
/// ref may be gone.

final class SaveRunProvider
    extends $FunctionalProvider<SaveRunFun, SaveRunFun, SaveRunFun>
    with $Provider<SaveRunFun> {
  /// See [SaveRunBehavior].
  ///
  /// Kept alive so one behavior orders every write, and because it refreshes
  /// [hasSavedRunProvider] after an await, by when an auto-disposed provider's
  /// ref may be gone.
  SaveRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveRunProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveRunHash();

  @$internal
  @override
  $ProviderElement<SaveRunFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaveRunFun create(Ref ref) {
    return saveRun(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveRunFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveRunFun>(value),
    );
  }
}

String _$saveRunHash() => r'ef65f025fc5e0f6ca6b8bc917a8a931b544197dd';

/// Today's daily best, renewed with [todaysDailyDateProvider].

@ProviderFor(todaysDailyBest)
final todaysDailyBestProvider = TodaysDailyBestProvider._();

/// Today's daily best, renewed with [todaysDailyDateProvider].

final class TodaysDailyBestProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Today's daily best, renewed with [todaysDailyDateProvider].
  TodaysDailyBestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysDailyBestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysDailyBestHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return todaysDailyBest(ref);
  }
}

String _$todaysDailyBestHash() => r'88ec2f5293f2fad945ce7d3e68958c099288c256';

/// The UTC day today's daily run is played on, at its midnight, renewed at the
/// next UTC midnight when that day is over.

@ProviderFor(todaysDailyDate)
final todaysDailyDateProvider = TodaysDailyDateProvider._();

/// The UTC day today's daily run is played on, at its midnight, renewed at the
/// next UTC midnight when that day is over.

final class TodaysDailyDateProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// The UTC day today's daily run is played on, at its midnight, renewed at the
  /// next UTC midnight when that day is over.
  TodaysDailyDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysDailyDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysDailyDateHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return todaysDailyDate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$todaysDailyDateHash() => r'9d14556e43899ba3153d702940e8607ae82cfb12';

/// Every world of the map in the map's order: whether it can be played yet,
/// its boss's target, its third star's threshold and what beating it unlocks.

@ProviderFor(worldSummaries)
final worldSummariesProvider = WorldSummariesProvider._();

/// Every world of the map in the map's order: whether it can be played yet,
/// its boss's target, its third star's threshold and what beating it unlocks.

final class WorldSummariesProvider
    extends
        $FunctionalProvider<
          List<WorldSummary>,
          List<WorldSummary>,
          List<WorldSummary>
        >
    with $Provider<List<WorldSummary>> {
  /// Every world of the map in the map's order: whether it can be played yet,
  /// its boss's target, its third star's threshold and what beating it unlocks.
  WorldSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'worldSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$worldSummariesHash();

  @$internal
  @override
  $ProviderElement<List<WorldSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<WorldSummary> create(Ref ref) {
    return worldSummaries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WorldSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WorldSummary>>(value),
    );
  }
}

String _$worldSummariesHash() => r'219571ace5dddb107aa95b813d0527e62f195834';

/// What a new profile starts from, worked out from the rules so the storage
/// never needs to know them.

@ProviderFor(initialProgression)
final initialProgressionProvider = InitialProgressionProvider._();

/// What a new profile starts from, worked out from the rules so the storage
/// never needs to know them.

final class InitialProgressionProvider
    extends $FunctionalProvider<Progression, Progression, Progression>
    with $Provider<Progression> {
  /// What a new profile starts from, worked out from the rules so the storage
  /// never needs to know them.
  InitialProgressionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialProgressionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialProgressionHash();

  @$internal
  @override
  $ProviderElement<Progression> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Progression create(Ref ref) {
    return initialProgression(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Progression value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Progression>(value),
    );
  }
}

String _$initialProgressionHash() =>
    r'0e1f2830bfdb0a6f42df3cc97c7970c114675131';

/// See [TrackMoveFun].

@ProviderFor(trackMove)
final trackMoveProvider = TrackMoveProvider._();

/// See [TrackMoveFun].

final class TrackMoveProvider
    extends $FunctionalProvider<TrackMoveFun, TrackMoveFun, TrackMoveFun>
    with $Provider<TrackMoveFun> {
  /// See [TrackMoveFun].
  TrackMoveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackMoveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackMoveHash();

  @$internal
  @override
  $ProviderElement<TrackMoveFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TrackMoveFun create(Ref ref) {
    return trackMove(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackMoveFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackMoveFun>(value),
    );
  }
}

String _$trackMoveHash() => r'b00c99351b48233a748f08300f21405a312da980';

/// See [TrackRunEndFun].

@ProviderFor(trackRunEnd)
final trackRunEndProvider = TrackRunEndProvider._();

/// See [TrackRunEndFun].

final class TrackRunEndProvider
    extends $FunctionalProvider<TrackRunEndFun, TrackRunEndFun, TrackRunEndFun>
    with $Provider<TrackRunEndFun> {
  /// See [TrackRunEndFun].
  TrackRunEndProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackRunEndProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackRunEndHash();

  @$internal
  @override
  $ProviderElement<TrackRunEndFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TrackRunEndFun create(Ref ref) {
    return trackRunEnd(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackRunEndFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackRunEndFun>(value),
    );
  }
}

String _$trackRunEndHash() => r'0f39080590e9fd371f0c5a52f75dae4a0b5fccae';
