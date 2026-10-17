import 'dart:convert';

import 'package:game_data/src/dtos/profile_dto.br.dart';
import 'package:game_data/src/package_name.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timber/timber.dart';

/// The player's profile — their bests and their progression — as one JSON
/// string under one key, shared by the stores that each keep a part of it.
final class SharedPreferencesProfile {
  const SharedPreferencesProfile({required this.startingProgression});

  /// What a device that has never progressed starts from.
  final Progression startingProgression;

  static const _key = 'profile';

  /// Version 1 was no profile, only these keys; the tutorial flag is the
  /// settings', so it is read but left where it is.
  static const _legacyBestPrefix = 'best.';
  static const _legacyDailyPrefix = 'best.daily.';
  static const _legacyPractice = 'best.practice';
  static const _legacyTutorialSeen = 'settings.tutorialSeen';

  Future<ProfileDto> read() async {
    final preferences = await SharedPreferences.getInstance();
    final (profile, migrated) = _load(preferences);

    await migrated;

    return profile;
  }

  /// Nothing is awaited between reading the profile and writing it back: the
  /// bests and the progression share it, so a write that waited could undo
  /// the other's.
  Future<void> update(ProfileDto Function(ProfileDto profile) change) async {
    final preferences = await SharedPreferences.getInstance();
    final (profile, migrated) = _load(preferences);
    final written = preferences.setString(
      _key,
      jsonEncode(change(profile).toJson()),
    );

    await Future.wait([migrated, written]);
  }

  /// The profile brought up to date, and the writes that bring the device up
  /// to date with it. A profile that can't be read (corrupt, or from a version
  /// this build doesn't know) is no progress at all, and the next write
  /// replaces it.
  (ProfileDto, Future<void>) _load(SharedPreferences preferences) {
    try {
      final raw = preferences.getString(_key);

      if (raw == null) return _migrateLegacy(preferences);

      final json = migrateProfile(
        jsonDecode(raw) as Map<String, dynamic>,
        startingProgression: startingProgression,
      );

      final profile = ProfileDto.fromJson(json);

      // Read in full here, so a joker or a world this build lacks makes the
      // profile unreadable rather than failing whoever reads it next.
      profile.progression.toDomain();

      return (profile, Future.value());
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The profile could not be read; starting afresh',
        exception: error,
        stackTrace: stackTrace,
      );

      return (ProfileDto.starting(startingProgression), Future.value());
    }
  }

  /// Written at once, so the legacy bests are read only this once.
  (ProfileDto, Future<void>) _migrateLegacy(SharedPreferences preferences) {
    final keys = preferences.getKeys();
    final version1 = {
      'bests': {
        'daily': {
          for (final key in keys)
            if (key.startsWith(_legacyDailyPrefix))
              key.substring(_legacyDailyPrefix.length): preferences.getInt(key),
        },
        'practice': preferences.getInt(_legacyPractice),
      },
      'tutorialSeen': preferences.getBool(_legacyTutorialSeen) ?? false,
      'version': 1,
    };
    final profile = ProfileDto.fromJson(
      migrateProfile(version1, startingProgression: startingProgression),
    );
    final written = Future.wait([
      preferences.setString(_key, jsonEncode(profile.toJson())),
      for (final key in keys)
        if (key.startsWith(_legacyBestPrefix)) preferences.remove(key),
    ]);

    return (profile, written);
  }
}
