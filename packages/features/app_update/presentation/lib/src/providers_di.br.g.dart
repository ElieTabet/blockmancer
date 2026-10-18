// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
