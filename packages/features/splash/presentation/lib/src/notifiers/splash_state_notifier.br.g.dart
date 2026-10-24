// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_state_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplashStateNotifier)
final splashStateProvider = SplashStateNotifierProvider._();

final class SplashStateNotifierProvider
    extends $NotifierProvider<SplashStateNotifier, SplashStage> {
  SplashStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashStateNotifierHash();

  @$internal
  @override
  SplashStateNotifier create() => SplashStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplashStage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplashStage>(value),
    );
  }
}

String _$splashStateNotifierHash() =>
    r'd74e87f59a5d7a6ee1a5c5f80a44b82615eda91d';

abstract class _$SplashStateNotifier extends $Notifier<SplashStage> {
  SplashStage build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SplashStage, SplashStage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SplashStage, SplashStage>,
              SplashStage,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
