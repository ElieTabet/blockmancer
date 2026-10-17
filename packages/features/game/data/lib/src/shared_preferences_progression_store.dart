import 'package:game_data/src/dtos/profile_dto.br.dart';
import 'package:game_data/src/shared_preferences_profile.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

/// The profile's progression.
final class SharedPreferencesProgressionStore implements ProgressionStore {
  final SharedPreferencesProfile _profile;

  SharedPreferencesProgressionStore({required Progression startingProgression})
    : _profile = SharedPreferencesProfile(
        startingProgression: startingProgression,
      );

  @override
  Future<Progression> load() async =>
      (await _profile.read()).progression.toDomain();

  @override
  Future<void> save(Progression progression) => _profile.update(
    (profile) => ProfileDto(
      bests: profile.bests,
      progression: .fromDomain(progression),
      version: profileVersion,
    ),
  );
}
