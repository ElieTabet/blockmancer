// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
