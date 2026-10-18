// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drag_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The drag shadow. Updated only when the hovered cell changes, not on every
/// pointer move: the finger itself is tracked outside Riverpod.

@ProviderFor(DragNotifier)
final dragProvider = DragNotifierProvider._();

/// The drag shadow. Updated only when the hovered cell changes, not on every
/// pointer move: the finger itself is tracked outside Riverpod.
final class DragNotifierProvider
    extends $NotifierProvider<DragNotifier, DragPreview?> {
  /// The drag shadow. Updated only when the hovered cell changes, not on every
  /// pointer move: the finger itself is tracked outside Riverpod.
  DragNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dragProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[gameProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          DragNotifierProvider.$allTransitiveDependencies0,
          DragNotifierProvider.$allTransitiveDependencies1,
          DragNotifierProvider.$allTransitiveDependencies2,
          DragNotifierProvider.$allTransitiveDependencies3,
          DragNotifierProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = gameProvider;
  static final $allTransitiveDependencies1 =
      GameNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      GameNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 =
      GameNotifierProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies4 =
      GameNotifierProvider.$allTransitiveDependencies3;

  @override
  String debugGetCreateSourceHash() => _$dragNotifierHash();

  @$internal
  @override
  DragNotifier create() => DragNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DragPreview? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DragPreview?>(value),
    );
  }
}

String _$dragNotifierHash() => r'd9760ef9be3ae5257cf44ea112f021229a0ab121';

/// The drag shadow. Updated only when the hovered cell changes, not on every
/// pointer move: the finger itself is tracked outside Riverpod.

abstract class _$DragNotifier extends $Notifier<DragPreview?> {
  DragPreview? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DragPreview?, DragPreview?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DragPreview?, DragPreview?>,
              DragPreview?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
