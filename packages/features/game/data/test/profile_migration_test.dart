import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_data/src/dtos/profile_dto.br.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profiles.dart';

/// A device as version 1 left it: a key per best, the tutorial a setting.
const _version1Device = <String, Object>{
  'best.daily.20261016': 640,
  'best.practice': 900,
  'run.saved': '{}',
  'settings.sound': false,
  'settings.tutorialSeen': true,
};

const _version1Profile = <String, dynamic>{
  'bests': {
    'daily': {'20261016': 640},
    'practice': 900,
  },
  'tutorialSeen': true,
  'version': 1,
};

/// Rubble's boss beaten with two stars, Gravity open, as version 2 and 3
/// wrote a progression. Frozen: never regenerate it from today's DTOs.
const _writtenProgression = <String, dynamic>{
  'tutorialDone': true,
  'unlockedJokers': ['patience', 'twin', 'stonemason', 'quarry'],
  'worlds': {
    'rubble': {
      'bossBeaten': true,
      'stars': {'bossBeaten': true, 'noRevive': true, 'scoreThreshold': false},
      'unlocked': true,
    },
    'gravity': {
      'bossBeaten': false,
      'stars': {
        'bossBeaten': false,
        'noRevive': false,
        'scoreThreshold': false,
      },
      'unlocked': true,
    },
  },
};

const _version2Profile = <String, dynamic>{
  'bests': {
    'daily': {'20261016': 640},
    'practice': 900,
  },
  'progression': _writtenProgression,
  'version': 2,
};

const _version3Profile = <String, dynamic>{
  'bests': {
    'daily': {'20261016': 640},
    'practice': 900,
    'worlds': {'rubble': 5400},
  },
  'progression': _writtenProgression,
  'version': 3,
};

/// [_writtenProgression] as the domain reads it, with no joker stats yet and
/// the card of the boss it beat counted as seen.
const _progressed = Progression(
  bossCardsSeen: {.rubble},
  jokerStats: {},
  tutorialDone: true,
  unannouncedJokers: {},
  unlockedJokers: {.patience, .twin, .stonemason, .quarry},
  worlds: {
    .rubble: WorldProgress(
      bossBeaten: true,
      stars: WorldStars(
        bossBeaten: true,
        noRevive: true,
        scoreThreshold: false,
      ),
      unlocked: true,
    ),
    .gravity: WorldProgress(bossBeaten: false, stars: noStars, unlocked: true),
  },
);

Future<Map<String, dynamic>> _storedProfile() async {
  final raw = (await SharedPreferences.getInstance()).getString('profile');

  return jsonDecode(raw!) as Map<String, dynamic>;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a version 1 profile migrates to a valid version 7 one', () {
    // Given / When
    final migrated = ProfileDto.fromJson(
      migrateProfile(_version1Profile, startingProgression: starting),
    );

    // Then
    expect(migrated.version, 7);
    expect(migrated.bests.daily, {'20261016': 640});
    expect(migrated.bests.practice, 900);
    expect(migrated.bests.worlds, isEmpty);
    expect(
      migrated.progression.toDomain(),
      starting.copyWith(tutorialDone: true),
    );
  });

  test('a version 2 profile migrates to a valid version 7 one: its bests and '
      'progression kept, no world best and no joker stats yet', () {
    // Given / When
    final migrated = ProfileDto.fromJson(
      migrateProfile(_version2Profile, startingProgression: starting),
    );

    // Then
    expect(migrated.version, 7);
    expect(migrated.bests.daily, {'20261016': 640});
    expect(migrated.bests.practice, 900);
    expect(migrated.bests.worlds, isEmpty);
    expect(migrated.progression.toDomain(), _progressed);
  });

  test(
    'a version 3 profile migrates to a valid version 7 one: everything kept, '
    'its joker stats starting at nothing',
    () {
      // Given / When
      final migrated = ProfileDto.fromJson(
        migrateProfile(_version3Profile, startingProgression: starting),
      );

      // Then
      expect(migrated.version, 7);
      expect(migrated.bests.worlds, {'rubble': 5400});
      expect(migrated.progression.jokerStats, isEmpty);
      expect(migrated.progression.toDomain(), _progressed);
    },
  );

  test('Given a device with a version 3 profile, When it is first read, Then '
      'its progression is kept with no joker stats', () async {
    // Given
    SharedPreferences.setMockInitialValues({
      'profile': jsonEncode(_version3Profile),
    });

    // When
    final progression = await SharedPreferencesProgressionStore(
      startingProgression: starting,
    ).load();

    // Then
    expect(progression, _progressed);
  });

  group('a version 4 profile', () {
    /// Rubble with [rubble] stars and Gravity with [gravity], as version 4
    /// wrote them, with [unlocked] jokers.
    Map<String, dynamic> version4({
      required int gravity,
      required int rubble,
      List<String> unlocked = const ['patience', 'twin'],
    }) {
      Map<String, dynamic> world(int stars) => {
        'bossBeaten': stars > 0,
        'stars': {
          'bossBeaten': stars > 0,
          'noRevive': stars > 1,
          'scoreThreshold': stars > 2,
        },
        'unlocked': true,
      };

      return {
        'bests': {'daily': <String, int>{}, 'practice': null, 'worlds': {}},
        'progression': {
          'jokerStats': <String, dynamic>{},
          'tutorialDone': true,
          'unlockedJokers': unlocked,
          'worlds': {'rubble': world(rubble), 'gravity': world(gravity)},
        },
        'version': 4,
      };
    }

    Progression migrated(Map<String, dynamic> json) => ProfileDto.fromJson(
      migrateProfile(json, startingProgression: starting),
    ).progression.toDomain();

    test('holding 3 stars unlocks nothing', () {
      // Given / When
      final progression = migrated(version4(gravity: 0, rubble: 3));

      // Then
      expect(progression.unlockedJokers, {JokerId.patience, JokerId.twin});
      expect(progression.unannouncedJokers, isEmpty);
    });

    test(
      'holding 4 stars unlocks Full House and On the Brink, to announce',
      () {
        // Given / When
        final progression = migrated(version4(gravity: 1, rubble: 3));

        // Then
        expect(progression.unlockedJokers, {
          JokerId.patience,
          JokerId.twin,
          JokerId.fullhouse,
          JokerId.brink,
        });
        expect(progression.unannouncedJokers, {
          JokerId.fullhouse,
          JokerId.brink,
        });
      },
    );

    test('holding 6 stars unlocks all four, to announce', () {
      // Given / When
      final progression = migrated(version4(gravity: 3, rubble: 3));

      // Then
      expect(progression.unannouncedJokers, {
        JokerId.fullhouse,
        JokerId.brink,
        JokerId.finisher,
        JokerId.hattrick,
      });
      expect(
        progression.unlockedJokers,
        containsAll(progression.unannouncedJokers),
      );
    });

    test('announces none a run already unlocked', () {
      // Given / When: 4 stars, the pair already won at a run's end
      final progression = migrated(
        version4(
          gravity: 1,
          rubble: 3,
          unlocked: ['patience', 'twin', 'fullhouse', 'brink'],
        ),
      );

      // Then
      expect(progression.unannouncedJokers, isEmpty);
    });
  });

  test('a version 2 profile holding 6 stars gets all four on its way to '
      'version 5', () {
    // Given
    final version2 = {
      ..._version2Profile,
      'progression': {
        ..._writtenProgression,
        'worlds': {
          for (final world in ['rubble', 'gravity'])
            world: {
              'bossBeaten': true,
              'stars': {
                'bossBeaten': true,
                'noRevive': true,
                'scoreThreshold': true,
              },
              'unlocked': true,
            },
        },
      },
    };

    // When
    final progression = ProfileDto.fromJson(
      migrateProfile(version2, startingProgression: starting),
    ).progression.toDomain();

    // Then
    expect(progression.unannouncedJokers, hasLength(4));
  });

  test('a version 5 profile keeps the fourth world, renamed from Speed to '
      'Tide, and everything else', () {
    // Given: version 3's progression with the fourth world as builds before
    // Tide wrote it
    final version5 = {
      ..._version3Profile,
      'progression': {
        ..._version3Profile['progression'] as Map<String, dynamic>,
        'jokerStats': <String, dynamic>{},
        'unannouncedJokers': <String>[],
        'worlds': {
          ...(_version3Profile['progression'] as Map<String, dynamic>)['worlds']
              as Map<String, dynamic>,
          'speed': {
            'bossBeaten': false,
            'stars': {
              'bossBeaten': false,
              'noRevive': false,
              'scoreThreshold': false,
            },
            'unlocked': false,
          },
        },
      },
      'version': 5,
    };

    // When
    final migrated = ProfileDto.fromJson(
      migrateProfile(version5, startingProgression: starting),
    );

    // Then
    final worlds = migrated.progression.toDomain().worlds;
    expect(migrated.version, 7);
    expect(
      worlds.keys,
      unorderedEquals(const [WorldId.rubble, WorldId.gravity, WorldId.tide]),
    );
    expect(worlds[WorldId.tide]?.unlocked, isFalse);
    expect(worlds[WorldId.rubble], _progressed.worlds[WorldId.rubble]);
  });

  test('a version 6 profile counts the boss cards of the bosses it has beaten '
      'as seen', () {
    // Given: version 3's progression, Rubble's boss beaten, as version 6
    final version6 = {
      ..._version3Profile,
      'progression': {
        ..._version3Profile['progression'] as Map<String, dynamic>,
        'jokerStats': <String, dynamic>{},
        'unannouncedJokers': <String>[],
      },
      'version': 6,
    };

    // When
    final migrated = ProfileDto.fromJson(
      migrateProfile(version6, startingProgression: starting),
    );

    // Then
    expect(migrated.version, 7);
    expect(migrated.progression.toDomain().bossCardsSeen, {WorldId.rubble});
  });

  test('a profile naming no version cannot be migrated', () {
    expect(
      () => migrateProfile(const {}, startingProgression: starting),
      throwsFormatException,
    );
  });

  group('Given a device version 1 left', () {
    setUp(() => SharedPreferences.setMockInitialValues(_version1Device));

    test('When the progression is first read, Then it is the starting one with '
        'the tutorial behind', () async {
      // When
      final progression = await SharedPreferencesProgressionStore(
        startingProgression: starting,
      ).load();

      // Then
      expect(progression, starting.copyWith(tutorialDone: true));
    });

    test(
      'When the profile is first read, Then it is written as version 7 and the '
      'legacy bests are gone',
      () async {
        // When
        await SharedPreferencesProgressionStore(
          startingProgression: starting,
        ).load();

        // Then
        final stored = await SharedPreferences.getInstance();
        final profile = await _storedProfile();
        expect(profile['version'], 7);
        expect(profile['bests'], {
          'daily': {'20261016': 640},
          'practice': 900,
          'worlds': <String, int>{},
        });
        expect(stored.getKeys(), {
          'profile',
          'run.saved',
          'settings.sound',
          'settings.tutorialSeen',
        });
      },
    );

    test(
      'When the next launch reads the bests, Then they are the ones version 1 '
      'kept',
      () async {
        // Given
        final scores = SharedPreferencesBestScores(
          startingProgression: starting,
        );
        await scores.best(const GameMode.practice());

        // When
        await relaunch();
        final relaunched = SharedPreferencesBestScores(
          startingProgression: starting,
        );

        // Then
        expect(await relaunched.best(const GameMode.daily(day: 20261016)), 640);
        expect(await relaunched.best(const GameMode.practice()), 900);
      },
    );
  });

  test(
    'Given a device with nothing on it, When the profile is first read, Then '
    'it is a version 7 profile with no bests at the starting progression',
    () async {
      // When
      final progression = await SharedPreferencesProgressionStore(
        startingProgression: starting,
      ).load();

      // Then
      final profile = await _storedProfile();
      expect(progression, starting);
      expect(profile['version'], 7);
      expect(profile['bests'], {
        'daily': <String, int>{},
        'practice': null,
        'worlds': <String, int>{},
      });
    },
  );

  for (final (name, raw) in [
    ('is not JSON', 'not json'),
    (
      'comes from an unknown version',
      jsonEncode(
        ProfileDto.starting(starting).toJson()
          ..['version'] = profileVersion + 1,
      ),
    ),
    (
      'names a joker this build lacks',
      () {
        final json = ProfileDto.starting(starting).toJson();
        (json['progression'] as Map<String, dynamic>)['unlockedJokers'] = [
          'wildcard',
        ];

        return jsonEncode(json);
      }(),
    ),
  ]) {
    test('Given a profile that $name, When it is read, Then the player starts '
        'afresh and the next write replaces it', () async {
      // Given
      SharedPreferences.setMockInitialValues({'profile': raw});
      final scores = SharedPreferencesBestScores(startingProgression: starting);
      final store = SharedPreferencesProgressionStore(
        startingProgression: starting,
      );

      // When
      final progression = await store.load();
      final best = await scores.best(const GameMode.practice());
      await scores.save(const GameMode.practice(), 1200);

      // Then
      expect(progression, starting);
      expect(best, isNull);
      expect((await _storedProfile())['version'], 7);
      expect(await scores.best(const GameMode.practice()), 1200);
    });
  }
}
