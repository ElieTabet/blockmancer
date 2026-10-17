// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_feedback.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Plays each move's sounds and haptics as its beats play back, each obeying
/// its own switch in Settings. Reduce motion stills the board, not the sound.
///
/// A skip plays nothing of what it skipped but the move's outcome, so it never
/// sets off a burst of every sound left.

@ProviderFor(GameFeedback)
final gameFeedbackProvider = GameFeedbackProvider._();

/// Plays each move's sounds and haptics as its beats play back, each obeying
/// its own switch in Settings. Reduce motion stills the board, not the sound.
///
/// A skip plays nothing of what it skipped but the move's outcome, so it never
/// sets off a burst of every sound left.
final class GameFeedbackProvider extends $NotifierProvider<GameFeedback, void> {
  /// Plays each move's sounds and haptics as its beats play back, each obeying
  /// its own switch in Settings. Reduce motion stills the board, not the sound.
  ///
  /// A skip plays nothing of what it skipped but the move's outcome, so it never
  /// sets off a burst of every sound left.
  GameFeedbackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameFeedbackProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          gameProvider,
          playbackProvider,
          reduceMotionProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          GameFeedbackProvider.$allTransitiveDependencies0,
          GameFeedbackProvider.$allTransitiveDependencies1,
          GameFeedbackProvider.$allTransitiveDependencies2,
          GameFeedbackProvider.$allTransitiveDependencies3,
          GameFeedbackProvider.$allTransitiveDependencies4,
          GameFeedbackProvider.$allTransitiveDependencies5,
          GameFeedbackProvider.$allTransitiveDependencies6,
          GameFeedbackProvider.$allTransitiveDependencies7,
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
  static final $allTransitiveDependencies5 = playbackProvider;
  static final $allTransitiveDependencies6 =
      PlaybackNotifierProvider.$allTransitiveDependencies5;
  static final $allTransitiveDependencies7 =
      PlaybackNotifierProvider.$allTransitiveDependencies6;

  @override
  String debugGetCreateSourceHash() => _$gameFeedbackHash();

  @$internal
  @override
  GameFeedback create() => GameFeedback();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$gameFeedbackHash() => r'ed650b5fbc813b7a4a740afadda85760e8eb6885';

/// Plays each move's sounds and haptics as its beats play back, each obeying
/// its own switch in Settings. Reduce motion stills the board, not the sound.
///
/// A skip plays nothing of what it skipped but the move's outcome, so it never
/// sets off a burst of every sound left.

abstract class _$GameFeedback extends $Notifier<void> {
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
