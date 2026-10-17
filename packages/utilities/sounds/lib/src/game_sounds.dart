import 'dart:math';

import 'package:sounds/src/package_name.dart';
import 'package:sounds/src/sound.dart';
import 'package:sounds/src/sound_engine.dart';
import 'package:timber/timber.dart';

/// Plays the game's sound effects, every one of them decoded into memory up
/// front so a play is a mix and not a load.
///
/// Sound is decoration: nothing here throws. A failed start leaves the game
/// silent for the session rather than stopping it.
final class GameSounds {
  final SoundEngine _engine;
  Future<void>? _initialization;
  final Random _random;
  bool _ready = false;

  /// The player's switch: while false, [play] stays silent. Whoever owns the
  /// setting sets it; this class only obeys.
  bool enabled = true;

  /// [engine] and [random] are optional so the composition layer can write
  /// `GameSounds()` and stay free of the plugin; they are here for tests.
  GameSounds({SoundEngine? engine, Random? random})
    : _engine = engine ?? SoLoudSoundEngine(),
      _random = random ?? Random();

  /// Safe to call more than once: later calls wait on the first.
  Future<void> init() => _initialization ??= _start();

  /// Does nothing until [init] has loaded every sound, after it failed, or
  /// while [enabled] is false. Each play is a voice of its own, so plays
  /// overlap and never cut one another off.
  ///
  /// The pitch moves with the playback speed: [speed] scales it directly,
  /// [semitones] moves it on the musical scale (12 is an octave up), and
  /// [variance] nudges it by a random factor within ±[variance], so a sound
  /// heard over and over doesn't sound like a loop.
  void play(
    Sound sound, {
    double semitones = 0,
    double speed = 1,
    double variance = 0,
  }) {
    if (!_ready || !enabled) return;

    final nudge = 1 + variance * (_random.nextDouble() * 2 - 1);

    try {
      _engine.play(
        sound.assetKey,
        speed * pow(2, semitones / 12) * nudge,
        sound.volume,
      );
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Playing ${sound.name} failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> dispose() async {
    final initialization = _initialization;

    if (initialization == null) return;

    // Waited out first, or a start still loading would mark it ready again.
    await initialization;
    _ready = false;

    try {
      await _engine.dispose();
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Stopping the sound engine failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _start() async {
    try {
      await _engine.init();

      for (final sound in Sound.values) {
        await _engine.load(sound.assetKey);
      }

      _ready = true;
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Starting the sound engine failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
