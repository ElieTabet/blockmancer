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

String _$clearProgressHash() => r'6236ca04eba501fd7cb3c49a879b67f9c7b6a848';

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

String _$runStartForHash() => r'c02f48cfe5f287087dfb95a55f6517de7be70b0a';

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

/// Today's daily best, renewed at the next UTC midnight when the day it was
/// read for is over.

@ProviderFor(todaysDailyBest)
final todaysDailyBestProvider = TodaysDailyBestProvider._();

/// Today's daily best, renewed at the next UTC midnight when the day it was
/// read for is over.

final class TodaysDailyBestProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Today's daily best, renewed at the next UTC midnight when the day it was
  /// read for is over.
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

String _$todaysDailyBestHash() => r'ce960fcf2619f8949e001c1ecbf058a42d39a685';

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
