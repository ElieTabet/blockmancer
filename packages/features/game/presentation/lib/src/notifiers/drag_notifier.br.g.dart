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
        dependencies: null,
        $allTransitiveDependencies: null,
      );

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

String _$dragNotifierHash() => r'047d7a930a47aa84611ec6bebd1a2e04458edd7e';

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
