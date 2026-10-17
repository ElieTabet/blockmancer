// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.br.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
  bests: BestsDto.fromJson(json['bests'] as Map<String, dynamic>),
  progression: ProgressionDto.fromJson(
    json['progression'] as Map<String, dynamic>,
  ),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'bests': instance.bests.toJson(),
      'progression': instance.progression.toJson(),
      'version': instance.version,
    };

BestsDto _$BestsDtoFromJson(Map<String, dynamic> json) => BestsDto(
  daily: Map<String, int>.from(json['daily'] as Map),
  worlds: Map<String, int>.from(json['worlds'] as Map),
  practice: (json['practice'] as num?)?.toInt(),
);

Map<String, dynamic> _$BestsDtoToJson(BestsDto instance) => <String, dynamic>{
  'daily': instance.daily,
  'practice': instance.practice,
  'worlds': instance.worlds,
};

ProgressionDto _$ProgressionDtoFromJson(Map<String, dynamic> json) =>
    ProgressionDto(
      jokerStats: (json['jokerStats'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, JokerStatsDto.fromJson(e as Map<String, dynamic>)),
      ),
      tutorialDone: json['tutorialDone'] as bool,
      unlockedJokers: (json['unlockedJokers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      worlds: (json['worlds'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, WorldProgressDto.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ProgressionDtoToJson(ProgressionDto instance) =>
    <String, dynamic>{
      'jokerStats': instance.jokerStats.map((k, e) => MapEntry(k, e.toJson())),
      'tutorialDone': instance.tutorialDone,
      'unlockedJokers': instance.unlockedJokers,
      'worlds': instance.worlds.map((k, e) => MapEntry(k, e.toJson())),
    };

WorldProgressDto _$WorldProgressDtoFromJson(Map<String, dynamic> json) =>
    WorldProgressDto(
      bossBeaten: json['bossBeaten'] as bool,
      stars: WorldStarsDto.fromJson(json['stars'] as Map<String, dynamic>),
      unlocked: json['unlocked'] as bool,
    );

Map<String, dynamic> _$WorldProgressDtoToJson(WorldProgressDto instance) =>
    <String, dynamic>{
      'bossBeaten': instance.bossBeaten,
      'stars': instance.stars.toJson(),
      'unlocked': instance.unlocked,
    };

WorldStarsDto _$WorldStarsDtoFromJson(Map<String, dynamic> json) =>
    WorldStarsDto(
      bossBeaten: json['bossBeaten'] as bool,
      noRevive: json['noRevive'] as bool,
      scoreThreshold: json['scoreThreshold'] as bool,
    );

Map<String, dynamic> _$WorldStarsDtoToJson(WorldStarsDto instance) =>
    <String, dynamic>{
      'bossBeaten': instance.bossBeaten,
      'noRevive': instance.noRevive,
      'scoreThreshold': instance.scoreThreshold,
    };

JokerStatsDto _$JokerStatsDtoFromJson(Map<String, dynamic> json) =>
    JokerStatsDto(
      bestRunTotal: (json['bestRunTotal'] as num).toInt(),
      runsWon: (json['runsWon'] as num).toInt(),
      timesPicked: (json['timesPicked'] as num).toInt(),
    );

Map<String, dynamic> _$JokerStatsDtoToJson(JokerStatsDto instance) =>
    <String, dynamic>{
      'bestRunTotal': instance.bestRunTotal,
      'runsWon': instance.runsWon,
      'timesPicked': instance.timesPicked,
    };
