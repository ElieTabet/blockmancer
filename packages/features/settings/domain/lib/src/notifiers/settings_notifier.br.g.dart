// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The player's settings, read once and kept for as long as the app runs.
///
/// A change shows at once and is written after. Writes land in the order they
/// were made, so the last change is the one kept; one that fails is logged,
/// and the change still holds until the app closes.

@ProviderFor(SettingsNotifier)
final settingsProvider = SettingsNotifierProvider._();

/// The player's settings, read once and kept for as long as the app runs.
///
/// A change shows at once and is written after. Writes land in the order they
/// were made, so the last change is the one kept; one that fails is logged,
/// and the change still holds until the app closes.
final class SettingsNotifierProvider
    extends $AsyncNotifierProvider<SettingsNotifier, AppSettings> {
  /// The player's settings, read once and kept for as long as the app runs.
  ///
  /// A change shows at once and is written after. Writes land in the order they
  /// were made, so the last change is the one kept; one that fails is logged,
  /// and the change still holds until the app closes.
  SettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsNotifierHash();

  @$internal
  @override
  SettingsNotifier create() => SettingsNotifier();
}

String _$settingsNotifierHash() => r'8abdc8f8cb18a2f75cc4b90d757ecfb3959ac719';

/// The player's settings, read once and kept for as long as the app runs.
///
/// A change shows at once and is written after. Writes land in the order they
/// were made, so the last change is the one kept; one that fails is logged,
/// and the change still holds until the app closes.

abstract class _$SettingsNotifier extends $AsyncNotifier<AppSettings> {
  FutureOr<AppSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppSettings>, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppSettings>, AppSettings>,
              AsyncValue<AppSettings>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
