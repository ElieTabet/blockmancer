import 'package:json_annotation/json_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'profile_dto.br.g.dart';

/// The profile's schema version. Bump it with each change to these DTOs, and
/// teach `migrateProfile` to bring the previous version up to it.
const profileVersion = 3;

/// Brings a profile written by an earlier version up to [profileVersion], one
/// version at a time; a version this build doesn't know is unreadable.
Map<String, dynamic> migrateProfile(
  Map<String, dynamic> json, {
  required Progression startingProgression,
}) => switch (json['version']) {
  1 => migrateProfile(
    _fromVersion1(json, startingProgression: startingProgression),
    startingProgression: startingProgression,
  ),
  2 => migrateProfile(
    _fromVersion2(json),
    startingProgression: startingProgression,
  ),
  profileVersion => json,
  final version => throw FormatException('Profile version $version'),
};

/// Version 1 kept the bests alone, and the tutorial was a setting: its players
/// keep their bests and start the map from the beginning, the tutorial behind
/// them if they had seen it.
Map<String, dynamic> _fromVersion1(
  Map<String, dynamic> json, {
  required Progression startingProgression,
}) => {
  'bests': json['bests'],
  'progression': ProgressionDto.fromDomain(
    startingProgression.copyWith(tutorialDone: json['tutorialSeen'] == true),
  ).toJson(),
  'version': 2,
};

/// Version 2 kept no world bests: there were no world runs to keep them for.
Map<String, dynamic> _fromVersion2(Map<String, dynamic> json) => {
  ...json,
  'bests': <String, dynamic>{
    ...json['bests'] as Map<String, dynamic>,
    'worlds': <String, dynamic>{},
  },
  'version': 3,
};

@JsonSerializable(explicitToJson: true)
final class ProfileDto {
  const ProfileDto({
    required this.bests,
    required this.progression,
    required this.version,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  /// A profile with no bests, at [startingProgression].
  factory ProfileDto.starting(Progression startingProgression) => ProfileDto(
    bests: const BestsDto(daily: {}, worlds: {}),
    progression: .fromDomain(startingProgression),
    version: profileVersion,
  );

  final BestsDto bests;
  final ProgressionDto progression;
  final int version;

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}

/// Each mode's best run total.
@JsonSerializable()
final class BestsDto {
  const BestsDto({required this.daily, required this.worlds, this.practice});

  factory BestsDto.fromJson(Map<String, dynamic> json) =>
      _$BestsDtoFromJson(json);

  /// Keyed by the daily run's UTC day, `yyyymmdd`. Past days are never pruned
  /// — a year of them is a few kilobytes.
  final Map<String, int> daily;
  final int? practice;

  /// Keyed by the world's name.
  final Map<String, int> worlds;

  Map<String, dynamic> toJson() => _$BestsDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
final class ProgressionDto {
  const ProgressionDto({
    required this.tutorialDone,
    required this.unlockedJokers,
    required this.worlds,
  });

  factory ProgressionDto.fromDomain(Progression progression) => ProgressionDto(
    tutorialDone: progression.tutorialDone,
    unlockedJokers: [
      for (final joker in progression.unlockedJokers) joker.name,
    ],
    worlds: {
      for (final MapEntry(key: world, value: progress)
          in progression.worlds.entries)
        world.name: .fromDomain(progress),
    },
  );

  factory ProgressionDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressionDtoFromJson(json);

  final bool tutorialDone;
  final List<String> unlockedJokers;
  final Map<String, WorldProgressDto> worlds;

  Map<String, dynamic> toJson() => _$ProgressionDtoToJson(this);

  Progression toDomain() => Progression(
    tutorialDone: tutorialDone,
    unlockedJokers: {
      for (final joker in unlockedJokers) JokerId.values.byName(joker),
    },
    worlds: {
      for (final MapEntry(key: world, value: progress) in worlds.entries)
        WorldId.values.byName(world): progress.toDomain(),
    },
  );
}

@JsonSerializable(explicitToJson: true)
final class WorldProgressDto {
  const WorldProgressDto({
    required this.bossBeaten,
    required this.stars,
    required this.unlocked,
  });

  factory WorldProgressDto.fromDomain(WorldProgress progress) =>
      WorldProgressDto(
        bossBeaten: progress.bossBeaten,
        stars: .fromDomain(progress.stars),
        unlocked: progress.unlocked,
      );

  factory WorldProgressDto.fromJson(Map<String, dynamic> json) =>
      _$WorldProgressDtoFromJson(json);

  final bool bossBeaten;
  final WorldStarsDto stars;
  final bool unlocked;

  Map<String, dynamic> toJson() => _$WorldProgressDtoToJson(this);

  WorldProgress toDomain() => WorldProgress(
    bossBeaten: bossBeaten,
    stars: stars.toDomain(),
    unlocked: unlocked,
  );
}

@JsonSerializable()
final class WorldStarsDto {
  const WorldStarsDto({
    required this.bossBeaten,
    required this.noRevive,
    required this.scoreThreshold,
  });

  factory WorldStarsDto.fromDomain(WorldStars stars) => WorldStarsDto(
    bossBeaten: stars.bossBeaten,
    noRevive: stars.noRevive,
    scoreThreshold: stars.scoreThreshold,
  );

  factory WorldStarsDto.fromJson(Map<String, dynamic> json) =>
      _$WorldStarsDtoFromJson(json);

  final bool bossBeaten;
  final bool noRevive;
  final bool scoreThreshold;

  Map<String, dynamic> toJson() => _$WorldStarsDtoToJson(this);

  WorldStars toDomain() => WorldStars(
    bossBeaten: bossBeaten,
    noRevive: noRevive,
    scoreThreshold: scoreThreshold,
  );
}
