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

/// [_writtenProgression] as the domain reads it, with no joker stats yet.
const _progressed = Progression(
  jokerStats: {},
  tutorialDone: true,
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

  test('a version 1 profile migrates to a valid version 4 one', () {
    // Given / When
    final migrated = ProfileDto.fromJson(
      migrateProfile(_version1Profile, startingProgression: starting),
    );

    // Then
    expect(migrated.version, 4);
    expect(migrated.bests.daily, {'20261016': 640});
    expect(migrated.bests.practice, 900);
    expect(migrated.bests.worlds, isEmpty);
    expect(
      migrated.progression.toDomain(),
      starting.copyWith(tutorialDone: true),
    );
  });

  test('a version 2 profile migrates to a valid version 4 one: its bests and '
      'progression kept, no world best and no joker stats yet', () {
    // Given / When
    final migrated = ProfileDto.fromJson(
      migrateProfile(_version2Profile, startingProgression: starting),
    );

    // Then
    expect(migrated.version, 4);
    expect(migrated.bests.daily, {'20261016': 640});
    expect(migrated.bests.practice, 900);
    expect(migrated.bests.worlds, isEmpty);
    expect(migrated.progression.toDomain(), _progressed);
  });

  test(
    'a version 3 profile migrates to a valid version 4 one: everything kept, '
    'its joker stats starting at nothing',
    () {
      // Given / When
      final migrated = ProfileDto.fromJson(
        migrateProfile(_version3Profile, startingProgression: starting),
      );

      // Then
      expect(migrated.version, 4);
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
      'When the profile is first read, Then it is written as version 4 and the '
      'legacy bests are gone',
      () async {
        // When
        await SharedPreferencesProgressionStore(
          startingProgression: starting,
        ).load();

        // Then
        final stored = await SharedPreferences.getInstance();
        final profile = await _storedProfile();
        expect(profile['version'], 4);
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
    'it is a version 4 profile with no bests at the starting progression',
    () async {
      // When
      final progression = await SharedPreferencesProgressionStore(
        startingProgression: starting,
      ).load();

      // Then
      final profile = await _storedProfile();
      expect(progression, starting);
      expect(profile['version'], 4);
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
      expect((await _storedProfile())['version'], 4);
      expect(await scores.best(const GameMode.practice()), 1200);
    });
  }
}
