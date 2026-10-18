import 'package:flutter/widgets.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

String jokerName(BuildContext context, JokerId id) {
  final jokers = context.t.game.jokers;

  return switch (id) {
    .anchor => jokers.anchor.name,
    .avalanche => jokers.avalanche.name,
    .bigbox => jokers.bigbox.name,
    .brink => jokers.brink.name,
    .collector => jokers.collector.name,
    .column => jokers.column.name,
    .combo => jokers.combo.name,
    .ember => jokers.ember.name,
    .finisher => jokers.finisher.name,
    .fullhouse => jokers.fullhouse.name,
    .hattrick => jokers.hattrick.name,
    .heavy => jokers.heavy.name,
    .lantern => jokers.lantern.name,
    .momentum => jokers.momentum.name,
    .patience => jokers.patience.name,
    .pockets => jokers.pockets.name,
    .precision => jokers.precision.name,
    .quarry => jokers.quarry.name,
    .saver => jokers.saver.name,
    .sprinter => jokers.sprinter.name,
    .stonemason => jokers.stonemason.name,
    .sweep => jokers.sweep.name,
    .tiny => jokers.tiny.name,
    .twin => jokers.twin.name,
  };
}

/// What [id] does, with the numbers [tuning] and a [traySize] tray play it
/// with.
String jokerDescription(
  BuildContext context,
  JokerId id,
  JokerTuning tuning, {
  required int traySize,
}) {
  final jokers = context.t.game.jokers;

  return switch (id) {
    .anchor => jokers.anchor.description(mult: tuning.anchorMult),
    .avalanche => jokers.avalanche.description(
      chips: tuning.avalancheChipsPerCell,
      rows: tuning.avalancheRows,
    ),
    .bigbox => jokers.bigbox.description(
      factor: tuning.bigBoxFactor,
      size: tuning.bigBoxMinPieceSize,
    ),
    .brink => jokers.brink.description(
      cells: tuning.brinkMinOccupied,
      factor: tuning.brinkFactor,
    ),
    .collector => jokers.collector.description(
      mult: tuning.collectorMultPerJoker,
    ),
    .column => jokers.column.description(factor: tuning.columnFactor),
    .combo => jokers.combo.description(mult: tuning.comboMultPerStreak),
    .ember => jokers.ember.description(factor: tuning.emberFactor),
    .finisher => jokers.finisher.description(factor: tuning.finisherFactor),
    .fullhouse => jokers.fullhouse.description(
      cells: tuning.fullHouseCellsPerMult,
      mult: tuning.fullHouseMultPerBlock,
    ),
    .hattrick => jokers.hattrick.description(
      pieces: traySize,
      points: tuning.hatTrickBonus,
    ),
    .heavy => jokers.heavy.description(
      factor: tuning.heavyFactor,
      size: tuning.heavyMinPieceSize,
    ),
    .lantern => jokers.lantern.description,
    .momentum => jokers.momentum.description(mult: tuning.momentumMultPerTray),
    .patience => jokers.patience.description(
      mult: tuning.patienceStoredPerMove,
    ),
    .pockets => jokers.pockets.description(pieces: tuning.pocketsExtraPieces),
    .precision => jokers.precision.description(
      mult: tuning.precisionBonusMult,
      size: tuning.precisionMaxPieceSize,
    ),
    .quarry => jokers.quarry.description(stones: tuning.quarryStonesPerClear),
    .saver => jokers.saver.description(points: tuning.saverPointsPerPiece),
    .sprinter => jokers.sprinter.description(mult: tuning.sprinterMult),
    .stonemason => jokers.stonemason.description(
      chips: tuning.stonemasonChipsPerStone,
      stones: tuning.stonemasonExtraStones,
    ),
    .sweep => jokers.sweep.description(points: tuning.sweepBonus),
    .tiny => jokers.tiny.description(
      factor: tuning.tinyFactor,
      size: tuning.tinyMaxPieceSize,
    ),
    .twin => jokers.twin.description(
      factor: tuning.twinFactor,
      lines: tuning.twinMinLines,
    ),
  };
}
