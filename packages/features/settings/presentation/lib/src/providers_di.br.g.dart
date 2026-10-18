// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Crashes the app on purpose, so a test build can check that crash reports
/// arrive.

@ProviderFor(crashForTest)
final crashForTestProvider = CrashForTestProvider._();

/// Crashes the app on purpose, so a test build can check that crash reports
/// arrive.

final class CrashForTestProvider
    extends $FunctionalProvider<VoidCallback, VoidCallback, VoidCallback>
    with $Provider<VoidCallback> {
  /// Crashes the app on purpose, so a test build can check that crash reports
  /// arrive.
  CrashForTestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashForTestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashForTestHash();

  @$internal
  @override
  $ProviderElement<VoidCallback> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VoidCallback create(Ref ref) {
    return crashForTest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoidCallback value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoidCallback>(value),
    );
  }
}

String _$crashForTestHash() => r'd71e975bffe2a70b3d1c52fcd70c442f49c392a6';

@ProviderFor(settingsRouting)
final settingsRoutingProvider = SettingsRoutingProvider._();

final class SettingsRoutingProvider
    extends
        $FunctionalProvider<SettingsRouting, SettingsRouting, SettingsRouting>
    with $Provider<SettingsRouting> {
  SettingsRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRoutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRoutingHash();

  @$internal
  @override
  $ProviderElement<SettingsRouting> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsRouting create(Ref ref) {
    return settingsRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRouting>(value),
    );
  }
}

String _$settingsRoutingHash() => r'b913401b744fbac8a72e25f0b825329f4e947e78';

@ProviderFor(shareText)
final shareTextProvider = ShareTextProvider._();

final class ShareTextProvider
    extends $FunctionalProvider<ShareTextFun, ShareTextFun, ShareTextFun>
    with $Provider<ShareTextFun> {
  ShareTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareTextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareTextHash();

  @$internal
  @override
  $ProviderElement<ShareTextFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareTextFun create(Ref ref) {
    return shareText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareTextFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareTextFun>(value),
    );
  }
}

String _$shareTextHash() => r'f6a677fe8bfba5ea4a84f8a40c6d68da24331426';

/// Whether this is a test build, whose testers get their own rows: sharing
/// the play stats and a test crash.

@ProviderFor(showsTestTools)
final showsTestToolsProvider = ShowsTestToolsProvider._();

/// Whether this is a test build, whose testers get their own rows: sharing
/// the play stats and a test crash.

final class ShowsTestToolsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this is a test build, whose testers get their own rows: sharing
  /// the play stats and a test crash.
  ShowsTestToolsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showsTestToolsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showsTestToolsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return showsTestTools(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showsTestToolsHash() => r'ff21a4d8b92d038da39d366526232f105e1f77df';
