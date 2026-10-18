// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Settings' choices. Holds nothing: each change is the player's settings to
/// keep, and closing is [SettingsRouting]'s to follow.

@ProviderFor(SettingsStateNotifier)
final settingsStateProvider = SettingsStateNotifierProvider._();

/// Settings' choices. Holds nothing: each change is the player's settings to
/// keep, and closing is [SettingsRouting]'s to follow.
final class SettingsStateNotifierProvider
    extends $NotifierProvider<SettingsStateNotifier, void> {
  /// Settings' choices. Holds nothing: each change is the player's settings to
  /// keep, and closing is [SettingsRouting]'s to follow.
  SettingsStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStateNotifierHash();

  @$internal
  @override
  SettingsStateNotifier create() => SettingsStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$settingsStateNotifierHash() =>
    r'09c81ca7d4ebfe3d0eb9f3dca484945a591d6f37';

/// Settings' choices. Holds nothing: each change is the player's settings to
/// keep, and closing is [SettingsRouting]'s to follow.

abstract class _$SettingsStateNotifier extends $Notifier<void> {
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
