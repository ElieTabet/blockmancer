import 'package:flutter/widgets.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

String jokerName(BuildContext context, JokerId id) {
  final jokers = context.t.game.jokers;

  return switch (id) {
    .anchor => jokers.anchor.name,
    .avalanche => jokers.avalanche.name,
    .bigbox => jokers.bigbox.name,
    .collector => jokers.collector.name,
    .column => jokers.column.name,
    .combo => jokers.combo.name,
    .heavy => jokers.heavy.name,
    .patience => jokers.patience.name,
    .pockets => jokers.pockets.name,
    .precision => jokers.precision.name,
    .quarry => jokers.quarry.name,
    .saver => jokers.saver.name,
    .stonemason => jokers.stonemason.name,
    .sweep => jokers.sweep.name,
    .tiny => jokers.tiny.name,
    .twin => jokers.twin.name,
  };
}

/// What [id] does, with the numbers [tuning] plays it with: a run's own
/// tuning in a run, so a joker Remote Config retuned never shows the old ones.
String jokerDescription(BuildContext context, JokerId id, JokerTuning tuning) {
  final jokers = context.t.game.jokers;

  return switch (id) {
    .anchor => jokers.anchor.description(mult: tuning.anchorMult),
    .avalanche => jokers.avalanche.description(
      chips: tuning.avalancheChipsPerCell,
    ),
    .bigbox => jokers.bigbox.description(
      factor: tuning.bigBoxFactor,
      size: tuning.bigBoxMinPieceSize,
    ),
    .collector => jokers.collector.description(
      mult: tuning.collectorMultPerJoker,
    ),
    .column => jokers.column.description(factor: tuning.columnFactor),
    .combo => jokers.combo.description(mult: tuning.comboMultPerStreak),
    .heavy => jokers.heavy.description(
      factor: tuning.heavyFactor,
      size: tuning.heavyMinPieceSize,
    ),
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

String jokerNames(BuildContext context, Iterable<JokerId> ids) =>
    ids.map((id) => jokerName(context, id)).join(', ');
