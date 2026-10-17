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
