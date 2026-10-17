// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_internal.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The platform's reduce-motion setting. Scoped by `GameWidget` from its
/// `MediaQuery`, which only a widget can read.

@ProviderFor(animationsDisabled)
final animationsDisabledProvider = AnimationsDisabledProvider._();

/// The platform's reduce-motion setting. Scoped by `GameWidget` from its
/// `MediaQuery`, which only a widget can read.

final class AnimationsDisabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// The platform's reduce-motion setting. Scoped by `GameWidget` from its
  /// `MediaQuery`, which only a widget can read.
  AnimationsDisabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'animationsDisabledProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$animationsDisabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return animationsDisabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$animationsDisabledHash() =>
    r'112de4b1b2dc561dfed29b214d31d6bcce0eadb4';

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

/// Whether the game keeps still: no squash, no burst, no shake.

@ProviderFor(reduceMotion)
final reduceMotionProvider = ReduceMotionProvider._();

/// Whether the game keeps still: no squash, no burst, no shake.

final class ReduceMotionProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the game keeps still: no squash, no burst, no shake.
  ReduceMotionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reduceMotionProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[animationsDisabledProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ReduceMotionProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = animationsDisabledProvider;

  @override
  String debugGetCreateSourceHash() => _$reduceMotionHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return reduceMotion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reduceMotionHash() => r'fdb575b120a0656058feeba3a603bdcb28976d70';

/// The saved run this screen resumes, loaded by `GamePage` before the game
/// starts; null for any other launch.

@ProviderFor(resumedRun)
final resumedRunProvider = ResumedRunProvider._();

/// The saved run this screen resumes, loaded by `GamePage` before the game
/// starts; null for any other launch.

final class ResumedRunProvider
    extends $FunctionalProvider<SavedRun?, SavedRun?, SavedRun?>
    with $Provider<SavedRun?> {
  /// The saved run this screen resumes, loaded by `GamePage` before the game
  /// starts; null for any other launch.
  ResumedRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumedRunProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$resumedRunHash();

  @$internal
  @override
  $ProviderElement<SavedRun?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SavedRun? create(Ref ref) {
    return resumedRun(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavedRun? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavedRun?>(value),
    );
  }
}

String _$resumedRunHash() => r'62ee5be98fbd8c4707292ae61a6e74840dd76e42';

/// The run's round score, held at what it was before a move until the move's
/// points land in it.

@ProviderFor(roundScoreShown)
final roundScoreShownProvider = RoundScoreShownProvider._();

/// The run's round score, held at what it was before a move until the move's
/// points land in it.

final class RoundScoreShownProvider
    extends
        $FunctionalProvider<RoundScoreShown, RoundScoreShown, RoundScoreShown>
    with $Provider<RoundScoreShown> {
  /// The run's round score, held at what it was before a move until the move's
  /// points land in it.
  RoundScoreShownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roundScoreShownProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[gameProvider, playbackProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          RoundScoreShownProvider.$allTransitiveDependencies0,
          RoundScoreShownProvider.$allTransitiveDependencies1,
          RoundScoreShownProvider.$allTransitiveDependencies2,
          RoundScoreShownProvider.$allTransitiveDependencies3,
          RoundScoreShownProvider.$allTransitiveDependencies4,
          RoundScoreShownProvider.$allTransitiveDependencies5,
        },
      );

  static final $allTransitiveDependencies0 = gameProvider;
  static final $allTransitiveDependencies1 =
      GameNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      GameNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = playbackProvider;
  static final $allTransitiveDependencies4 =
      PlaybackNotifierProvider.$allTransitiveDependencies3;
  static final $allTransitiveDependencies5 =
      PlaybackNotifierProvider.$allTransitiveDependencies4;

  @override
  String debugGetCreateSourceHash() => _$roundScoreShownHash();

  @$internal
  @override
  $ProviderElement<RoundScoreShown> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoundScoreShown create(Ref ref) {
    return roundScoreShown(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoundScoreShown value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoundScoreShown>(value),
    );
  }
}

String _$roundScoreShownHash() => r'4ef44f87d18f1f81aa008420547b0251c497fa71';

/// The run as the run total and the streak show it: the run before a move
/// until the move's points land, so neither runs ahead of the count-up.

@ProviderFor(shownRun)
final shownRunProvider = ShownRunProvider._();

/// The run as the run total and the streak show it: the run before a move
/// until the move's points land, so neither runs ahead of the count-up.

final class ShownRunProvider
    extends $FunctionalProvider<RunState, RunState, RunState>
    with $Provider<RunState> {
  /// The run as the run total and the streak show it: the run before a move
  /// until the move's points land, so neither runs ahead of the count-up.
  ShownRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shownRunProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[gameProvider, playbackProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          ShownRunProvider.$allTransitiveDependencies0,
          ShownRunProvider.$allTransitiveDependencies1,
          ShownRunProvider.$allTransitiveDependencies2,
          ShownRunProvider.$allTransitiveDependencies3,
          ShownRunProvider.$allTransitiveDependencies4,
          ShownRunProvider.$allTransitiveDependencies5,
        },
      );

  static final $allTransitiveDependencies0 = gameProvider;
  static final $allTransitiveDependencies1 =
      GameNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      GameNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = playbackProvider;
  static final $allTransitiveDependencies4 =
      PlaybackNotifierProvider.$allTransitiveDependencies3;
  static final $allTransitiveDependencies5 =
      PlaybackNotifierProvider.$allTransitiveDependencies4;

  @override
  String debugGetCreateSourceHash() => _$shownRunHash();

  @$internal
  @override
  $ProviderElement<RunState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RunState create(Ref ref) {
    return shownRun(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunState>(value),
    );
  }
}

String _$shownRunHash() => r'189463b31c0104374e67b34166cc17bb49c180d2';

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
  static final $allTransitiveDependencies2 =
      GameNotifierProvider.$allTransitiveDependencies1;

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
          TrayFitsProvider.$allTransitiveDependencies2,
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
