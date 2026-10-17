// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_internal.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the tray piece at [index] fits anywhere — cached, so the board scan
/// runs once per change of the board or the tray, not in a widget's selector.

@ProviderFor(trayFits)
final trayFitsProvider = TrayFitsFamily._();

/// Whether the tray piece at [index] fits anywhere — cached, so the board scan
/// runs once per change of the board or the tray, not in a widget's selector.

final class TrayFitsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the tray piece at [index] fits anywhere — cached, so the board scan
  /// runs once per change of the board or the tray, not in a widget's selector.
  TrayFitsProvider._({
    required TrayFitsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'trayFitsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trayFitsHash();

  @override
  String toString() {
    return r'trayFitsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as int;
    return trayFits(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TrayFitsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trayFitsHash() => r'8c943a60f65ba38762a58ae989e05bf3d7102c6f';

/// Whether the tray piece at [index] fits anywhere — cached, so the board scan
/// runs once per change of the board or the tray, not in a widget's selector.

final class TrayFitsFamily extends $Family
    with $FunctionalFamilyOverride<bool, int> {
  TrayFitsFamily._()
    : super(
        retry: null,
        name: r'trayFitsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether the tray piece at [index] fits anywhere — cached, so the board scan
  /// runs once per change of the board or the tray, not in a widget's selector.

  TrayFitsProvider call(int index) =>
      TrayFitsProvider._(argument: index, from: this);

  @override
  String toString() => r'trayFitsProvider';
}
