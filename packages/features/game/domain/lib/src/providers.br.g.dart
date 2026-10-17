// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps a finished run's total if it beats its mode's best, and says so.

@ProviderFor(recordRunEnd)
final recordRunEndProvider = RecordRunEndProvider._();

/// Keeps a finished run's total if it beats its mode's best, and says so.

final class RecordRunEndProvider
    extends
        $FunctionalProvider<RecordRunEndFun, RecordRunEndFun, RecordRunEndFun>
    with $Provider<RecordRunEndFun> {
  /// Keeps a finished run's total if it beats its mode's best, and says so.
  RecordRunEndProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordRunEndProvider',
        isAutoDispose: true,
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

String _$recordRunEndHash() => r'8b790c2ff6470155191bdf58166729e6fd39153f';

/// Today's daily run. Keyed by the UTC day itself, not by the seed: the seed
/// is the rules' to derive, and may change without orphaning the saved bests.

@ProviderFor(todaysDailyRun)
final todaysDailyRunProvider = TodaysDailyRunProvider._();

/// Today's daily run. Keyed by the UTC day itself, not by the seed: the seed
/// is the rules' to derive, and may change without orphaning the saved bests.

final class TodaysDailyRunProvider
    extends $FunctionalProvider<RunStart, RunStart, RunStart>
    with $Provider<RunStart> {
  /// Today's daily run. Keyed by the UTC day itself, not by the seed: the seed
  /// is the rules' to derive, and may change without orphaning the saved bests.
  TodaysDailyRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysDailyRunProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysDailyRunHash();

  @$internal
  @override
  $ProviderElement<RunStart> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RunStart create(Ref ref) {
    return todaysDailyRun(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunStart value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunStart>(value),
    );
  }
}

String _$todaysDailyRunHash() => r'c62db92488e793e02d360b76b23110ac9ed7def6';
