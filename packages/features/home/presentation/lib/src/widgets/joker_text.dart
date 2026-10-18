import 'package:flutter/widgets.dart';
import 'package:home_presentation/src/entities/joker_mastery.dart';
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
    .prism => jokers.prism.name,
    .quarry => jokers.quarry.name,
    .saver => jokers.saver.name,
    .sprinter => jokers.sprinter.name,
    .stonemason => jokers.stonemason.name,
    .sweep => jokers.sweep.name,
    .symmetry => jokers.symmetry.name,
    .tiny => jokers.tiny.name,
    .twin => jokers.twin.name,
  };
}

/// [id]'s name as a card fits it.
String jokerShortName(BuildContext context, JokerId id) {
  final jokers = context.t.game.jokers;

  return switch (id) {
    .anchor => jokers.anchor.short,
    .avalanche => jokers.avalanche.short,
    .bigbox => jokers.bigbox.short,
    .brink => jokers.brink.short,
    .collector => jokers.collector.short,
    .column => jokers.column.short,
    .combo => jokers.combo.short,
    .ember => jokers.ember.short,
    .finisher => jokers.finisher.short,
    .fullhouse => jokers.fullhouse.short,
    .hattrick => jokers.hattrick.short,
    .heavy => jokers.heavy.short,
    .lantern => jokers.lantern.short,
    .momentum => jokers.momentum.short,
    .patience => jokers.patience.short,
    .pockets => jokers.pockets.short,
    .precision => jokers.precision.short,
    .prism => jokers.prism.short,
    .quarry => jokers.quarry.short,
    .saver => jokers.saver.short,
    .sprinter => jokers.sprinter.short,
    .stonemason => jokers.stonemason.short,
    .sweep => jokers.sweep.short,
    .symmetry => jokers.symmetry.short,
    .tiny => jokers.tiny.short,
    .twin => jokers.twin.short,
  };
}

/// What a kind of joker does to a score, in a word or two.
String jokerKindName(BuildContext context, JokerKind kind) {
  final kinds = context.t.home.spellbook.kinds;

  return switch (kind) {
    .additiveMult => kinds.additiveMult,
    .boardEffect => kinds.boardEffect,
    .chips => kinds.chips,
    .drawWeight => kinds.drawWeight,
    .flatBonus => kinds.flatBonus,
    .multiplicativeMult => kinds.multiplicativeMult,
  };
}

String masteryTierName(BuildContext context, MasteryTier tier) {
  final tiers = context.t.home.spellbook.tiers;

  return switch (tier) {
    .none => tiers.none,
    .bronze => tiers.bronze,
    .silver => tiers.silver,
    .gold => tiers.gold,
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
    .ember => jokers.ember.description(
      factor: tuning.emberFactor,
      mult: tuning.emberMult,
    ),
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
    .prism => jokers.prism.description(chips: tuning.prismChipsPerPair),
    .quarry => jokers.quarry.description(stones: tuning.quarryStonesPerClear),
    .saver => jokers.saver.description(points: tuning.saverPointsPerPiece),
    .sprinter => jokers.sprinter.description(mult: tuning.sprinterMult),
    .stonemason => jokers.stonemason.description(
      chips: tuning.stonemasonChipsPerStone,
      stones: tuning.stonemasonExtraStones,
    ),
    .sweep => jokers.sweep.description(points: tuning.sweepBonus),
    .symmetry => jokers.symmetry.description(mult: tuning.symmetryMult),
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
