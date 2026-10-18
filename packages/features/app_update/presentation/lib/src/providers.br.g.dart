// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Opens this build's page in its store: the update screen's button, and the
/// map's update banner.

@ProviderFor(openStoreListing)
final openStoreListingProvider = OpenStoreListingProvider._();

/// Opens this build's page in its store: the update screen's button, and the
/// map's update banner.

final class OpenStoreListingProvider
    extends
        $FunctionalProvider<
          OpenStoreListingFun,
          OpenStoreListingFun,
          OpenStoreListingFun
        >
    with $Provider<OpenStoreListingFun> {
  /// Opens this build's page in its store: the update screen's button, and the
  /// map's update banner.
  OpenStoreListingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openStoreListingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openStoreListingHash();

  @$internal
  @override
  $ProviderElement<OpenStoreListingFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenStoreListingFun create(Ref ref) {
    return openStoreListing(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenStoreListingFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenStoreListingFun>(value),
    );
  }
}

String _$openStoreListingHash() => r'fdfeba87a524d3c608301b5bd0f545f6fd72ca1a';
