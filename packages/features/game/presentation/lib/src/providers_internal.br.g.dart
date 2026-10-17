// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_internal.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What this game screen was opened to play. Scoped by `GamePage`, which each
/// route push builds afresh, so every visit plays its own run.

@ProviderFor(gameLaunch)
final gameLaunchProvider = GameLaunchProvider._();

/// What this game screen was opened to play. Scoped by `GamePage`, which each
/// route push builds afresh, so every visit plays its own run.

final class GameLaunchProvider
    extends $FunctionalProvider<GameLaunch, GameLaunch, GameLaunch>
    with $Provider<GameLaunch> {
  /// What this game screen was opened to play. Scoped by `GamePage`, which each
  /// route push builds afresh, so every visit plays its own run.
  GameLaunchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameLaunchProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$gameLaunchHash();

  @$internal
  @override
  $ProviderElement<GameLaunch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameLaunch create(Ref ref) {
    return gameLaunch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameLaunch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameLaunch>(value),
    );
  }
}

String _$gameLaunchHash() => r'e51edee4c82db8687ffb8ccaa510735fef6fa061';

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

  static final $allTransitiveDependencies0 = gameProvider;
  static final $allTransitiveDependencies1 =
      GameNotifierProvider.$allTransitiveDependencies0;

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

String _$trayFitsHash() => r'd639cf6d6f030c2158cd04fdafb6b1e384e0b55c';

/// Whether the tray piece at [index] fits anywhere — cached, so the board scan
/// runs once per change of the board or the tray, not in a widget's selector.

final class TrayFitsFamily extends $Family
    with $FunctionalFamilyOverride<bool, int> {
  TrayFitsFamily._()
    : super(
        retry: null,
        name: r'trayFitsProvider',
        dependencies: <ProviderOrFamily>[gameProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          TrayFitsProvider.$allTransitiveDependencies0,
          TrayFitsProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  /// Whether the tray piece at [index] fits anywhere — cached, so the board scan
  /// runs once per change of the board or the tray, not in a widget's selector.

  TrayFitsProvider call(int index) =>
      TrayFitsProvider._(argument: index, from: this);

  @override
  String toString() => r'trayFitsProvider';
}
