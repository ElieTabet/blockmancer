import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/entities/tutorial_step.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_ui_state.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/package_name.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

part 'tutorial_notifier.br.g.dart';

/// The guided first run's coach: the step the player is on, or null in any
/// other run and once the tutorial is done or skipped.
///
/// It follows the game: the first piece placed, then a line cleared, whose
/// score holds on `chips × mult` until a touch. Once the score has landed it
/// hands over to a practice run, whose starting pick is the last step.
@Riverpod(dependencies: [gameLaunch, GameNotifier, PlaybackNotifier])
class TutorialNotifier extends _$TutorialNotifier {
  @override
  TutorialStep? build() {
    if (ref.watch(gameLaunchProvider) != .tutorial) return null;

    ref
      ..listen(gameProvider, _onGame)
      ..listen(
        playbackProvider.select((playback) => playback.isPlaying),
        _onPlayback,
      );

    return .drag;
  }

  /// Leaves the tutorial for a practice run, its starting pick included.
  void skip() {
    final step = state;

    if (step == null) return;

    state = null;
    unawaited(_markSeen());

    if (step != .pick) ref.read(gameProvider.notifier).playPractice();
  }

  Future<void> _markSeen() async {
    final markTutorialSeen = ref.read(markTutorialSeenProvider);

    try {
      await markTutorialSeen();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Keeping the tutorial as seen failed; it will show again',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _onGame(GameUiState? previous, GameUiState next) {
    if (previous == null || previous.moveCount == next.moveCount) return;

    final events = next.lastEvents;

    switch (state) {
      // The tutorial run was left some other way, such as playing again.
      case .clear || .drag || .score when !next.isTutorial:
        state = null;
      case .clear || .drag when events.any((event) => event is LinesCleared):
        ref.read(playbackProvider.notifier).holdOnProduct();
        state = .score;
      case .drag when events.any((event) => event is PiecePlaced):
        state = .clear;
      case .pick when next.run.phase is! PickingJokerPhase:
        state = null;
        unawaited(_markSeen());
      default:
    }
  }

  void _onPlayback(bool? wasPlaying, bool playing) {
    if (playing || state != .score) return;

    // Before the hand-over, which [_onGame] would otherwise read as the
    // tutorial run being left.
    state = .pick;
    ref.read(gameProvider.notifier).playPractice();
  }
}
