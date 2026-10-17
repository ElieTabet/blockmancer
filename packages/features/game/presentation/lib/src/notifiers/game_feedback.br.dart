import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:game_presentation/src/entities/game_sound.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_ui_state.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_state.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'game_feedback.br.g.dart';

/// The jokers that fire in one move climb a major chord, in firing order.
const _majorChord = <double>[0, 4, 7, 12, 16, 19, 24];

/// The major pentatonic, which has no note that clashes with another: the
/// clear climbs it a step per level of the streak, the count-up's ticks a step
/// per tick.
const _pentatonic = <double>[0, 2, 4, 7, 9, 12, 14, 16, 19, 21, 24];

/// How far a placement strays from its pitch, so a run of them doesn't sound
/// like a loop.
const _placeVariance = 0.05;

/// The closest two ticks come: any closer and they blur into a burst.
const _tickSpacing = Duration(milliseconds: 40);

const _ticksPerMove = 12;

enum _Outcome { bossWon, lost, won }

/// Plays each move's sounds and haptics as its beats play back, each obeying
/// its own switch in Settings. Reduce motion stills the board, not the sound.
///
/// A skip plays nothing of what it skipped but the move's outcome, so it never
/// sets off a burst of every sound left.
@Riverpod(dependencies: [GameNotifier, PlaybackNotifier, reduceMotion])
class GameFeedback extends _$GameFeedback {
  /// Whether the boss round's sting waits for the move to play out, behind
  /// the round won on the same move.
  var _bossStartOwed = false;
  var _hapticsOn = true;

  /// The jokers fired so far in the move.
  var _jokers = 0;

  /// The won or lost round the move ends on, until it has been played.
  _Outcome? _outcome;
  var _reduceMotion = false;
  var _soundOn = true;
  var _streak = 0;
  Timer? _ticking;

  /// The count-up's ticks played so far in the move.
  var _ticks = 0;

  @override
  void build() {
    ref
      ..onDispose(_stopTicking)
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
      ..listen(playbackProvider, _onPlayback)
      // The game itself, not its playback: a pick that starts the boss round
      // may have no beats at all.
      ..listen(gameProvider, _onGame);
  }

  void _clear() {
    _play(.clear, semitones: _noteOf(_pentatonic, _streak - 1));
    _vibrate(HapticFeedback.mediumImpact);
  }

  /// Ticks [counted] up over [duration], evenly, a step higher each time:
  /// never more ticks than the number counted, than fit [_tickSpacing] apart,
  /// or than are left of the move's [_ticksPerMove].
  void _countUp(int counted, Duration duration) {
    _stopTicking();

    final fitting = duration.inMicroseconds ~/ _tickSpacing.inMicroseconds;
    final count = min(min(counted, fitting), _ticksPerMove - _ticks);

    if (count <= 0) return;

    _tick();

    var left = count - 1;

    if (left == 0) return;

    _ticking = Timer.periodic(duration ~/ count, (timer) {
      _tick();

      if (--left == 0) timer.cancel();
    });
  }

  void _onBeat(Beat beat) {
    switch (beat) {
      case PlacingBeat():
        _place();
      case ClearingBeat():
        _clear();
      case ComboBeat():
        _vibrate(HapticFeedback.heavyImpact);
      case CountingChipsBeat(:final chips, :final duration):
        _countUp(chips, duration);
      case CountingMultBeat(:final duration, :final mult):
        _countUp(mult, duration);
      case JokerPulseBeat():
        _play(.joker, semitones: _noteOf(_majorChord, _jokers++));
      case LandingBeat():
        _play(.kaching);
        // A move that cleared nothing has no landing, and cheers as it ends.
        if (_outcome != .lost) _playOutcome();
      case _:
    }
  }

  void _onGame(GameUiState? previous, GameUiState next) {
    if (previous == null || previous.moveCount == next.moveCount) return;

    final events = next.lastEvents;
    final rounds = next.run.config.rounds;
    final bossStarts = events.any(
      (event) => event is RoundStarted && rounds[event.roundIndex].isBoss,
    );

    // With no joker left to offer, the move that wins a round starts the
    // boss's too: its sting follows the round's jingle, not the piece.
    _bossStartOwed = bossStarts && events.any((event) => event is RoundWon);

    if (bossStarts && !_bossStartOwed) _play(.bossStart);
  }

  void _onPlayback(PlaybackState? previous, PlaybackState next) {
    final beat = next.beat;
    final wasPlaying = previous?.isPlaying ?? false;

    // Played out or skipped: the round's sheet comes up now.
    if (beat == null) {
      _stopTicking();

      if (wasPlaying) {
        _playOutcome();
        _playOwedBossStart();
      }

      return;
    }

    if (!wasPlaying) _startMove();

    if (previous?.step != next.step) _onBeat(beat);
  }

  void _place() {
    _play(.place, variance: _placeVariance);
    _vibrate(HapticFeedback.lightImpact);
  }

  void _play(GameSound sound, {double semitones = 0, double variance = 0}) {
    if (_soundOn) {
      ref.read(playSoundProvider)(
        sound,
        semitones: semitones,
        variance: variance,
      );
    }
  }

  void _playOutcome() {
    final outcome = _outcome;
    _outcome = null;

    switch (outcome) {
      case .bossWon:
        _play(.cheer);
        _play(.bossWin);
        _vibrate(HapticFeedback.heavyImpact);
      case .lost:
        _play(.roundLost);
      case .won:
        _play(.roundWon);
        _vibrate(HapticFeedback.heavyImpact);
      case null:
    }
  }

  void _playOwedBossStart() {
    if (!_bossStartOwed) return;

    _bossStartOwed = false;
    _play(.bossStart);
  }

  /// Reads the move that has started playing: the game has already taken it.
  void _startMove() {
    final game = ref.read(gameProvider);
    final events = game.lastEvents;
    final rounds = game.run.config.rounds;

    _stopTicking();
    _jokers = 0;
    _streak = game.run.streak;
    _ticks = 0;
    _outcome = switch (events.whereType<RoundWon>().firstOrNull) {
      RoundWon(:final roundIndex) when rounds[roundIndex].isBoss => .bossWon,
      RoundWon() => .won,
      null when events.any((event) => event is RoundLost) => .lost,
      null => null,
    };

    // Reduce motion leaves out the placing and clearing beats; not their sound.
    if (!_reduceMotion) return;

    if (events.any((event) => event is PiecePlaced)) _place();
    if (events.any((event) => event is LinesCleared)) _clear();
  }

  void _stopTicking() {
    _ticking?.cancel();
    _ticking = null;
  }

  void _tick() => _play(.tick, semitones: _noteOf(_pentatonic, _ticks++));

  void _vibrate(Future<void> Function() impact) {
    if (_hapticsOn) unawaited(impact());
  }
}

/// The [index]th note of [scale], held on its top note past the end.
double _noteOf(List<double> scale, int index) =>
    scale[index.clamp(0, scale.length - 1)];
