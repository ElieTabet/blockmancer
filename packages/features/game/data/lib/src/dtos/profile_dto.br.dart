import 'package:json_annotation/json_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'profile_dto.br.g.dart';

/// The profile's schema version. Bump it with each change to these DTOs, and
/// teach `migrateProfile` to bring the previous version up to it.
const profileVersion = 7;

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
  3 => migrateProfile(
    _fromVersion3(json),
    startingProgression: startingProgression,
  ),
  4 => migrateProfile(
    _fromVersion4(json),
    startingProgression: startingProgression,
  ),
  5 => migrateProfile(
    _fromVersion5(json),
    startingProgression: startingProgression,
  ),
  6 => migrateProfile(
    _fromVersion6(json),
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

/// Version 3 kept no joker stats: its players start counting from here.
Map<String, dynamic> _fromVersion3(Map<String, dynamic> json) => {
  ...json,
  'progression': <String, dynamic>{
    ...json['progression'] as Map<String, dynamic>,
    'jokerStats': <String, dynamic>{},
  },
  'version': 4,
};

/// Version 4 had no star unlocks: a player already holding their stars gets
/// the jokers now, announced on the next visit to the map. The thresholds are
/// the ones version 5 first shipped, as literals.
Map<String, dynamic> _fromVersion4(Map<String, dynamic> json) {
  final progression = json['progression'] as Map<String, dynamic>;
  final worlds = progression['worlds'] as Map<String, dynamic>;
  final starsHeld = worlds.values.fold(0, (held, world) {
    final stars = (world as Map<String, dynamic>)['stars'] as Map;

    return held + stars.values.where((earned) => earned == true).length;
  });
  final unlocked = [...progression['unlockedJokers'] as List];
  final granted = [
    for (final (stars, jokers) in _version5StarUnlocks)
      if (starsHeld >= stars)
        for (final joker in jokers)
          if (!unlocked.contains(joker)) joker,
  ];

  return {
    ...json,
    'progression': <String, dynamic>{
      ...progression,
      'unannouncedJokers': granted,
      'unlockedJokers': [...unlocked, ...granted],
    },
    'version': 5,
  };
}

/// Version 5 named the fourth world Speed, a world that was dropped for Tide
/// before it had rules: its entry, locked like every world the map didn't
/// open yet, becomes Tide's. Read as it was, the unknown name would throw the
/// whole profile away.
Map<String, dynamic> _fromVersion5(Map<String, dynamic> json) {
  final progression = json['progression'] as Map<String, dynamic>;
  final worlds = progression['worlds'] as Map<String, dynamic>;

  return {
    ...json,
    'progression': <String, dynamic>{
      ...progression,
      'worlds': <String, dynamic>{
        for (final MapEntry(:key, :value) in worlds.entries)
          key == 'speed' ? 'tide' : key: value,
      },
    },
    'version': 6,
  };
}

/// Version 6 kept no boss cards: a world whose boss the player has beaten was
/// reached, so its card counts as seen; one only reached, the profile can't
/// tell, and shows its card the next time.
Map<String, dynamic> _fromVersion6(Map<String, dynamic> json) {
  final progression = json['progression'] as Map<String, dynamic>;
  final worlds = progression['worlds'] as Map<String, dynamic>;

  return {
    ...json,
    'progression': <String, dynamic>{
      ...progression,
      'bossCardsSeen': [
        for (final MapEntry(key: world, :value) in worlds.entries)
          if ((value as Map<String, dynamic>)['bossBeaten'] == true) world,
      ],
    },
    'version': 7,
  };
}

const _version5StarUnlocks = [
  (4, ['fullhouse', 'brink']),
  (6, ['finisher', 'hattrick']),
];

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
    required this.bossCardsSeen,
    required this.jokerStats,
    required this.tutorialDone,
    required this.unannouncedJokers,
    required this.unlockedJokers,
    required this.worlds,
  });

  factory ProgressionDto.fromDomain(Progression progression) => ProgressionDto(
    bossCardsSeen: [for (final world in progression.bossCardsSeen) world.name],
    jokerStats: {
      for (final MapEntry(key: joker, value: stats)
          in progression.jokerStats.entries)
        joker.name: .fromDomain(stats),
    },
    tutorialDone: progression.tutorialDone,
    unannouncedJokers: [
      for (final joker in progression.unannouncedJokers) joker.name,
    ],
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

  /// By the world's name.
  final List<String> bossCardsSeen;

  /// Keyed by the joker's name.
  final Map<String, JokerStatsDto> jokerStats;
  final bool tutorialDone;
  final List<String> unannouncedJokers;
  final List<String> unlockedJokers;
  final Map<String, WorldProgressDto> worlds;

  Map<String, dynamic> toJson() => _$ProgressionDtoToJson(this);

  Progression toDomain() => Progression(
    bossCardsSeen: {
      for (final world in bossCardsSeen) WorldId.values.byName(world),
    },
    jokerStats: {
      for (final MapEntry(key: joker, value: stats) in jokerStats.entries)
        JokerId.values.byName(joker): stats.toDomain(),
    },
    tutorialDone: tutorialDone,
    unannouncedJokers: {
      for (final joker in unannouncedJokers) JokerId.values.byName(joker),
    },
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

@JsonSerializable()
final class JokerStatsDto {
  const JokerStatsDto({
    required this.bestRunTotal,
    required this.runsWon,
    required this.timesPicked,
  });

  factory JokerStatsDto.fromDomain(JokerStats stats) => JokerStatsDto(
    bestRunTotal: stats.bestRunTotal,
    runsWon: stats.runsWon,
    timesPicked: stats.timesPicked,
  );

  factory JokerStatsDto.fromJson(Map<String, dynamic> json) =>
      _$JokerStatsDtoFromJson(json);

  final int bestRunTotal;
  final int runsWon;
  final int timesPicked;

  Map<String, dynamic> toJson() => _$JokerStatsDtoToJson(this);

  JokerStats toDomain() => JokerStats(
    bestRunTotal: bestRunTotal,
    runsWon: runsWon,
    timesPicked: timesPicked,
  );
}
