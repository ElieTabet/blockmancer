// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The guided first run's coach: the step the player is on, or null in any
/// other run and once the tutorial is done or skipped.
///
/// It follows the game: the first piece placed, then a line cleared, whose
/// score holds on `chips × mult` until a touch. Once the score has landed it
/// hands over to a practice run, whose starting pick is the last step.

@ProviderFor(TutorialNotifier)
final tutorialProvider = TutorialNotifierProvider._();

/// The guided first run's coach: the step the player is on, or null in any
/// other run and once the tutorial is done or skipped.
///
/// It follows the game: the first piece placed, then a line cleared, whose
/// score holds on `chips × mult` until a touch. Once the score has landed it
/// hands over to a practice run, whose starting pick is the last step.
final class TutorialNotifierProvider
    extends $NotifierProvider<TutorialNotifier, TutorialStep?> {
  /// The guided first run's coach: the step the player is on, or null in any
  /// other run and once the tutorial is done or skipped.
  ///
  /// It follows the game: the first piece placed, then a line cleared, whose
  /// score holds on `chips × mult` until a touch. Once the score has landed it
  /// hands over to a practice run, whose starting pick is the last step.
  TutorialNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tutorialProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          gameLaunchProvider,
          gameProvider,
          playbackProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          TutorialNotifierProvider.$allTransitiveDependencies0,
          TutorialNotifierProvider.$allTransitiveDependencies1,
          TutorialNotifierProvider.$allTransitiveDependencies2,
          TutorialNotifierProvider.$allTransitiveDependencies3,
          TutorialNotifierProvider.$allTransitiveDependencies4,
          TutorialNotifierProvider.$allTransitiveDependencies5,
        },
      );

  static final $allTransitiveDependencies0 = gameLaunchProvider;
  static final $allTransitiveDependencies1 = gameProvider;
  static final $allTransitiveDependencies2 =
      GameNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = playbackProvider;
  static final $allTransitiveDependencies4 =
      PlaybackNotifierProvider.$allTransitiveDependencies3;
  static final $allTransitiveDependencies5 =
      PlaybackNotifierProvider.$allTransitiveDependencies4;

  @override
  String debugGetCreateSourceHash() => _$tutorialNotifierHash();

  @$internal
  @override
  TutorialNotifier create() => TutorialNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TutorialStep? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TutorialStep?>(value),
    );
  }
}

String _$tutorialNotifierHash() => r'e8a2b7409e3fb1e99011b0d7b4bcb889d93d17c9';

/// The guided first run's coach: the step the player is on, or null in any
/// other run and once the tutorial is done or skipped.
///
/// It follows the game: the first piece placed, then a line cleared, whose
/// score holds on `chips × mult` until a touch. Once the score has landed it
/// hands over to a practice run, whose starting pick is the last step.

abstract class _$TutorialNotifier extends $Notifier<TutorialStep?> {
  TutorialStep? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TutorialStep?, TutorialStep?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TutorialStep?, TutorialStep?>,
              TutorialStep?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
