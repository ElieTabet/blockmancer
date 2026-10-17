import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/mark_jokers_announced_behavior.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

void main() {
  test('jokers announced on the map are not announced again, and stay '
      'unlocked', () async {
    // Given: two jokers unlocked by bringing a save up to date
    final store = FakeProgressionStore()
      ..saved = startingProgression(const TwoWorldRules()).copyWith(
        unannouncedJokers: const {.fullhouse, .brink},
        unlockedJokers: const {.patience, .twin, .fullhouse, .brink},
      );

    // When
    await MarkJokersAnnouncedBehavior(store: store)();

    // Then
    expect(store.saved.unannouncedJokers, isEmpty);
    expect(store.saved.unlockedJokers, {
      JokerId.patience,
      JokerId.twin,
      JokerId.fullhouse,
      JokerId.brink,
    });
  });
}
