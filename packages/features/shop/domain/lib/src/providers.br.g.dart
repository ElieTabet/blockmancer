// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Remove ads' price for this player, or null while the store can't say.

@ProviderFor(removeAdsPrice)
final removeAdsPriceProvider = RemoveAdsPriceProvider._();

/// Remove ads' price for this player, or null while the store can't say.

final class RemoveAdsPriceProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Remove ads' price for this player, or null while the store can't say.
  RemoveAdsPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeAdsPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeAdsPriceHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return removeAdsPrice(ref);
  }
}

String _$removeAdsPriceHash() => r'be3fbb8f7a8d88152695e9e86533563a334ed5b6';
