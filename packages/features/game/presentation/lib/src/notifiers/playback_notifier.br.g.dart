// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Plays each move back beat by beat (see [beatsFor]). The screen takes no
/// input while it plays, so a finger already reaching for the next piece
/// doesn't play it before the last one has been seen.

@ProviderFor(PlaybackNotifier)
final playbackProvider = PlaybackNotifierProvider._();

/// Plays each move back beat by beat (see [beatsFor]). The screen takes no
/// input while it plays, so a finger already reaching for the next piece
/// doesn't play it before the last one has been seen.
final class PlaybackNotifierProvider
    extends $NotifierProvider<PlaybackNotifier, PlaybackState> {
  /// Plays each move back beat by beat (see [beatsFor]). The screen takes no
  /// input while it plays, so a finger already reaching for the next piece
  /// doesn't play it before the last one has been seen.
  PlaybackNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[gameProvider, reduceMotionProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          PlaybackNotifierProvider.$allTransitiveDependencies0,
          PlaybackNotifierProvider.$allTransitiveDependencies1,
          PlaybackNotifierProvider.$allTransitiveDependencies2,
          PlaybackNotifierProvider.$allTransitiveDependencies3,
          PlaybackNotifierProvider.$allTransitiveDependencies4,
          PlaybackNotifierProvider.$allTransitiveDependencies5,
          PlaybackNotifierProvider.$allTransitiveDependencies6,
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
  static final $allTransitiveDependencies5 = reduceMotionProvider;
  static final $allTransitiveDependencies6 =
      ReduceMotionProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$playbackNotifierHash();

  @$internal
  @override
  PlaybackNotifier create() => PlaybackNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaybackState>(value),
    );
  }
}

String _$playbackNotifierHash() => r'a16d1a9ffbda30bd0812daa5ddfb992972c5216b';

/// Plays each move back beat by beat (see [beatsFor]). The screen takes no
/// input while it plays, so a finger already reaching for the next piece
/// doesn't play it before the last one has been seen.

abstract class _$PlaybackNotifier extends $Notifier<PlaybackState> {
  PlaybackState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlaybackState, PlaybackState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlaybackState, PlaybackState>,
              PlaybackState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
