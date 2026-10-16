// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_internal.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Today's daily seed. The rules have no clock, so the date is read here — and
/// overridden in tests.

@ProviderFor(runSeed)
final runSeedProvider = RunSeedProvider._();

/// Today's daily seed. The rules have no clock, so the date is read here — and
/// overridden in tests.

final class RunSeedProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Today's daily seed. The rules have no clock, so the date is read here — and
  /// overridden in tests.
  RunSeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runSeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runSeedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return runSeed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$runSeedHash() => r'51c413feb8e369af959e402cb7041ec2458b8dee';
