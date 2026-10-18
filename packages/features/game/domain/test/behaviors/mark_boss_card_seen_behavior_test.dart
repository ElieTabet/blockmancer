import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/mark_boss_card_seen_behavior.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

void main() {
  test('a boss card shown is remembered with those shown before', () async {
    // Given: Gravity's card already shown
    final store = FakeProgressionStore()
      ..saved = startingProgression(
        const TwoWorldRules(),
      ).copyWith(bossCardsSeen: const {.gravity});

    // When
    await MarkBossCardSeenBehavior(store: store)(.fog);

    // Then
    expect(store.saved.bossCardsSeen, {WorldId.gravity, WorldId.fog});
  });

  test('a new player has seen no boss card', () {
    expect(startingProgression(const TwoWorldRules()).bossCardsSeen, isEmpty);
  });
}
