// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(initializeMessaging)
final initializeMessagingProvider = InitializeMessagingProvider._();

final class InitializeMessagingProvider
    extends
        $FunctionalProvider<
          InitializeMessagingFun,
          InitializeMessagingFun,
          InitializeMessagingFun
        >
    with $Provider<InitializeMessagingFun> {
  InitializeMessagingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initializeMessagingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initializeMessagingHash();

  @$internal
  @override
  $ProviderElement<InitializeMessagingFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InitializeMessagingFun create(Ref ref) {
    return initializeMessaging(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InitializeMessagingFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InitializeMessagingFun>(value),
    );
  }
}

String _$initializeMessagingHash() =>
    r'2268eb880b9ffd8bb2b59a3b4b1b1d5ab495b833';

@ProviderFor(pushNotificationsRouting)
final pushNotificationsRoutingProvider = PushNotificationsRoutingProvider._();

final class PushNotificationsRoutingProvider
    extends
        $FunctionalProvider<
          PushNotificationsRouting,
          PushNotificationsRouting,
          PushNotificationsRouting
        >
    with $Provider<PushNotificationsRouting> {
  PushNotificationsRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationsRoutingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationsRoutingHash();

  @$internal
  @override
  $ProviderElement<PushNotificationsRouting> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushNotificationsRouting create(Ref ref) {
    return pushNotificationsRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushNotificationsRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushNotificationsRouting>(value),
    );
  }
}

String _$pushNotificationsRoutingHash() =>
    r'b6ead235933fd6701c949aef8908da95847d3e07';

@ProviderFor(reportNonFatal)
final reportNonFatalProvider = ReportNonFatalProvider._();

final class ReportNonFatalProvider
    extends
        $FunctionalProvider<
          ReportNonFatalFun,
          ReportNonFatalFun,
          ReportNonFatalFun
        >
    with $Provider<ReportNonFatalFun> {
  ReportNonFatalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportNonFatalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportNonFatalHash();

  @$internal
  @override
  $ProviderElement<ReportNonFatalFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportNonFatalFun create(Ref ref) {
    return reportNonFatal(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportNonFatalFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportNonFatalFun>(value),
    );
  }
}

String _$reportNonFatalHash() => r'340e959cefce5795cf365f21e3cbf691a436be89';
