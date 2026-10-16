// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether this build sends usage statistics and crash reports at all. The
/// app decides; this package only obeys.

@ProviderFor(collectsTelemetry)
final collectsTelemetryProvider = CollectsTelemetryProvider._();

/// Whether this build sends usage statistics and crash reports at all. The
/// app decides; this package only obeys.

final class CollectsTelemetryProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this build sends usage statistics and crash reports at all. The
  /// app decides; this package only obeys.
  CollectsTelemetryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectsTelemetryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectsTelemetryHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return collectsTelemetry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$collectsTelemetryHash() => r'f507967e13a671ddfa4a38aa80a6eb02e1928ba5';

@ProviderFor(telemetry)
final telemetryProvider = TelemetryProvider._();

final class TelemetryProvider
    extends $FunctionalProvider<Telemetry, Telemetry, Telemetry>
    with $Provider<Telemetry> {
  TelemetryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetryHash();

  @$internal
  @override
  $ProviderElement<Telemetry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Telemetry create(Ref ref) {
    return telemetry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Telemetry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Telemetry>(value),
    );
  }
}

String _$telemetryHash() => r'1148c338c555cc165efb48019a4f386934b172ab';
