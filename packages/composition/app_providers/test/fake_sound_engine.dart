import 'package:sounds/src/sound_engine.dart';

/// An audio engine that loads at once and keeps what it was asked to play.
final class FakeSoundEngine implements SoundEngine {
  final played = <({String assetKey, double speed})>[];

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {}

  @override
  Future<void> load(String assetKey) async {}

  @override
  void play(String assetKey, double speed, double volume) =>
      played.add((assetKey: assetKey, speed: speed));

  @override
  Future<void> restart() async {}
}
