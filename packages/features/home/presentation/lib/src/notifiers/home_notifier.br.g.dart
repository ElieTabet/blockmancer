// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Home's choices. Holds nothing: it forwards each to [HomeRouting].

@ProviderFor(HomeNotifier)
final homeProvider = HomeNotifierProvider._();

/// Home's choices. Holds nothing: it forwards each to [HomeRouting].
final class HomeNotifierProvider extends $NotifierProvider<HomeNotifier, void> {
  /// Home's choices. Holds nothing: it forwards each to [HomeRouting].
  HomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeNotifierHash();

  @$internal
  @override
  HomeNotifier create() => HomeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$homeNotifierHash() => r'7ab4b4ffa55171bf6943d410ecb754b60f9ad680';

/// Home's choices. Holds nothing: it forwards each to [HomeRouting].

abstract class _$HomeNotifier extends $Notifier<void> {
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
