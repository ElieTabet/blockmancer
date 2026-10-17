import 'package:game_data/src/dtos/profile_dto.br.dart';
import 'package:game_data/src/shared_preferences_profile.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

/// The profile's bests: one per daily run's day, one for practice.
final class SharedPreferencesBestScores implements BestScores {
  final SharedPreferencesProfile _profile;

  SharedPreferencesBestScores({required Progression startingProgression})
    : _profile = SharedPreferencesProfile(
        startingProgression: startingProgression,
      );

  @override
  Future<int?> best(GameMode mode) async {
    final bests = (await _profile.read()).bests;

    return switch (mode) {
      DailyMode(:final day) => bests.daily['$day'],
      PracticeMode() => bests.practice,
    };
  }

  @override
  Future<void> clearAll() => _profile.update(
    (profile) => ProfileDto(
      bests: const BestsDto(daily: {}),
      progression: profile.progression,
      version: profileVersion,
    ),
  );

  @override
  Future<void> save(GameMode mode, int total) => _profile.update((profile) {
    final bests = profile.bests;

    return ProfileDto(
      bests: switch (mode) {
        DailyMode(:final day) => BestsDto(
          daily: {...bests.daily, '$day': total},
          practice: bests.practice,
        ),
        PracticeMode() => BestsDto(daily: bests.daily, practice: total),
      },
      progression: profile.progression,
      version: profileVersion,
    );
  });
}
