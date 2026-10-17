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

String _$runStartForHash() => r'5038a83d7f5481a4515473007cf902d1673fb522';

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
