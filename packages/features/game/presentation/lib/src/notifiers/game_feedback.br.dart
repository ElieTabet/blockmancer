import 'dart:async';

import 'package:flutter/services.dart';
import 'package:game_presentation/src/entities/game_sound.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_state.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'game_feedback.br.g.dart';

/// How much faster, and so higher, each step of a streak plays the clear.
const _clearPitchStep = 0.08;

/// The highest the clear climbs, before it stops sounding like itself.
const _highestClear = 1.6;

enum _Outcome { lost, won }

/// Plays each move's sounds and haptics as its beats play back, each obeying
/// its own switch in Settings. Reduce motion stills the board, not the sound.
///
/// A skip plays nothing of what it skipped but the move's outcome, so it never
/// sets off a burst of every sound left.
@Riverpod(dependencies: [GameNotifier, PlaybackNotifier, reduceMotion])
class GameFeedback extends _$GameFeedback {
  var _hapticsOn = true;

  /// The won or lost round the move ends on, until it has been played.
  _Outcome? _outcome;
  var _reduceMotion = false;
  var _soundOn = true;
  var _streak = 0;

  @override
  void build() {
    ref
      ..listen(
        hapticsOnSettingProvider,
        (_, on) => _hapticsOn = on,
        fireImmediately: true,
      )
      ..listen(
        reduceMotionProvider,
        (_, reduceMotion) => _reduceMotion = reduceMotion,
        fireImmediately: true,
      )
      ..listen(
        soundOnSettingProvider,
        (_, on) => _soundOn = on,
        fireImmediately: true,
      )
      ..listen(playbackProvider, _onPlayback);
  }

  void _clear() {
    final speed = (1 + _clearPitchStep * (_streak - 1)).clamp(
      1.0,
      _highestClear,
    );

    _play(.clear, speed: speed);
    _vibrate(HapticFeedback.mediumImpact);
  }

  void _onBeat(Beat beat) {
    switch (beat) {
      case PlacingBeat():
        _place();
      case ClearingBeat():
        _clear();
      case ComboBeat():
        _vibrate(HapticFeedback.heavyImpact);
      case JokerPulseBeat():
        _play(.joker);
      // A move that cleared nothing has no landing, and cheers as it ends.
      case LandingBeat() when _outcome == .won:
        _playOutcome();
      case _:
    }
  }

  void _onPlayback(PlaybackState? previous, PlaybackState next) {
    final beat = next.beat;
    final wasPlaying = previous?.isPlaying ?? false;

    // Played out or skipped: the round's sheet comes up now.
    if (beat == null) {
      if (wasPlaying) _playOutcome();

      return;
    }

    if (!wasPlaying) _startMove();

    if (previous?.step != next.step) _onBeat(beat);
  }

  void _place() {
    _play(.place);
    _vibrate(HapticFeedback.lightImpact);
  }

  void _play(GameSound sound, {double speed = 1}) {
    if (_soundOn) ref.read(playSoundProvider)(sound, speed: speed);
  }

  void _playOutcome() {
    final outcome = _outcome;
    _outcome = null;

    switch (outcome) {
      case .lost:
        _play(.roundLost);
      case .won:
        _play(.roundWon);
        _vibrate(HapticFeedback.heavyImpact);
      case null:
    }
  }

  /// Reads the move that has started playing: the game has already taken it.
  void _startMove() {
    final game = ref.read(gameProvider);
    final events = game.lastEvents;

    _streak = game.run.streak;
    _outcome = events.any((event) => event is RoundWon)
        ? .won
        : events.any((event) => event is RoundLost)
        ? .lost
        : null;

    // Reduce motion leaves out the placing and clearing beats; not their sound.
    if (!_reduceMotion) return;

    if (events.any((event) => event is PiecePlaced)) _place();
    if (events.any((event) => event is LinesCleared)) _clear();
  }

  void _vibrate(Future<void> Function() impact) {
    if (_hapticsOn) unawaited(impact());
  }
}
