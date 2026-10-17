import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sounds/sounds.dart';

import 'fake_sound_engine.dart';

void main() {
  late FakeSoundEngine engine;
  late GameSounds sounds;

  setUp(() {
    engine = FakeSoundEngine();
    sounds = GameSounds(engine: engine);
  });

  test(
    'Given a start, When it completes, Then every sound is loaded',
    () async {
      await sounds.init();

      expect(engine.loaded, [for (final sound in Sound.values) sound.assetKey]);
    },
  );

  test('Given a second start, When called, Then nothing loads twice', () async {
    await Future.wait([sounds.init(), sounds.init()]);
    await sounds.init();

    expect(engine.loaded, hasLength(Sound.values.length));
  });

  test('Given sound switched off, When a sound plays, Then nothing is heard, '
      'and switching it back on is heard again', () async {
    await sounds.init();

    sounds
      ..enabled = false
      ..play(.place);

    expect(engine.played, isEmpty);

    sounds
      ..enabled = true
      ..play(.place);

    expect(engine.played, [(Sound.place.assetKey, 1.0)]);
  });

  test('Given no start, When a sound plays, Then nothing is heard', () {
    sounds.play(.tap);

    expect(engine.played, isEmpty);
  });

  test(
    'Given a started engine, When a sound plays, Then its asset plays at speed 1',
    () async {
      await sounds.init();

      sounds.play(.place);

      expect(engine.played, [(Sound.place.assetKey, 1.0)]);
    },
  );

  test(
    'Given a streak, When the clear plays faster, Then the speed is forwarded',
    () async {
      await sounds.init();

      sounds.play(.clear, speed: 1.25);

      expect(engine.played, [(Sound.clear.assetKey, 1.25)]);
    },
  );

  test(
    'Given a failed start, When it fails, Then it does not throw and stays silent',
    () async {
      engine.initThrows = Exception('no audio device');

      await expectLater(sounds.init(), completes);
      sounds.play(.roundWon);

      expect(engine.loaded, isEmpty);
      expect(engine.played, isEmpty);
    },
  );

  test(
    'Given the engine fails, When a sound plays, Then it does not throw',
    () async {
      await sounds.init();
      engine.playThrows = Exception('device lost');

      expect(() => sounds.play(.joker), returnsNormally);
    },
  );

  test(
    'Given a started engine, When disposed, Then the engine stops and plays are silent',
    () async {
      await sounds.init();

      await sounds.dispose();
      sounds.play(.tap);

      expect(engine.disposed, isTrue);
      expect(engine.played, isEmpty);
    },
  );

  test(
    'Given a start in flight, When disposed, Then it stays silent once loaded',
    () async {
      final starting = sounds.init();

      await sounds.dispose();
      await starting;
      sounds.play(.tap);

      expect(engine.played, isEmpty);
    },
  );

  test(
    'Given a started engine, When a sound plays an octave up, Then it plays '
    'twice as fast, and a fifth up about one and a half times as fast',
    () async {
      await sounds.init();

      sounds
        ..play(.joker, semitones: 12)
        ..play(.joker, semitones: 7);

      expect(engine.played[0].$2, closeTo(2, 1e-9));
      expect(engine.played[1].$2, closeTo(1.4983, 1e-4));
    },
  );

  test(
    'Given a variance of 5%, When a sound plays many times, Then its pitch '
    'moves within 5% either way, and not always by the same amount',
    () async {
      final sounds = GameSounds(engine: engine, random: Random(7));
      await sounds.init();

      for (var play = 0; play < 200; play++) {
        sounds.play(.place, variance: 0.05);
      }

      final speeds = engine.played.map((played) => played.$2).toSet();

      expect(speeds.every((speed) => speed >= 0.95 && speed <= 1.05), isTrue);
      expect(speeds.length, greaterThan(100));
    },
  );

  test('Given a started engine, When the same sound plays twice at once, Then '
      'both are heard, the second not cutting the first', () async {
    await sounds.init();

    sounds
      ..play(.tick)
      ..play(.tick);

    expect(engine.played, [
      (Sound.tick.assetKey, 1.0),
      (Sound.tick.assetKey, 1.0),
    ]);
  });

  test('Given a started engine, When a sound plays, Then it plays at its own '
      'level, so quiet and loud files sit together', () async {
    await sounds.init();

    sounds
      ..play(.bossStart)
      ..play(.bossWin);

    expect(engine.volumes, [Sound.bossStart.volume, Sound.bossWin.volume]);
  });

  test(
    'Given every sound, When its asset is read, Then it is bundled',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      for (final sound in Sound.values) {
        final data = await rootBundle.load(sound.assetKey);

        expect(data.lengthInBytes, greaterThan(0), reason: sound.name);
      }
    },
  );
}
