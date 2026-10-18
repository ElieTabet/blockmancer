import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart';
import 'package:home_presentation/src/providers_di.br.dart'
    show MarkJokersAnnouncedFun, MarkSpellbookSeenFun, ShowDailyLeaderboardFun;
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import 'fake_home_routing.dart';

/// The jokers' numbers. Stonemason's and Quarry's are uncommon, so a test
/// can tell a description filled from them.
const tuning = JokerTuning(
  anchorMult: 4,
  avalancheChipsPerCell: 25,
  avalancheRows: 2,
  bigBoxFactor: 3,
  bigBoxMinPieceSize: 5,
  brinkFactor: 2,
  brinkMinOccupied: 40,
  collectorMultPerJoker: 1,
  columnFactor: 2,
  comboMultPerStreak: 1,
  emberFactor: 2,
  emberMult: 3,
  finisherFactor: 2,
  fullHouseCellsPerMult: 6,
  fullHouseMultPerBlock: 1,
  hatTrickBonus: 300,
  heavyFactor: 2,
  heavyMinPieceSize: 4,
  momentumMultPerTray: 2,
  patienceStoredPerMove: 2,
  pocketsExtraPieces: 4,
  precisionBonusMult: 6,
  precisionMaxPieceSize: 2,
  prismChipsPerPair: 15,
  quarryStonesPerClear: 3,
  saverPointsPerPiece: 40,
  sprinterMult: 5,
  stonemasonChipsPerStone: 75,
  stonemasonExtraStones: 4,
  sweepBonus: 500,
  symmetryMult: 4,
  tinyFactor: 3,
  tinyMaxPieceSize: 2,
  twinFactor: 3,
  twinMinLines: 2,
);

/// The game's 20 jokers in their 10 pairs, as the rules order them.
const collection = JokerCollection(
  kinds: {
    .anchor: .additiveMult,
    .avalanche: .chips,
    .bigbox: .drawWeight,
    .brink: .multiplicativeMult,
    .collector: .additiveMult,
    .column: .multiplicativeMult,
    .combo: .additiveMult,
    .ember: .additiveMult,
    .finisher: .multiplicativeMult,
    .fullhouse: .additiveMult,
    .hattrick: .flatBonus,
    .heavy: .multiplicativeMult,
    .lantern: .boardEffect,
    .momentum: .additiveMult,
    .patience: .additiveMult,
    .pockets: .boardEffect,
    .precision: .additiveMult,
    .prism: .chips,
    .quarry: .boardEffect,
    .saver: .flatBonus,
    .sprinter: .additiveMult,
    .stonemason: .chips,
    .sweep: .flatBonus,
    .symmetry: .additiveMult,
    .tiny: .drawWeight,
    .twin: .multiplicativeMult,
  },
  mastery: MasteryThresholds(bronze: 1, gold: 15, silver: 5),
  pairs: [
    JokerPair(first: .combo, second: .collector, unlock: .starting()),
    JokerPair(first: .patience, second: .twin, unlock: .starting()),
    JokerPair(first: .precision, second: .tiny, unlock: .starting()),
    JokerPair(first: .column, second: .sweep, unlock: .starting()),
    JokerPair(first: .heavy, second: .bigbox, unlock: .starting()),
    JokerPair(first: .pockets, second: .saver, unlock: .starting()),
    JokerPair(
      first: .stonemason,
      second: .quarry,
      unlock: .boss(world: .rubble),
    ),
    JokerPair(
      first: .anchor,
      second: .avalanche,
      unlock: .boss(world: .gravity),
    ),
    JokerPair(first: .fullhouse, second: .brink, unlock: .stars(count: 4)),
    JokerPair(first: .finisher, second: .hattrick, unlock: .stars(count: 6)),
  ],
  traySize: 3,
  tuning: tuning,
);

/// The game's map: Rubble and Gravity playable, then three coming soon.
const mapWorlds = [
  WorldSummary(
    bossTarget: 1500,
    id: .rubble,
    jokerTuning: tuning,
    playable: true,
    starThreshold: 8000,
    unlocks: [.stonemason, .quarry],
  ),
  WorldSummary(
    bossTarget: 2000,
    id: .gravity,
    jokerTuning: tuning,
    playable: true,
    starThreshold: 9000,
    unlocks: [.anchor, .avalanche],
  ),
  WorldSummary(
    bossTarget: 0,
    id: .fog,
    jokerTuning: tuning,
    playable: false,
    starThreshold: 0,
    unlocks: [],
  ),
  WorldSummary(
    bossTarget: 0,
    id: .tide,
    jokerTuning: tuning,
    playable: false,
    starThreshold: 0,
    unlocks: [],
  ),
  WorldSummary(
    bossTarget: 0,
    id: .mirror,
    jokerTuning: tuning,
    playable: false,
    starThreshold: 0,
    unlocks: [],
  ),
];

const noStars = WorldStars(
  bossBeaten: false,
  noRevive: false,
  scoreThreshold: false,
);

/// A new player's: Rubble open, nothing earned.
Progression freshProgression({WorldStars rubbleStars = noStars}) => Progression(
  jokerStats: const {},
  tutorialDone: true,
  unannouncedJokers: const {},
  unlockedJokers: const {},
  worlds: {
    for (final world in mapWorlds)
      world.id: WorldProgress(
        bossBeaten: false,
        stars: world.id == .rubble ? rubbleStars : noStars,
        unlocked: world.id == .rubble,
      ),
  },
);

/// Rubble's boss beaten without a revive, which opened Gravity and its two
/// jokers.
final rubbleBeaten = freshProgression().copyWith(
  unlockedJokers: const {.quarry, .stonemason},
  worlds: {
    ...freshProgression().worlds,
    .rubble: const WorldProgress(
      bossBeaten: true,
      stars: WorldStars(
        bossBeaten: true,
        noRevive: true,
        scoreThreshold: false,
      ),
      unlocked: true,
    ),
    .gravity: const WorldProgress(
      bossBeaten: false,
      stars: noStars,
      unlocked: true,
    ),
  },
);

/// Mounts Home on a screen tall enough for the whole map, on today's daily
/// of 17 October 2026, its marker still unless [reduceMotion] is off.
/// Announcing jokers, and the Spellbook marking its jokers seen, do nothing
/// unless [markJokersAnnounced] or [markSpellbookSeen] says otherwise.
/// [screen] is Home unless another of its screens is given, on a [viewSize]
/// view, with the game's [collection] of jokers unless [jokerCollection] says
/// otherwise. The daily leaderboard shows nothing unless
/// [showDailyLeaderboard] says otherwise.
/// A newer version on offer, recording the store opened and the banner
/// closed.
final class UpdateOffer {
  UpdateOffer(this.latest);

  final calls = <String>[];
  String? latest;

  Future<void> dismiss() async {
    calls.add('dismiss');
    latest = null;
  }

  Future<bool> openStore() async {
    calls.add('store');

    return true;
  }
}

Future<FakeHomeRouting> pumpHome(
  WidgetTester tester, {
  int? dailyBest,
  int dailyStreak = 0,
  bool hasSavedRun = false,
  JokerCollection jokerCollection = collection,
  MarkJokersAnnouncedFun? markJokersAnnounced,
  MarkSpellbookSeenFun? markSpellbookSeen,
  int? practiceBest,
  Future<Progression> Function()? progression,
  bool reduceMotion = true,
  Widget screen = const HomeWidget(),
  ShowDailyLeaderboardFun? showDailyLeaderboard,
  UpdateOffer? updateOffer,
  Size viewSize = const Size(390, 1300),
}) async {
  tester.view.physicalSize = viewSize * 3;
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  final routing = FakeHomeRouting();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...bindProviders(
          dailyBest: (ref) async => dailyBest,
          dailyDate: (ref) => DateTime.utc(2026, 10, 17),
          dailyStreak: (ref) async => dailyStreak,
          dismissUpdateOffer: (ref) => updateOffer?.dismiss ?? () async {},
          hasSavedRun: (ref) async => hasSavedRun,
          jokerCollection: (ref) => jokerCollection,
          markJokersAnnounced: (ref) => markJokersAnnounced ?? () async {},
          markSpellbookSeen: (ref) => markSpellbookSeen ?? () async {},
          openStoreListing: (ref) => updateOffer?.openStore ?? () async => true,
          practiceBest: (ref) async => practiceBest,
          progression: (ref) => progression?.call() ?? _fresh(),
          reduceMotionSetting: (ref) => reduceMotion,
          showDailyLeaderboard: (ref) => showDailyLeaderboard ?? () async {},
          updateOffer: (ref) async => updateOffer?.latest,
          worlds: (ref) => mapWorlds,
        ),
        ...bindRoutingProviders(homeRouting: (ref) => routing),
      ],
      child: TranslationProvider(
        child: MaterialApp(theme: DSTheme.instance.darkTheme, home: screen),
      ),
    ),
  );
  await tester.pump();

  return routing;
}

Future<Progression> _fresh() async => freshProgression();
