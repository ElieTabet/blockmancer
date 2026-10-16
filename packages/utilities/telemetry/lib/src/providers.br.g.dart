// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Once per launch, as early as the container allows: the crash handlers, then
/// the switch.
///
/// The handlers go in only when collecting — anywhere else they would replace
/// Flutter's own error reporting with a reporter that never reports. The switch
/// is set on every launch, either way: the SDKs persist it on the phone, so a
/// debug build installed over a release one would otherwise inherit its "on".

@ProviderFor(initializeTelemetry)
final initializeTelemetryProvider = InitializeTelemetryProvider._();

/// Once per launch, as early as the container allows: the crash handlers, then
/// the switch.
///
/// The handlers go in only when collecting — anywhere else they would replace
/// Flutter's own error reporting with a reporter that never reports. The switch
/// is set on every launch, either way: the SDKs persist it on the phone, so a
/// debug build installed over a release one would otherwise inherit its "on".

final class InitializeTelemetryProvider
    extends
        $FunctionalProvider<
          InitializeTelemetryFun,
          InitializeTelemetryFun,
          InitializeTelemetryFun
        >
    with $Provider<InitializeTelemetryFun> {
  /// Once per launch, as early as the container allows: the crash handlers, then
  /// the switch.
  ///
  /// The handlers go in only when collecting — anywhere else they would replace
  /// Flutter's own error reporting with a reporter that never reports. The switch
  /// is set on every launch, either way: the SDKs persist it on the phone, so a
  /// debug build installed over a release one would otherwise inherit its "on".
  InitializeTelemetryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initializeTelemetryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initializeTelemetryHash();

  @$internal
  @override
  $ProviderElement<InitializeTelemetryFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InitializeTelemetryFun create(Ref ref) {
    return initializeTelemetry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InitializeTelemetryFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InitializeTelemetryFun>(value),
    );
  }
}

String _$initializeTelemetryHash() =>
    r'3a76c05b78acd79c46dd47e161126f733d96ec8d';

/// Reports a failure the app survived, in builds that collect and nowhere else.
///
/// Gated here as well as by the SDK's switch: with collection off, Crashlytics
/// keeps reports on the phone rather than dropping them, and a release build
/// installed over this one would send them.

@ProviderFor(recordNonFatal)
final recordNonFatalProvider = RecordNonFatalProvider._();

/// Reports a failure the app survived, in builds that collect and nowhere else.
///
/// Gated here as well as by the SDK's switch: with collection off, Crashlytics
/// keeps reports on the phone rather than dropping them, and a release build
/// installed over this one would send them.

final class RecordNonFatalProvider
    extends
        $FunctionalProvider<
          RecordNonFatalFun,
          RecordNonFatalFun,
          RecordNonFatalFun
        >
    with $Provider<RecordNonFatalFun> {
  /// Reports a failure the app survived, in builds that collect and nowhere else.
  ///
  /// Gated here as well as by the SDK's switch: with collection off, Crashlytics
  /// keeps reports on the phone rather than dropping them, and a release build
  /// installed over this one would send them.
  RecordNonFatalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordNonFatalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordNonFatalHash();

  @$internal
  @override
  $ProviderElement<RecordNonFatalFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordNonFatalFun create(Ref ref) {
    return recordNonFatal(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordNonFatalFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordNonFatalFun>(value),
    );
  }
}

String _$recordNonFatalHash() => r'c991cdcbdd6b5c53855f8b78357696b8b301a34c';
