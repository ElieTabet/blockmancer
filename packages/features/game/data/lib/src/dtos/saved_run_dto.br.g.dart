// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_run_dto.br.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedRunDto _$SavedRunDtoFromJson(Map<String, dynamic> json) => SavedRunDto(
  mode: json['mode'] as String,
  run: RunStateDto.fromJson(json['run'] as Map<String, dynamic>),
  version: (json['version'] as num).toInt(),
  day: (json['day'] as num?)?.toInt(),
  world: json['world'] as String?,
);

Map<String, dynamic> _$SavedRunDtoToJson(SavedRunDto instance) =>
    <String, dynamic>{
      'day': instance.day,
      'mode': instance.mode,
      'run': instance.run.toJson(),
      'version': instance.version,
      'world': instance.world,
    };

RunStateDto _$RunStateDtoFromJson(Map<String, dynamic> json) => RunStateDto(
  board: (json['board'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  config: RunConfigDto.fromJson(json['config'] as Map<String, dynamic>),
  jokers: (json['jokers'] as List<dynamic>).map((e) => e as String).toList(),
  phase: RunPhaseDto.fromJson(json['phase'] as Map<String, dynamic>),
  pickIndex: (json['pickIndex'] as num).toInt(),
  piecesLeft: (json['piecesLeft'] as num).toInt(),
  piecesRngState: (json['piecesRngState'] as num).toInt(),
  revivesUsed: (json['revivesUsed'] as num).toInt(),
  roundIndex: (json['roundIndex'] as num).toInt(),
  runTotal: (json['runTotal'] as num).toInt(),
  score: (json['score'] as num).toInt(),
  seed: (json['seed'] as num).toInt(),
  stonesRngState: (json['stonesRngState'] as num).toInt(),
  storedMult: (json['storedMult'] as num).toInt(),
  streak: (json['streak'] as num).toInt(),
  tray: (json['tray'] as List<dynamic>)
      .map((e) => (e as num?)?.toInt())
      .toList(),
  trayClearMask: (json['trayClearMask'] as num?)?.toInt(),
);

Map<String, dynamic> _$RunStateDtoToJson(RunStateDto instance) =>
    <String, dynamic>{
      'board': instance.board,
      'config': instance.config.toJson(),
      'jokers': instance.jokers,
      'phase': instance.phase.toJson(),
      'pickIndex': instance.pickIndex,
      'piecesLeft': instance.piecesLeft,
      'piecesRngState': instance.piecesRngState,
      'revivesUsed': instance.revivesUsed,
      'roundIndex': instance.roundIndex,
      'runTotal': instance.runTotal,
      'score': instance.score,
      'seed': instance.seed,
      'stonesRngState': instance.stonesRngState,
      'storedMult': instance.storedMult,
      'streak': instance.streak,
      'tray': instance.tray,
      'trayClearMask': instance.trayClearMask,
    };

RunConfigDto _$RunConfigDtoFromJson(Map<String, dynamic> json) => RunConfigDto(
  chipsPerCell: (json['chipsPerCell'] as num).toInt(),
  jokerPool: (json['jokerPool'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  jokers: JokerTuningDto.fromJson(json['jokers'] as Map<String, dynamic>),
  offerCount: (json['offerCount'] as num).toInt(),
  partnerBias: (json['partnerBias'] as num).toDouble(),
  revivePieces: (json['revivePieces'] as num).toInt(),
  reviveRows: (json['reviveRows'] as num).toInt(),
  revivesPerRun: (json['revivesPerRun'] as num).toInt(),
  rounds: (json['rounds'] as List<dynamic>)
      .map((e) => RoundSpecDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  starThreshold: (json['starThreshold'] as num).toInt(),
  starUnlocks: (json['starUnlocks'] as List<dynamic>)
      .map((e) => StarUnlockDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  traySize: (json['traySize'] as num).toInt(),
  world: json['world'] as String,
);

Map<String, dynamic> _$RunConfigDtoToJson(RunConfigDto instance) =>
    <String, dynamic>{
      'chipsPerCell': instance.chipsPerCell,
      'jokerPool': instance.jokerPool,
      'jokers': instance.jokers.toJson(),
      'offerCount': instance.offerCount,
      'partnerBias': instance.partnerBias,
      'revivePieces': instance.revivePieces,
      'reviveRows': instance.reviveRows,
      'revivesPerRun': instance.revivesPerRun,
      'rounds': instance.rounds.map((e) => e.toJson()).toList(),
      'starThreshold': instance.starThreshold,
      'starUnlocks': instance.starUnlocks.map((e) => e.toJson()).toList(),
      'traySize': instance.traySize,
      'world': instance.world,
    };

StarUnlockDto _$StarUnlockDtoFromJson(Map<String, dynamic> json) =>
    StarUnlockDto(
      jokers: (json['jokers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      stars: (json['stars'] as num).toInt(),
    );

Map<String, dynamic> _$StarUnlockDtoToJson(StarUnlockDto instance) =>
    <String, dynamic>{'jokers': instance.jokers, 'stars': instance.stars};

JokerTuningDto _$JokerTuningDtoFromJson(Map<String, dynamic> json) =>
    JokerTuningDto(
      anchorMult: (json['anchorMult'] as num).toInt(),
      avalancheChipsPerCell: (json['avalancheChipsPerCell'] as num).toInt(),
      bigBoxFactor: (json['bigBoxFactor'] as num).toInt(),
      bigBoxMinPieceSize: (json['bigBoxMinPieceSize'] as num).toInt(),
      brinkFactor: (json['brinkFactor'] as num).toInt(),
      brinkMinOccupied: (json['brinkMinOccupied'] as num).toInt(),
      collectorMultPerJoker: (json['collectorMultPerJoker'] as num).toInt(),
      columnFactor: (json['columnFactor'] as num).toInt(),
      comboMultPerStreak: (json['comboMultPerStreak'] as num).toInt(),
      finisherFactor: (json['finisherFactor'] as num).toInt(),
      fullHouseCellsPerMult: (json['fullHouseCellsPerMult'] as num).toInt(),
      hatTrickBonus: (json['hatTrickBonus'] as num).toInt(),
      heavyFactor: (json['heavyFactor'] as num).toInt(),
      heavyMinPieceSize: (json['heavyMinPieceSize'] as num).toInt(),
      patienceStoredPerMove: (json['patienceStoredPerMove'] as num).toInt(),
      pocketsExtraPieces: (json['pocketsExtraPieces'] as num).toInt(),
      precisionBonusMult: (json['precisionBonusMult'] as num).toInt(),
      precisionMaxPieceSize: (json['precisionMaxPieceSize'] as num).toInt(),
      quarryStonesPerClear: (json['quarryStonesPerClear'] as num).toInt(),
      saverPointsPerPiece: (json['saverPointsPerPiece'] as num).toInt(),
      stonemasonChipsPerStone: (json['stonemasonChipsPerStone'] as num).toInt(),
      stonemasonExtraStones: (json['stonemasonExtraStones'] as num).toInt(),
      sweepBonus: (json['sweepBonus'] as num).toInt(),
      tinyFactor: (json['tinyFactor'] as num).toInt(),
      tinyMaxPieceSize: (json['tinyMaxPieceSize'] as num).toInt(),
      twinFactor: (json['twinFactor'] as num).toInt(),
      twinMinLines: (json['twinMinLines'] as num).toInt(),
    );

Map<String, dynamic> _$JokerTuningDtoToJson(JokerTuningDto instance) =>
    <String, dynamic>{
      'anchorMult': instance.anchorMult,
      'avalancheChipsPerCell': instance.avalancheChipsPerCell,
      'bigBoxFactor': instance.bigBoxFactor,
      'bigBoxMinPieceSize': instance.bigBoxMinPieceSize,
      'brinkFactor': instance.brinkFactor,
      'brinkMinOccupied': instance.brinkMinOccupied,
      'collectorMultPerJoker': instance.collectorMultPerJoker,
      'columnFactor': instance.columnFactor,
      'comboMultPerStreak': instance.comboMultPerStreak,
      'finisherFactor': instance.finisherFactor,
      'fullHouseCellsPerMult': instance.fullHouseCellsPerMult,
      'hatTrickBonus': instance.hatTrickBonus,
      'heavyFactor': instance.heavyFactor,
      'heavyMinPieceSize': instance.heavyMinPieceSize,
      'patienceStoredPerMove': instance.patienceStoredPerMove,
      'pocketsExtraPieces': instance.pocketsExtraPieces,
      'precisionBonusMult': instance.precisionBonusMult,
      'precisionMaxPieceSize': instance.precisionMaxPieceSize,
      'quarryStonesPerClear': instance.quarryStonesPerClear,
      'saverPointsPerPiece': instance.saverPointsPerPiece,
      'stonemasonChipsPerStone': instance.stonemasonChipsPerStone,
      'stonemasonExtraStones': instance.stonemasonExtraStones,
      'sweepBonus': instance.sweepBonus,
      'tinyFactor': instance.tinyFactor,
      'tinyMaxPieceSize': instance.tinyMaxPieceSize,
      'twinFactor': instance.twinFactor,
      'twinMinLines': instance.twinMinLines,
    };

RoundSpecDto _$RoundSpecDtoFromJson(Map<String, dynamic> json) => RoundSpecDto(
  isBoss: json['isBoss'] as bool,
  pieces: (json['pieces'] as num).toInt(),
  stones: (json['stones'] as num).toInt(),
  target: (json['target'] as num).toInt(),
);

Map<String, dynamic> _$RoundSpecDtoToJson(RoundSpecDto instance) =>
    <String, dynamic>{
      'isBoss': instance.isBoss,
      'pieces': instance.pieces,
      'stones': instance.stones,
      'target': instance.target,
    };

RunPhaseDto _$RunPhaseDtoFromJson(Map<String, dynamic> json) => RunPhaseDto(
  kind: json['kind'] as String,
  offers: (json['offers'] as List<dynamic>?)?.map((e) => e as String).toList(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$RunPhaseDtoToJson(RunPhaseDto instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'offers': instance.offers,
      'reason': instance.reason,
    };
