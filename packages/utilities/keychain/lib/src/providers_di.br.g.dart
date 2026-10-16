// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(keychainRepository)
final keychainRepositoryProvider = KeychainRepositoryProvider._();

final class KeychainRepositoryProvider
    extends
        $FunctionalProvider<
          KeychainRepository,
          KeychainRepository,
          KeychainRepository
        >
    with $Provider<KeychainRepository> {
  KeychainRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keychainRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keychainRepositoryHash();

  @$internal
  @override
  $ProviderElement<KeychainRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeychainRepository create(Ref ref) {
    return keychainRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeychainRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeychainRepository>(value),
    );
  }
}

String _$keychainRepositoryHash() =>
    r'942bf0b079610e971ec194554ea5984f7235fef3';
