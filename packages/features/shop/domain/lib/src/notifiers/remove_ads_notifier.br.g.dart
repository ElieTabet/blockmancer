// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_ads_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the player owns Remove ads: kept on the device, and confirmed by
/// every purchase or restore the store reports, from launch on. Nothing ever
/// takes it back (a refund is the store's to handle).

@ProviderFor(RemoveAdsNotifier)
final removeAdsProvider = RemoveAdsNotifierProvider._();

/// Whether the player owns Remove ads: kept on the device, and confirmed by
/// every purchase or restore the store reports, from launch on. Nothing ever
/// takes it back (a refund is the store's to handle).
final class RemoveAdsNotifierProvider
    extends $AsyncNotifierProvider<RemoveAdsNotifier, bool> {
  /// Whether the player owns Remove ads: kept on the device, and confirmed by
  /// every purchase or restore the store reports, from launch on. Nothing ever
  /// takes it back (a refund is the store's to handle).
  RemoveAdsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeAdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeAdsNotifierHash();

  @$internal
  @override
  RemoveAdsNotifier create() => RemoveAdsNotifier();
}

String _$removeAdsNotifierHash() => r'67d328cea53bd69f19708074ac3b1bcbf9693790';

/// Whether the player owns Remove ads: kept on the device, and confirmed by
/// every purchase or restore the store reports, from launch on. Nothing ever
/// takes it back (a refund is the store's to handle).

abstract class _$RemoveAdsNotifier extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
