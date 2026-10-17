import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'saved_run_dto.br.g.dart';

/// The saved run's schema version. Bump it with each change to these DTOs,
/// and teach `migrate` to bring the previous version up to it.
const savedRunVersion = 7;

/// Brings a saved run written by an earlier version up to [savedRunVersion],
/// one version at a time; a version this build doesn't know is unreadable.
Map<String, dynamic> migrate(Map<String, dynamic> json) =>
    switch (json['version']) {
      1 => migrate(_fromVersion1(json)),
      2 => migrate(_fromVersion2(json)),
      3 => migrate(_fromVersion3(json)),
      4 => migrate(_fromVersion4(json)),
      5 => migrate(_fromVersion5(json)),
      6 => migrate(_fromVersion6(json)),
      savedRunVersion => json,
      final version => throw FormatException('Saved run version $version'),
    };

/// Version 1 saved no chips per cell and no joker numbers: they were constants
/// of the build, so its runs resume with the values they were played with.
/// Literals rather than today's defaults, which may have moved since.
Map<String, dynamic> _fromVersion1(Map<String, dynamic> json) {
  final run = json['run'] as Map<String, dynamic>;
  final config = run['config'] as Map<String, dynamic>;

  return {
    ...json,
    'run': <String, dynamic>{
      ...run,
      'config': <String, dynamic>{
        ...config,
        'chipsPerCell': 10,
        'jokers': _version1Jokers,
      },
    },
    'version': 2,
  };
}

/// Every run before version 3 was played in Rubble, the only world there was.
Map<String, dynamic> _fromVersion2(Map<String, dynamic> json) {
  final run = json['run'] as Map<String, dynamic>;
  final config = run['config'] as Map<String, dynamic>;

  return {
    ...json,
    'run': <String, dynamic>{
      ...run,
      'config': <String, dynamic>{...config, 'world': 'rubble'},
    },
    'version': 3,
  };
}

/// Version 3 knew neither Anchor nor Avalanche: its runs go on drawing from
/// the 14 jokers there were, so they offer what they would have. Neither joker
/// can be owned there, so their numbers only complete the schema.
Map<String, dynamic> _fromVersion3(Map<String, dynamic> json) {
  final run = json['run'] as Map<String, dynamic>;
  final config = run['config'] as Map<String, dynamic>;

  return {
    ...json,
    'run': <String, dynamic>{
      ...run,
      'config': <String, dynamic>{
        ...config,
        'jokerPool': _version3Pool,
        'jokers': <String, dynamic>{
          ...config['jokers'] as Map<String, dynamic>,
          'anchorMult': 4,
          'avalancheChipsPerCell': 25,
        },
      },
    },
    'version': 4,
  };
}

/// Version 4 had no third star: its runs take the threshold version 5 first
/// gave their world, as literals since the defaults may move.
Map<String, dynamic> _fromVersion4(Map<String, dynamic> json) {
  final run = json['run'] as Map<String, dynamic>;
  final config = run['config'] as Map<String, dynamic>;
  final starThreshold = switch (config['world']) {
    'gravity' => 8250,
    'rubble' => 8000,
    final world => throw FormatException('Saved run world $world'),
  };

  return {
    ...json,
    'run': <String, dynamic>{
      ...run,
      'config': <String, dynamic>{...config, 'starThreshold': starThreshold},
    },
    'version': 5,
  };
}

/// Version 6 added world runs, which name their world; every run version 5
/// saved was a daily or a practice one, and reads as it was.
Map<String, dynamic> _fromVersion5(Map<String, dynamic> json) => {
  ...json,
  'version': 6,
};

/// Version 6 knew neither the stars' four jokers nor Hat Trick's tray: its
/// runs go on drawing from the pool they saved, which lacks them, so the new
/// numbers only complete the schema, and the tray in hand can't earn Hat
/// Trick. The star unlocks are the ones version 7 first shipped, as literals.
Map<String, dynamic> _fromVersion6(Map<String, dynamic> json) {
  final run = json['run'] as Map<String, dynamic>;
  final config = run['config'] as Map<String, dynamic>;

  return {
    ...json,
    'run': <String, dynamic>{
      ...run,
      'config': <String, dynamic>{
        ...config,
        'jokers': <String, dynamic>{
          ...config['jokers'] as Map<String, dynamic>,
          'brinkFactor': 2,
          'brinkMinOccupied': 40,
          'finisherFactor': 2,
          'fullHouseCellsPerMult': 6,
          'hatTrickBonus': 300,
        },
        'starUnlocks': _version7StarUnlocks,
      },
      'trayClearMask': null,
    },
    'version': 7,
  };
}

const _version7StarUnlocks = [
  {
    'jokers': ['fullhouse', 'brink'],
    'stars': 4,
  },
  {
    'jokers': ['finisher', 'hattrick'],
    'stars': 6,
  },
];

const _version3Pool = [
  'bigbox',
  'collector',
  'column',
  'combo',
  'heavy',
  'patience',
  'pockets',
  'precision',
  'quarry',
  'saver',
  'stonemason',
  'sweep',
  'tiny',
  'twin',
];

const Map<String, dynamic> _version1Jokers = {
  'bigBoxFactor': 3,
  'bigBoxMinPieceSize': 5,
  'collectorMultPerJoker': 1,
  'columnFactor': 2,
  'comboMultPerStreak': 1,
  'heavyFactor': 2,
  'heavyMinPieceSize': 4,
  'patienceStoredPerMove': 2,
  'pocketsExtraPieces': 4,
  'precisionBonusMult': 6,
  'precisionMaxPieceSize': 2,
  'quarryStonesPerClear': 1,
  'saverPointsPerPiece': 40,
  'stonemasonChipsPerStone': 50,
  'stonemasonExtraStones': 2,
  'sweepBonus': 500,
  'tinyFactor': 3,
  'tinyMaxPieceSize': 2,
  'twinFactor': 3,
  'twinMinLines': 2,
};

@JsonSerializable(explicitToJson: true)
final class SavedRunDto {
  const SavedRunDto({
    required this.mode,
    required this.run,
    required this.version,
    this.day,
    this.world,
  });

  factory SavedRunDto.fromDomain(SavedRun saved) => SavedRunDto(
    day: switch (saved.mode) {
      DailyMode(:final day) => day,
      PracticeMode() || WorldMode() => null,
    },
    mode: switch (saved.mode) {
      DailyMode() => _daily,
      PracticeMode() => _practice,
      WorldMode() => _world,
    },
    run: .fromDomain(saved.run),
    version: savedRunVersion,
    world: switch (saved.mode) {
      WorldMode(:final world) => world.name,
      DailyMode() || PracticeMode() => null,
    },
  );

  factory SavedRunDto.fromJson(Map<String, dynamic> json) =>
      _$SavedRunDtoFromJson(json);

  static const _daily = 'daily';
  static const _practice = 'practice';
  static const _world = 'world';

  /// A daily run's UTC day, `yyyymmdd`; null for the others.
  final int? day;
  final String mode;
  final RunStateDto run;
  final int version;

  /// A world run's world; null for the others.
  final String? world;

  Map<String, dynamic> toJson() => _$SavedRunDtoToJson(this);

  SavedRun toDomain() => SavedRun(
    mode: switch (mode) {
      _daily => .daily(day: day!),
      _practice => const .practice(),
      _world => .world(world: WorldId.values.byName(world!)),
      _ => throw FormatException('Unknown mode $mode'),
    },
    run: run.toDomain(),
  );
}

@JsonSerializable(explicitToJson: true)
final class RunStateDto {
  const RunStateDto({
    required this.board,
    required this.config,
    required this.jokers,
    required this.phase,
    required this.pickIndex,
    required this.piecesLeft,
    required this.piecesRngState,
    required this.revivesUsed,
    required this.roundIndex,
    required this.runTotal,
    required this.score,
    required this.seed,
    required this.stonesRngState,
    required this.storedMult,
    required this.streak,
    required this.tray,
    this.trayClearMask,
  });

  factory RunStateDto.fromDomain(RunState run) => RunStateDto(
    board: [for (final cell in run.board.cells) _cellCode(cell)],
    config: .fromDomain(run.config),
    jokers: [for (final joker in run.jokers) joker.name],
    phase: .fromDomain(run.phase),
    pickIndex: run.pickIndex,
    piecesLeft: run.piecesLeft,
    piecesRngState: run.piecesRngState,
    revivesUsed: run.revivesUsed,
    roundIndex: run.roundIndex,
    runTotal: run.runTotal,
    score: run.score,
    seed: run.seed,
    stonesRngState: run.stonesRngState,
    storedMult: run.storedMult,
    streak: run.streak,
    tray: run.tray,
    trayClearMask: run.trayClearMask,
  );

  factory RunStateDto.fromJson(Map<String, dynamic> json) =>
      _$RunStateDtoFromJson(json);

  /// One code per cell, row-major: 0 empty, -1 stone, a filled cell's colour
  /// index plus one.
  final List<int> board;
  final RunConfigDto config;
  final List<String> jokers;
  final RunPhaseDto phase;
  final int pickIndex;
  final int piecesLeft;
  final int piecesRngState;
  final int revivesUsed;
  final int roundIndex;
  final int runTotal;
  final int score;
  final int seed;
  final int stonesRngState;
  final int storedMult;
  final int streak;
  final List<int?> tray;
  final int? trayClearMask;

  Map<String, dynamic> toJson() => _$RunStateDtoToJson(this);

  RunState toDomain() {
    if (board.length != Board.cellCount) {
      throw FormatException('A board of ${board.length} cells');
    }

    return RunState(
      board: Board(cells: [for (final code in board) _cellOf(code)]),
      config: config.toDomain(),
      jokers: [for (final joker in jokers) JokerId.values.byName(joker)],
      phase: phase.toDomain(),
      pickIndex: pickIndex,
      piecesLeft: piecesLeft,
      piecesRngState: piecesRngState,
      revivesUsed: revivesUsed,
      roundIndex: roundIndex,
      runTotal: runTotal,
      score: score,
      seed: seed,
      stonesRngState: stonesRngState,
      storedMult: storedMult,
      streak: streak,
      tray: tray,
      trayClearMask: trayClearMask,
    );
  }

  static int _cellCode(CellState cell) => switch (cell) {
    EmptyCell() => 0,
    FilledCell(:final colorIndex) => colorIndex + 1,
    StoneCell() => -1,
  };

  static CellState _cellOf(int code) => switch (code) {
    0 => const .empty(),
    -1 => const .stone(),
    _ when code > 0 => .filled(colorIndex: code - 1),
    _ => throw FormatException('Unknown cell $code'),
  };
}

@JsonSerializable(explicitToJson: true)
final class RunConfigDto {
  const RunConfigDto({
    required this.chipsPerCell,
    required this.jokerPool,
    required this.jokers,
    required this.offerCount,
    required this.partnerBias,
    required this.revivePieces,
    required this.reviveRows,
    required this.revivesPerRun,
    required this.rounds,
    required this.starThreshold,
    required this.starUnlocks,
    required this.traySize,
    required this.world,
  });

  factory RunConfigDto.fromDomain(RunConfig config) => RunConfigDto(
    chipsPerCell: config.chipsPerCell,
    jokerPool: [for (final joker in config.jokerPool) joker.name],
    jokers: .fromDomain(config.jokers),
    offerCount: config.offerCount,
    partnerBias: config.partnerBias,
    revivePieces: config.revivePieces,
    reviveRows: config.reviveRows,
    revivesPerRun: config.revivesPerRun,
    rounds: [for (final round in config.rounds) .fromDomain(round)],
    starThreshold: config.starThreshold,
    starUnlocks: [for (final unlock in config.starUnlocks) .fromDomain(unlock)],
    traySize: config.traySize,
    world: config.world.name,
  );

  factory RunConfigDto.fromJson(Map<String, dynamic> json) =>
      _$RunConfigDtoFromJson(json);

  final int chipsPerCell;
  final List<String> jokerPool;
  final JokerTuningDto jokers;
  final int offerCount;
  final double partnerBias;
  final int revivePieces;
  final int reviveRows;
  final int revivesPerRun;
  final List<RoundSpecDto> rounds;
  final int starThreshold;
  final List<StarUnlockDto> starUnlocks;
  final int traySize;
  final String world;

  Map<String, dynamic> toJson() => _$RunConfigDtoToJson(this);

  RunConfig toDomain() => RunConfig(
    chipsPerCell: chipsPerCell,
    jokerPool: [for (final joker in jokerPool) JokerId.values.byName(joker)],
    jokers: jokers.toDomain(),
    offerCount: offerCount,
    partnerBias: partnerBias,
    revivePieces: revivePieces,
    reviveRows: reviveRows,
    revivesPerRun: revivesPerRun,
    rounds: [for (final round in rounds) round.toDomain()],
    starThreshold: starThreshold,
    starUnlocks: [for (final unlock in starUnlocks) unlock.toDomain()],
    traySize: traySize,
    world: WorldId.values.byName(world),
  );
}

@JsonSerializable()
final class StarUnlockDto {
  const StarUnlockDto({required this.jokers, required this.stars});

  factory StarUnlockDto.fromDomain(StarUnlock unlock) => StarUnlockDto(
    jokers: [for (final joker in unlock.jokers) joker.name],
    stars: unlock.stars,
  );

  factory StarUnlockDto.fromJson(Map<String, dynamic> json) =>
      _$StarUnlockDtoFromJson(json);

  final List<String> jokers;
  final int stars;

  Map<String, dynamic> toJson() => _$StarUnlockDtoToJson(this);

  StarUnlock toDomain() => StarUnlock(
    jokers: [for (final joker in jokers) JokerId.values.byName(joker)],
    stars: stars,
  );
}

@JsonSerializable()
final class JokerTuningDto {
  const JokerTuningDto({
    required this.anchorMult,
    required this.avalancheChipsPerCell,
    required this.bigBoxFactor,
    required this.bigBoxMinPieceSize,
    required this.brinkFactor,
    required this.brinkMinOccupied,
    required this.collectorMultPerJoker,
    required this.columnFactor,
    required this.comboMultPerStreak,
    required this.finisherFactor,
    required this.fullHouseCellsPerMult,
    required this.hatTrickBonus,
    required this.heavyFactor,
    required this.heavyMinPieceSize,
    required this.patienceStoredPerMove,
    required this.pocketsExtraPieces,
    required this.precisionBonusMult,
    required this.precisionMaxPieceSize,
    required this.quarryStonesPerClear,
    required this.saverPointsPerPiece,
    required this.stonemasonChipsPerStone,
    required this.stonemasonExtraStones,
    required this.sweepBonus,
    required this.tinyFactor,
    required this.tinyMaxPieceSize,
    required this.twinFactor,
    required this.twinMinLines,
  });

  factory JokerTuningDto.fromDomain(JokerTuning tuning) => JokerTuningDto(
    anchorMult: tuning.anchorMult,
    avalancheChipsPerCell: tuning.avalancheChipsPerCell,
    bigBoxFactor: tuning.bigBoxFactor,
    bigBoxMinPieceSize: tuning.bigBoxMinPieceSize,
    brinkFactor: tuning.brinkFactor,
    brinkMinOccupied: tuning.brinkMinOccupied,
    collectorMultPerJoker: tuning.collectorMultPerJoker,
    columnFactor: tuning.columnFactor,
    comboMultPerStreak: tuning.comboMultPerStreak,
    finisherFactor: tuning.finisherFactor,
    fullHouseCellsPerMult: tuning.fullHouseCellsPerMult,
    hatTrickBonus: tuning.hatTrickBonus,
    heavyFactor: tuning.heavyFactor,
    heavyMinPieceSize: tuning.heavyMinPieceSize,
    patienceStoredPerMove: tuning.patienceStoredPerMove,
    pocketsExtraPieces: tuning.pocketsExtraPieces,
    precisionBonusMult: tuning.precisionBonusMult,
    precisionMaxPieceSize: tuning.precisionMaxPieceSize,
    quarryStonesPerClear: tuning.quarryStonesPerClear,
    saverPointsPerPiece: tuning.saverPointsPerPiece,
    stonemasonChipsPerStone: tuning.stonemasonChipsPerStone,
    stonemasonExtraStones: tuning.stonemasonExtraStones,
    sweepBonus: tuning.sweepBonus,
    tinyFactor: tuning.tinyFactor,
    tinyMaxPieceSize: tuning.tinyMaxPieceSize,
    twinFactor: tuning.twinFactor,
    twinMinLines: tuning.twinMinLines,
  );

  factory JokerTuningDto.fromJson(Map<String, dynamic> json) =>
      _$JokerTuningDtoFromJson(json);

  final int anchorMult;
  final int avalancheChipsPerCell;
  final int bigBoxFactor;
  final int bigBoxMinPieceSize;
  final int brinkFactor;
  final int brinkMinOccupied;
  final int collectorMultPerJoker;
  final int columnFactor;
  final int comboMultPerStreak;
  final int finisherFactor;
  final int fullHouseCellsPerMult;
  final int hatTrickBonus;
  final int heavyFactor;
  final int heavyMinPieceSize;
  final int patienceStoredPerMove;
  final int pocketsExtraPieces;
  final int precisionBonusMult;
  final int precisionMaxPieceSize;
  final int quarryStonesPerClear;
  final int saverPointsPerPiece;
  final int stonemasonChipsPerStone;
  final int stonemasonExtraStones;
  final int sweepBonus;
  final int tinyFactor;
  final int tinyMaxPieceSize;
  final int twinFactor;
  final int twinMinLines;

  Map<String, dynamic> toJson() => _$JokerTuningDtoToJson(this);

  JokerTuning toDomain() => JokerTuning(
    anchorMult: anchorMult,
    avalancheChipsPerCell: avalancheChipsPerCell,
    bigBoxFactor: bigBoxFactor,
    bigBoxMinPieceSize: bigBoxMinPieceSize,
    brinkFactor: brinkFactor,
    brinkMinOccupied: brinkMinOccupied,
    collectorMultPerJoker: collectorMultPerJoker,
    columnFactor: columnFactor,
    comboMultPerStreak: comboMultPerStreak,
    finisherFactor: finisherFactor,
    fullHouseCellsPerMult: fullHouseCellsPerMult,
    hatTrickBonus: hatTrickBonus,
    heavyFactor: heavyFactor,
    heavyMinPieceSize: heavyMinPieceSize,
    patienceStoredPerMove: patienceStoredPerMove,
    pocketsExtraPieces: pocketsExtraPieces,
    precisionBonusMult: precisionBonusMult,
    precisionMaxPieceSize: precisionMaxPieceSize,
    quarryStonesPerClear: quarryStonesPerClear,
    saverPointsPerPiece: saverPointsPerPiece,
    stonemasonChipsPerStone: stonemasonChipsPerStone,
    stonemasonExtraStones: stonemasonExtraStones,
    sweepBonus: sweepBonus,
    tinyFactor: tinyFactor,
    tinyMaxPieceSize: tinyMaxPieceSize,
    twinFactor: twinFactor,
    twinMinLines: twinMinLines,
  );
}

@JsonSerializable()
final class RoundSpecDto {
  const RoundSpecDto({
    required this.isBoss,
    required this.pieces,
    required this.stones,
    required this.target,
  });

  factory RoundSpecDto.fromDomain(RoundSpec round) => RoundSpecDto(
    isBoss: round.isBoss,
    pieces: round.pieces,
    stones: round.stones,
    target: round.target,
  );

  factory RoundSpecDto.fromJson(Map<String, dynamic> json) =>
      _$RoundSpecDtoFromJson(json);

  final bool isBoss;
  final int pieces;
  final int stones;
  final int target;

  Map<String, dynamic> toJson() => _$RoundSpecDtoToJson(this);

  RoundSpec toDomain() =>
      RoundSpec(isBoss: isBoss, pieces: pieces, stones: stones, target: target);
}

/// [RunPhase] as a tag, with the offers or the loss reason it carries.
@JsonSerializable()
final class RunPhaseDto {
  const RunPhaseDto({required this.kind, this.offers, this.reason});

  factory RunPhaseDto.fromDomain(RunPhase phase) => switch (phase) {
    OverPhase() => const RunPhaseDto(kind: _over),
    PickingJokerPhase(:final offers) => RunPhaseDto(
      kind: _pickingJoker,
      offers: [for (final offer in offers) offer.name],
    ),
    PlayingPhase() => const RunPhaseDto(kind: _playing),
    RoundLostPhase(:final reason) => RunPhaseDto(
      kind: _roundLost,
      reason: reason.name,
    ),
    WonPhase() => const RunPhaseDto(kind: _won),
  };

  factory RunPhaseDto.fromJson(Map<String, dynamic> json) =>
      _$RunPhaseDtoFromJson(json);

  static const _over = 'over';
  static const _pickingJoker = 'pickingJoker';
  static const _playing = 'playing';
  static const _roundLost = 'roundLost';
  static const _won = 'won';

  final String kind;
  final List<String>? offers;
  final String? reason;

  Map<String, dynamic> toJson() => _$RunPhaseDtoToJson(this);

  RunPhase toDomain() => switch (kind) {
    _over => const .over(),
    _pickingJoker => .pickingJoker(
      offers: [for (final offer in offers!) JokerId.values.byName(offer)],
    ),
    _playing => const .playing(),
    _roundLost => .roundLost(reason: LossReason.values.byName(reason!)),
    _won => const .won(),
    _ => throw FormatException('Unknown phase $kind'),
  };
}
