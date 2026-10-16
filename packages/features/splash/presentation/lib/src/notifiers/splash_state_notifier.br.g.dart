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
    extends $NotifierProvider<SplashStateNotifier, void> {
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
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$splashStateNotifierHash() =>
    r'5d71b17c32aba53e5190b1aebff51b75f010b050';

abstract class _$SplashStateNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
