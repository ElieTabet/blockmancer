// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What this version has to do, once the launch's fetch has landed (or
/// [_fetchWait] has passed).

@ProviderFor(updateNeed)
final updateNeedProvider = UpdateNeedProvider._();

/// What this version has to do, once the launch's fetch has landed (or
/// [_fetchWait] has passed).

final class UpdateNeedProvider
    extends
        $FunctionalProvider<
          AsyncValue<UpdateNeed>,
          UpdateNeed,
          FutureOr<UpdateNeed>
        >
    with $FutureModifier<UpdateNeed>, $FutureProvider<UpdateNeed> {
  /// What this version has to do, once the launch's fetch has landed (or
  /// [_fetchWait] has passed).
  UpdateNeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateNeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateNeedHash();

  @$internal
  @override
  $FutureProviderElement<UpdateNeed> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UpdateNeed> create(Ref ref) {
    return updateNeed(ref);
  }
}

String _$updateNeedHash() => r'4d5a0f56214e3d75e69b4110d0665ac5f7fcab65';

/// Whether this version no longer plays.

@ProviderFor(updateRequired)
final updateRequiredProvider = UpdateRequiredProvider._();

/// Whether this version no longer plays.

final class UpdateRequiredProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether this version no longer plays.
  UpdateRequiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateRequiredProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateRequiredHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return updateRequired(ref);
  }
}

String _$updateRequiredHash() => r'dbe66f6f52228be450b1868549ce69a76cbe042c';

/// The newer version to offer, or null when there is none or its banner was
/// already closed.

@ProviderFor(updateOffer)
final updateOfferProvider = UpdateOfferProvider._();

/// The newer version to offer, or null when there is none or its banner was
/// already closed.

final class UpdateOfferProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The newer version to offer, or null when there is none or its banner was
  /// already closed.
  UpdateOfferProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateOfferProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateOfferHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return updateOffer(ref);
  }
}

String _$updateOfferHash() => r'f55c89ccbdaf538004e476af9c303f13c188dc2e';

/// Closes the banner for the version it offers, for good.
///
/// Kept alive because it refreshes [updateOfferProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

@ProviderFor(dismissUpdateOffer)
final dismissUpdateOfferProvider = DismissUpdateOfferProvider._();

/// Closes the banner for the version it offers, for good.
///
/// Kept alive because it refreshes [updateOfferProvider] after an await, by
/// when an auto-disposed provider's ref may be gone.

final class DismissUpdateOfferProvider
    extends
        $FunctionalProvider<
          DismissUpdateOfferFun,
          DismissUpdateOfferFun,
          DismissUpdateOfferFun
        >
    with $Provider<DismissUpdateOfferFun> {
  /// Closes the banner for the version it offers, for good.
  ///
  /// Kept alive because it refreshes [updateOfferProvider] after an await, by
  /// when an auto-disposed provider's ref may be gone.
  DismissUpdateOfferProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dismissUpdateOfferProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dismissUpdateOfferHash();

  @$internal
  @override
  $ProviderElement<DismissUpdateOfferFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DismissUpdateOfferFun create(Ref ref) {
    return dismissUpdateOffer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DismissUpdateOfferFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DismissUpdateOfferFun>(value),
    );
  }
}

String _$dismissUpdateOfferHash() =>
    r'ed4cb343b565991e759a4790615b2e5f9c6a637c';

/// This build's store page.

@ProviderFor(storeUrl)
final storeUrlProvider = StoreUrlProvider._();

/// This build's store page.

final class StoreUrlProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// This build's store page.
  StoreUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return storeUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$storeUrlHash() => r'bd87a2b35471fa1e804e411eb803d9a98d0c2dd6';
