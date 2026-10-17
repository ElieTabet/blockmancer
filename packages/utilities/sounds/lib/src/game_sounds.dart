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
  bool _ready = false;

  /// [engine] is optional so the composition layer can write `GameSounds()`
  /// and stay free of the plugin; it is here for tests.
  GameSounds({SoundEngine? engine}) : _engine = engine ?? SoLoudSoundEngine();

  /// Safe to call more than once: later calls wait on the first.
  Future<void> init() => _initialization ??= _start();

  /// Does nothing until [init] has loaded every sound, or after it failed.
  /// [speed] is relative, so it raises the pitch with it.
  void play(Sound sound, {double speed = 1}) {
    if (!_ready) return;

    try {
      _engine.play(sound.assetKey, speed);
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
