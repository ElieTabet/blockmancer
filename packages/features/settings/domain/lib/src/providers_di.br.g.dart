// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kept for the session: neither the build nor the phone changes while the app
/// runs.

@ProviderFor(appDetails)
final appDetailsProvider = AppDetailsProvider._();

/// Kept for the session: neither the build nor the phone changes while the app
/// runs.

final class AppDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppDetails>,
          AppDetails,
          FutureOr<AppDetails>
        >
    with $FutureModifier<AppDetails>, $FutureProvider<AppDetails> {
  /// Kept for the session: neither the build nor the phone changes while the app
  /// runs.
  AppDetailsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDetailsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDetailsHash();

  @$internal
  @override
  $FutureProviderElement<AppDetails> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AppDetails> create(Ref ref) {
    return appDetails(ref);
  }
}

String _$appDetailsHash() => r'6cc507fa866258eb3877186383bd060b84ed8166';

@ProviderFor(clearProgress)
final clearProgressProvider = ClearProgressProvider._();

final class ClearProgressProvider
    extends
        $FunctionalProvider<
          ClearProgressFun,
          ClearProgressFun,
          ClearProgressFun
        >
    with $Provider<ClearProgressFun> {
  ClearProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearProgressProvider',
        isAutoDispose: true,
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

String _$clearProgressHash() => r'1ffddebfb6cea7f460f0a0b009e8ad478cad41df';

@ProviderFor(composeEmail)
final composeEmailProvider = ComposeEmailProvider._();

final class ComposeEmailProvider
    extends
        $FunctionalProvider<ComposeEmailFun, ComposeEmailFun, ComposeEmailFun>
    with $Provider<ComposeEmailFun> {
  ComposeEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'composeEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composeEmailHash();

  @$internal
  @override
  $ProviderElement<ComposeEmailFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ComposeEmailFun create(Ref ref) {
    return composeEmail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComposeEmailFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComposeEmailFun>(value),
    );
  }
}

String _$composeEmailHash() => r'0f05ba9ddfb58286b6ae9bf1b34afae434375e41';

@ProviderFor(exportTestStats)
final exportTestStatsProvider = ExportTestStatsProvider._();

final class ExportTestStatsProvider
    extends
        $FunctionalProvider<
          ExportTestStatsFun,
          ExportTestStatsFun,
          ExportTestStatsFun
        >
    with $Provider<ExportTestStatsFun> {
  ExportTestStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportTestStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportTestStatsHash();

  @$internal
  @override
  $ProviderElement<ExportTestStatsFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExportTestStatsFun create(Ref ref) {
    return exportTestStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportTestStatsFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportTestStatsFun>(value),
    );
  }
}

String _$exportTestStatsHash() => r'f01f889e28281dfdc992274c114c94b2f55e6765';

@ProviderFor(settingsStore)
final settingsStoreProvider = SettingsStoreProvider._();

final class SettingsStoreProvider
    extends $FunctionalProvider<SettingsStore, SettingsStore, SettingsStore>
    with $Provider<SettingsStore> {
  SettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStoreHash();

  @$internal
  @override
  $ProviderElement<SettingsStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsStore create(Ref ref) {
    return settingsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsStore>(value),
    );
  }
}

String _$settingsStoreHash() => r'05647355ac49cccbf6759ec30f378b05c0dbcda7';

@ProviderFor(gatherConsent)
final gatherConsentProvider = GatherConsentProvider._();

final class GatherConsentProvider
    extends
        $FunctionalProvider<
          GatherConsentFun,
          GatherConsentFun,
          GatherConsentFun
        >
    with $Provider<GatherConsentFun> {
  GatherConsentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gatherConsentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gatherConsentHash();

  @$internal
  @override
  $ProviderElement<GatherConsentFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GatherConsentFun create(Ref ref) {
    return gatherConsent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GatherConsentFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GatherConsentFun>(value),
    );
  }
}

String _$gatherConsentHash() => r'33abd205ade0c335e21e3ce7a9d8739ae3856a5e';

@ProviderFor(openUrl)
final openUrlProvider = OpenUrlProvider._();

final class OpenUrlProvider
    extends $FunctionalProvider<OpenUrlFun, OpenUrlFun, OpenUrlFun>
    with $Provider<OpenUrlFun> {
  OpenUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openUrlHash();

  @$internal
  @override
  $ProviderElement<OpenUrlFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OpenUrlFun create(Ref ref) {
    return openUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenUrlFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenUrlFun>(value),
    );
  }
}

String _$openUrlHash() => r'4cf4f97aa61ffdcfad2dcbfae0b77540875667d1';

@ProviderFor(setAnalyticsConsent)
final setAnalyticsConsentProvider = SetAnalyticsConsentProvider._();

final class SetAnalyticsConsentProvider
    extends
        $FunctionalProvider<
          SetAnalyticsConsentFun,
          SetAnalyticsConsentFun,
          SetAnalyticsConsentFun
        >
    with $Provider<SetAnalyticsConsentFun> {
  SetAnalyticsConsentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setAnalyticsConsentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setAnalyticsConsentHash();

  @$internal
  @override
  $ProviderElement<SetAnalyticsConsentFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SetAnalyticsConsentFun create(Ref ref) {
    return setAnalyticsConsent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetAnalyticsConsentFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetAnalyticsConsentFun>(value),
    );
  }
}

String _$setAnalyticsConsentHash() =>
    r'01f7bf91c98c6e5176b20eb46b0915666862f075';

@ProviderFor(showPrivacyOptions)
final showPrivacyOptionsProvider = ShowPrivacyOptionsProvider._();

final class ShowPrivacyOptionsProvider
    extends
        $FunctionalProvider<
          ShowPrivacyOptionsFun,
          ShowPrivacyOptionsFun,
          ShowPrivacyOptionsFun
        >
    with $Provider<ShowPrivacyOptionsFun> {
  ShowPrivacyOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showPrivacyOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showPrivacyOptionsHash();

  @$internal
  @override
  $ProviderElement<ShowPrivacyOptionsFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShowPrivacyOptionsFun create(Ref ref) {
    return showPrivacyOptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShowPrivacyOptionsFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShowPrivacyOptionsFun>(value),
    );
  }
}

String _$showPrivacyOptionsHash() =>
    r'aabd89e7728517afce1a4d6f9e33bf32d9583504';
