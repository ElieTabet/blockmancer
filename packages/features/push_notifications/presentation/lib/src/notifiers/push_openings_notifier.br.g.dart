// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_openings_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Opens what each tapped push is about, for as long as the app runs.
///
/// `keepAlive`, and started once at boot: a tap can arrive at any moment, and
/// the push that launched the app is read exactly once. It watches rather than
/// reads, so the slots behind the stream live as long as it does — taps are
/// only listened for after the launch push is known, a platform round trip
/// later.

@ProviderFor(PushOpeningsNotifier)
final pushOpeningsProvider = PushOpeningsNotifierProvider._();

/// Opens what each tapped push is about, for as long as the app runs.
///
/// `keepAlive`, and started once at boot: a tap can arrive at any moment, and
/// the push that launched the app is read exactly once. It watches rather than
/// reads, so the slots behind the stream live as long as it does — taps are
/// only listened for after the launch push is known, a platform round trip
/// later.
final class PushOpeningsNotifierProvider
    extends $NotifierProvider<PushOpeningsNotifier, void> {
  /// Opens what each tapped push is about, for as long as the app runs.
  ///
  /// `keepAlive`, and started once at boot: a tap can arrive at any moment, and
  /// the push that launched the app is read exactly once. It watches rather than
  /// reads, so the slots behind the stream live as long as it does — taps are
  /// only listened for after the launch push is known, a platform round trip
  /// later.
  PushOpeningsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushOpeningsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushOpeningsNotifierHash();

  @$internal
  @override
  PushOpeningsNotifier create() => PushOpeningsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushOpeningsNotifierHash() =>
    r'b57df879bd15c656e2ba5ef118e9e6a81d16bef3';

/// Opens what each tapped push is about, for as long as the app runs.
///
/// `keepAlive`, and started once at boot: a tap can arrive at any moment, and
/// the push that launched the app is read exactly once. It watches rather than
/// reads, so the slots behind the stream live as long as it does — taps are
/// only listened for after the launch push is known, a platform round trip
/// later.

abstract class _$PushOpeningsNotifier extends $Notifier<void> {
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
