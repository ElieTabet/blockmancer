// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
