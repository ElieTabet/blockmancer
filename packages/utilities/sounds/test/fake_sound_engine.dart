import 'package:sounds/src/sound_engine.dart';

final class FakeSoundEngine implements SoundEngine {
  bool disposed = false;
  Object? initThrows;
  final loaded = <String>[];
  final played = <(String, double)>[];
  final volumes = <double>[];
  Object? playThrows;

  @override
  Future<void> dispose() async => disposed = true;

  @override
  Future<void> init() async {
    final initThrows = this.initThrows;

    if (initThrows != null) throw initThrows;
  }

  @override
  Future<void> load(String assetKey) async => loaded.add(assetKey);

  @override
  void play(String assetKey, double speed, double volume) {
    final playThrows = this.playThrows;

    if (playThrows != null) throw playThrows;

    played.add((assetKey, speed));
    volumes.add(volume);
  }
}
