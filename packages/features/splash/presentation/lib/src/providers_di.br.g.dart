// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checkAppStatus)
final checkAppStatusProvider = CheckAppStatusProvider._();

final class CheckAppStatusProvider
    extends
        $FunctionalProvider<
          CheckAppStatusFun,
          CheckAppStatusFun,
          CheckAppStatusFun
        >
    with $Provider<CheckAppStatusFun> {
  CheckAppStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkAppStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkAppStatusHash();

  @$internal
  @override
  $ProviderElement<CheckAppStatusFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckAppStatusFun create(Ref ref) {
    return checkAppStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckAppStatusFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckAppStatusFun>(value),
    );
  }
}

String _$checkAppStatusHash() => r'1ec620a60c963c2a66626387599d4c58b0acd2eb';

@ProviderFor(prepareDevice)
final prepareDeviceProvider = PrepareDeviceProvider._();

final class PrepareDeviceProvider
    extends
        $FunctionalProvider<
          PrepareDeviceFun,
          PrepareDeviceFun,
          PrepareDeviceFun
        >
    with $Provider<PrepareDeviceFun> {
  PrepareDeviceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prepareDeviceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prepareDeviceHash();

  @$internal
  @override
  $ProviderElement<PrepareDeviceFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrepareDeviceFun create(Ref ref) {
    return prepareDevice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrepareDeviceFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrepareDeviceFun>(value),
    );
  }
}

String _$prepareDeviceHash() => r'5d4ef13e02dd0962dc580105f50c9791cc06acc8';

@ProviderFor(refreshSettings)
final refreshSettingsProvider = RefreshSettingsProvider._();

final class RefreshSettingsProvider
    extends
        $FunctionalProvider<
          RefreshSettingsFun,
          RefreshSettingsFun,
          RefreshSettingsFun
        >
    with $Provider<RefreshSettingsFun> {
  RefreshSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshSettingsHash();

  @$internal
  @override
  $ProviderElement<RefreshSettingsFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefreshSettingsFun create(Ref ref) {
    return refreshSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefreshSettingsFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefreshSettingsFun>(value),
    );
  }
}

String _$refreshSettingsHash() => r'f100a2cb20efcdf5d5073b17c9d6be4ad67cdda7';

/// Whether a member is authenticated. Deliberately a bool, not a token: splash
/// must not learn what a session is made of, and must not have to know that an
/// install which never signed in still holds a perfectly live guest token.

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Whether a member is authenticated. Deliberately a bool, not a token: splash
/// must not learn what a session is made of, and must not have to know that an
/// install which never signed in still holds a perfectly live guest token.

final class IsAuthenticatedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether a member is authenticated. Deliberately a bool, not a token: splash
  /// must not learn what a session is made of, and must not have to know that an
  /// install which never signed in still holds a perfectly live guest token.
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isAuthenticated(ref);
  }
}

String _$isAuthenticatedHash() => r'dfde49c264e4e555ce1e66cc9b1028157ea8d04d';

@ProviderFor(splashRouting)
final splashRoutingProvider = SplashRoutingProvider._();

final class SplashRoutingProvider
    extends $FunctionalProvider<SplashRouting, SplashRouting, SplashRouting>
    with $Provider<SplashRouting> {
  SplashRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashRoutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashRoutingHash();

  @$internal
  @override
  $ProviderElement<SplashRouting> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SplashRouting create(Ref ref) {
    return splashRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplashRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplashRouting>(value),
    );
  }
}

String _$splashRoutingHash() => r'ba8ad3557c45a961cb69859c0098734e1ee39364';
