import 'package:flutter_soloud/flutter_soloud.dart';

/// What [GameSounds] needs from an audio engine, so it can be tested without
/// the native one.
abstract interface class SoundEngine {
  Future<void> dispose();

  Future<void> init();

  Future<void> load(String assetKey);

  void play(String assetKey, double speed, double volume);
}

final class SoLoudSoundEngine implements SoundEngine {
  final Map<String, AudioSource> _sources = {};

  // SoLoud's default is 16 audible voices; a count-up's ticks over a jingle
  // and a clear could reach it and silence the oldest.
  static const _voices = 32;

  /// Resolved on use, so constructing this is wiring and loads no native code.
  SoLoud get _soLoud => SoLoud.instance;

  @override
  Future<void> dispose() async {
    _sources.clear();
    _soLoud.deinit();
  }

  @override
  Future<void> init() async {
    await _soLoud.init();
    _soLoud.setMaxActiveVoiceCount(_voices);
  }

  @override
  Future<void> load(String assetKey) async {
    _sources[assetKey] = await _soLoud.loadAsset(assetKey, mode: .memory);
  }

  /// Started paused and then unpaused, so the first samples already play at
  /// [speed] instead of at 1 until the speed lands.
  @override
  void play(String assetKey, double speed, double volume) {
    final source = _sources[assetKey];

    if (source == null) return;

    final handle = _soLoud.play(source, paused: true, volume: volume);

    _soLoud
      ..setRelativePlaySpeed(handle, speed)
      ..setPause(handle, false);
  }
}
