import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'saved_run_dto.br.g.dart';

/// The saved run's schema version. Bump it with each change to these DTOs,
/// and teach `migrate` to bring the previous version up to it.
const savedRunVersion = 3;

/// Brings a saved run written by an earlier version up to [savedRunVersion],
/// one version at a time; a version this build doesn't know is unreadable.
Map<String, dynamic> migrate(Map<String, dynamic> json) =>
    switch (json['version']) {
      1 => migrate(_fromVersion1(json)),
      2 => migrate(_fromVersion2(json)),
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
  });

  factory SavedRunDto.fromDomain(SavedRun saved) => SavedRunDto(
    day: switch (saved.mode) {
      DailyMode(:final day) => day,
      PracticeMode() => null,
    },
    mode: switch (saved.mode) {
      DailyMode() => _daily,
      PracticeMode() => _practice,
    },
    run: .fromDomain(saved.run),
    version: savedRunVersion,
  );

  factory SavedRunDto.fromJson(Map<String, dynamic> json) =>
      _$SavedRunDtoFromJson(json);

  static const _daily = 'daily';
  static const _practice = 'practice';

  /// A daily run's UTC day, `yyyymmdd`; null for practice.
  final int? day;
  final String mode;
  final RunStateDto run;
  final int version;

  Map<String, dynamic> toJson() => _$SavedRunDtoToJson(this);

  SavedRun toDomain() => SavedRun(
    mode: switch (mode) {
      _daily => .daily(day: day!),
      _practice => const .practice(),
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
    required this.jokers,
    required this.offerCount,
    required this.partnerBias,
    required this.revivePieces,
    required this.reviveRows,
    required this.revivesPerRun,
    required this.rounds,
    required this.traySize,
    required this.world,
  });

  factory RunConfigDto.fromDomain(RunConfig config) => RunConfigDto(
    chipsPerCell: config.chipsPerCell,
    jokers: .fromDomain(config.jokers),
    offerCount: config.offerCount,
    partnerBias: config.partnerBias,
    revivePieces: config.revivePieces,
    reviveRows: config.reviveRows,
    revivesPerRun: config.revivesPerRun,
    rounds: [for (final round in config.rounds) .fromDomain(round)],
    traySize: config.traySize,
    world: config.world.name,
  );

  factory RunConfigDto.fromJson(Map<String, dynamic> json) =>
      _$RunConfigDtoFromJson(json);

  final int chipsPerCell;
  final JokerTuningDto jokers;
  final int offerCount;
  final double partnerBias;
  final int revivePieces;
  final int reviveRows;
  final int revivesPerRun;
  final List<RoundSpecDto> rounds;
  final int traySize;
  final String world;

  Map<String, dynamic> toJson() => _$RunConfigDtoToJson(this);

  RunConfig toDomain() => RunConfig(
    chipsPerCell: chipsPerCell,
    jokers: jokers.toDomain(),
    offerCount: offerCount,
    partnerBias: partnerBias,
    revivePieces: revivePieces,
    reviveRows: reviveRows,
    revivesPerRun: revivesPerRun,
    rounds: [for (final round in rounds) round.toDomain()],
    traySize: traySize,
    world: WorldId.values.byName(world),
  );
}

@JsonSerializable()
final class JokerTuningDto {
  const JokerTuningDto({
    required this.bigBoxFactor,
    required this.bigBoxMinPieceSize,
    required this.collectorMultPerJoker,
    required this.columnFactor,
    required this.comboMultPerStreak,
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
    bigBoxFactor: tuning.bigBoxFactor,
    bigBoxMinPieceSize: tuning.bigBoxMinPieceSize,
    collectorMultPerJoker: tuning.collectorMultPerJoker,
    columnFactor: tuning.columnFactor,
    comboMultPerStreak: tuning.comboMultPerStreak,
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

  final int bigBoxFactor;
  final int bigBoxMinPieceSize;
  final int collectorMultPerJoker;
  final int columnFactor;
  final int comboMultPerStreak;
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
    bigBoxFactor: bigBoxFactor,
    bigBoxMinPieceSize: bigBoxMinPieceSize,
    collectorMultPerJoker: collectorMultPerJoker,
    columnFactor: columnFactor,
    comboMultPerStreak: comboMultPerStreak,
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
