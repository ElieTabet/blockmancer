// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This build's version, as the stores know it (`1.0.0`).

@ProviderFor(appVersion)
final appVersionProvider = AppVersionProvider._();

/// This build's version, as the stores know it (`1.0.0`).

final class AppVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// This build's version, as the stores know it (`1.0.0`).
  AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return appVersion(ref);
  }
}

String _$appVersionHash() => r'2033e49eec6555757226a5c67f3c984b8dc77554';

@ProviderFor(remoteValue)
final remoteValueProvider = RemoteValueProvider._();

final class RemoteValueProvider
    extends $FunctionalProvider<RemoteValueFun, RemoteValueFun, RemoteValueFun>
    with $Provider<RemoteValueFun> {
  RemoteValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValueHash();

  @$internal
  @override
  $ProviderElement<RemoteValueFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteValueFun create(Ref ref) {
    return remoteValue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteValueFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteValueFun>(value),
    );
  }
}

String _$remoteValueHash() => r'fbb114e2b7619ca4e1415339f8708000819c098a';

/// Completes once the launch's Remote Config fetch has landed or given up.

@ProviderFor(remoteValuesFetched)
final remoteValuesFetchedProvider = RemoteValuesFetchedProvider._();

/// Completes once the launch's Remote Config fetch has landed or given up.

final class RemoteValuesFetchedProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Completes once the launch's Remote Config fetch has landed or given up.
  RemoteValuesFetchedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValuesFetchedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValuesFetchedHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return remoteValuesFetched(ref);
  }
}

String _$remoteValuesFetchedHash() =>
    r'bf1b01d549a139e0718b737272f9af381b6b9a44';

@ProviderFor(storePlatform)
final storePlatformProvider = StorePlatformProvider._();

final class StorePlatformProvider
    extends $FunctionalProvider<StorePlatform, StorePlatform, StorePlatform>
    with $Provider<StorePlatform> {
  StorePlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storePlatformProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storePlatformHash();

  @$internal
  @override
  $ProviderElement<StorePlatform> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StorePlatform create(Ref ref) {
    return storePlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StorePlatform value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StorePlatform>(value),
    );
  }
}

String _$storePlatformHash() => r'65cc31d22a2e489ffb4474be0f25850ef205c369';

/// Each store's page for the app.

@ProviderFor(storeUrls)
final storeUrlsProvider = StoreUrlsProvider._();

/// Each store's page for the app.

final class StoreUrlsProvider
    extends
        $FunctionalProvider<
          ({String android, String ios}),
          ({String android, String ios}),
          ({String android, String ios})
        >
    with $Provider<({String android, String ios})> {
  /// Each store's page for the app.
  StoreUrlsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeUrlsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeUrlsHash();

  @$internal
  @override
  $ProviderElement<({String android, String ios})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({String android, String ios}) create(Ref ref) {
    return storeUrls(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({String android, String ios}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({String android, String ios})>(
        value,
      ),
    );
  }
}

String _$storeUrlsHash() => r'92782400b4c676ab698a2c830d415543353c59c3';

@ProviderFor(updateDismissals)
final updateDismissalsProvider = UpdateDismissalsProvider._();

final class UpdateDismissalsProvider
    extends
        $FunctionalProvider<
          UpdateDismissals,
          UpdateDismissals,
          UpdateDismissals
        >
    with $Provider<UpdateDismissals> {
  UpdateDismissalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateDismissalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateDismissalsHash();

  @$internal
  @override
  $ProviderElement<UpdateDismissals> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateDismissals create(Ref ref) {
    return updateDismissals(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateDismissals value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateDismissals>(value),
    );
  }
}

String _$updateDismissalsHash() => r'40838412438bc48fac79b3a97b4706008a30ca9e';
