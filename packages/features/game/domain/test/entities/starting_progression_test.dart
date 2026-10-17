import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fakes.dart';

const _noStars = WorldStars(
  bossBeaten: false,
  noRevive: false,
  scoreThreshold: false,
);

void main() {
  test('Given the rules, When a player starts, Then only the map\'s first '
      'world is open, nothing is earned and the starting jokers are '
      'theirs', () {
    // Given
    const rules = MapRules(
      startingJokers: [.twin, .patience, .combo],
      worldOrder: [.rubble, .gravity, .fog],
    );

    // When
    final progression = startingProgression(rules);

    // Then
    expect(
      progression,
      const Progression(
        tutorialDone: false,
        unlockedJokers: {.combo, .patience, .twin},
        worlds: {
          .rubble: WorldProgress(
            bossBeaten: false,
            stars: _noStars,
            unlocked: true,
          ),
          .gravity: WorldProgress(
            bossBeaten: false,
            stars: _noStars,
            unlocked: false,
          ),
          .fog: WorldProgress(
            bossBeaten: false,
            stars: _noStars,
            unlocked: false,
          ),
        },
      ),
    );
  });
}
