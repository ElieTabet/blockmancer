import 'dart:async';

import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/beats.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_ui_state.br.dart';
import 'package:game_presentation/src/notifiers/playback_state.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_notifier.br.g.dart';

/// How long a move plays before a tap may skip the rest.
const skipAfter = Duration(milliseconds: 300);

/// Plays each move back beat by beat (see [beatsFor]). The screen takes no
/// input while it plays, so a finger already reaching for the next piece
/// doesn't play it before the last one has been seen.
@Riverpod(dependencies: [GameNotifier, reduceMotion])
class PlaybackNotifier extends _$PlaybackNotifier {
  Timer? _beat;
  var _beats = const <Beat>[];
  var _holdsOnProduct = false;
  var _reduceMotion = false;

  /// The beat a held playback goes on from.
  int? _resumeAt;
  Timer? _skippable;

  @override
  PlaybackState build() {
    // Listened to rather than watched: a rebuild would cut a move short.
    ref
      ..onDispose(_stop)
      ..onDispose(ref.read(gameActivityProvider).stopPlaying)
      ..listen(gameProvider, _onGame)
      ..listen(
        reduceMotionProvider,
        (_, reduceMotion) => _reduceMotion = reduceMotion,
        fireImmediately: true,
      );

    return const PlaybackState();
  }

  /// Waits on the next `chips × mult` until a [skip], so the score can be
  /// explained before it lands.
  void holdOnProduct() => _holdsOnProduct = true;

  /// Lets a held playback go on; otherwise jumps to the end of the move, once
  /// it has played for [skipAfter].
  void skip() {
    final resumeAt = _resumeAt;

    if (resumeAt != null) {
      _resumeAt = null;
      state = state.copyWith(held: false);

      return _play(resumeAt);
    }

    if (state.canSkip) _finish();
  }

  void _finish() {
    _stop();
    _holdsOnProduct = false;
    state = PlaybackState(step: state.step);
    ref.read(gameActivityProvider).stopPlaying();
  }

  void _onGame(GameUiState? previous, GameUiState next) {
    if (previous == null || previous.moveCount == next.moveCount) return;

    _stop();
    _beats = beatsFor(
      after: next.run,
      before: previous.run,
      events: next.lastEvents,
      reduceMotion: _reduceMotion,
      rules: ref.read(gameRulesProvider),
    );

    if (_beats.isEmpty) return _finish();

    ref.read(gameActivityProvider).startPlaying();
    final lands = _beats.any((beat) => beat is LandingBeat);
    final risesAt = _beats.indexWhere((beat) => beat is RisingBeat);
    final tideClear = risesAt < 0
        ? null
        : _beats.skip(risesAt).whereType<ClearingBeat>().firstOrNull;

    state = PlaybackState(
      heldRun: lands ? previous.run : null,
      heldScore: lands ? previous.run.score : null,
      riseAhead: risesAt >= 0,
      step: state.step,
      tideAhead: tideClear?.cells ?? const [],
    );
    _skippable = Timer(skipAfter, () => state = state.copyWith(canSkip: true));
    _play(0);
  }

  void _play(int index) {
    if (index == _beats.length) return _finish();

    final beat = _beats[index];
    final holds = _holdsOnProduct && beat is ProductBeat;

    state = state.copyWith(
      beat: beat,
      held: holds,
      heldRun: beat is LandingBeat ? null : state.heldRun,
      heldScore: beat is LandingBeat ? beat.score : state.heldScore,
      riseAhead: beat is! RisingBeat && state.riseAhead,
      step: state.step + 1,
      // Only the tide's own clear comes once the board has risen.
      tideAhead: beat is ClearingBeat && !state.riseAhead
          ? const []
          : state.tideAhead,
    );

    if (holds) {
      _holdsOnProduct = false;
      _resumeAt = index + 1;

      return;
    }

    _beat = Timer(beat.duration, () => _play(index + 1));
  }

  void _stop() {
    _beat?.cancel();
    _resumeAt = null;
    _skippable?.cancel();
  }
}
