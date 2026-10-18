import 'package:shared_domain/shared_domain.dart';

/// Where a new player starts: the map's first world open, nothing earned yet,
/// and the rules' starting jokers, which the Spellbook doesn't mark NEW: they
/// were never unlocked, only had.
Progression startingProgression(GameRules rules) => Progression(
  jokerStats: const {},
  spellbookSeen: rules.startingJokers.toSet(),
  tutorialDone: false,
  unannouncedJokers: const {},
  unlockedJokers: rules.startingJokers.toSet(),
  worlds: {
    for (final world in rules.worldOrder)
      world: WorldProgress(
        bossBeaten: false,
        stars: const WorldStars(
          bossBeaten: false,
          noRevive: false,
          scoreThreshold: false,
        ),
        unlocked: world == rules.worldOrder.first,
      ),
  },
);
