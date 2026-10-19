// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appUpdateRouting)
final appUpdateRoutingProvider = AppUpdateRoutingProvider._();

final class AppUpdateRoutingProvider
    extends
        $FunctionalProvider<
          AppUpdateRouting,
          AppUpdateRouting,
          AppUpdateRouting
        >
    with $Provider<AppUpdateRouting> {
  AppUpdateRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdateRoutingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdateRoutingHash();

  @$internal
  @override
  $ProviderElement<AppUpdateRouting> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppUpdateRouting create(Ref ref) {
    return appUpdateRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUpdateRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUpdateRouting>(value),
    );
  }
}

String _$appUpdateRoutingHash() => r'3826f5bb77908440fbe046e1793025104aa5dba8';

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

@ProviderFor(whenGameSettled)
final whenGameSettledProvider = WhenGameSettledProvider._();

final class WhenGameSettledProvider
    extends $FunctionalProvider<WhenSettledFun, WhenSettledFun, WhenSettledFun>
    with $Provider<WhenSettledFun> {
  WhenGameSettledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'whenGameSettledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$whenGameSettledHash();

  @$internal
  @override
  $ProviderElement<WhenSettledFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WhenSettledFun create(Ref ref) {
    return whenGameSettled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WhenSettledFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WhenSettledFun>(value),
    );
  }
}

String _$whenGameSettledHash() => r'd2cb7b6a2cf4abc41f9db631727f73038032feb3';
