import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import 'fake_home_routing.dart';

/// The jokers' numbers. Stonemason's and Quarry's are uncommon, so a test
/// can tell a description filled from them.
const tuning = JokerTuning(
  anchorMult: 4,
  avalancheChipsPerCell: 25,
  bigBoxFactor: 3,
  bigBoxMinPieceSize: 5,
  brinkFactor: 2,
  brinkMinOccupied: 40,
  collectorMultPerJoker: 1,
  columnFactor: 2,
  comboMultPerStreak: 1,
  finisherFactor: 2,
  fullHouseCellsPerMult: 6,
  hatTrickBonus: 300,
  heavyFactor: 2,
  heavyMinPieceSize: 4,
  patienceStoredPerMove: 2,
  pocketsExtraPieces: 4,
  precisionBonusMult: 6,
  precisionMaxPieceSize: 2,
  quarryStonesPerClear: 3,
  saverPointsPerPiece: 40,
  stonemasonChipsPerStone: 75,
  stonemasonExtraStones: 4,
  sweepBonus: 500,
  tinyFactor: 3,
  tinyMaxPieceSize: 2,
  twinFactor: 3,
  twinMinLines: 2,
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
    id: .speed,
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
Future<FakeHomeRouting> pumpHome(
  WidgetTester tester, {
  int? dailyBest,
  bool hasSavedRun = false,
  int? practiceBest,
  Future<Progression> Function()? progression,
  bool reduceMotion = true,
}) async {
  tester.view.physicalSize = const Size(1170, 3900);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  final routing = FakeHomeRouting();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...bindProviders(
          dailyBest: (ref) async => dailyBest,
          dailyDate: (ref) => DateTime.utc(2026, 10, 17),
          hasSavedRun: (ref) async => hasSavedRun,
          practiceBest: (ref) async => practiceBest,
          progression: (ref) => progression?.call() ?? _fresh(),
          reduceMotionSetting: (ref) => reduceMotion,
          worlds: (ref) => mapWorlds,
        ),
        ...bindRoutingProviders(homeRouting: (ref) => routing),
      ],
      child: TranslationProvider(
        child: MaterialApp(
          theme: DSTheme.instance.darkTheme,
          home: const HomeWidget(),
        ),
      ),
    ),
  );
  await tester.pump();

  return routing;
}

Future<Progression> _fresh() async => freshProgression();
