import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/src/behaviors/mark_spellbook_seen_behavior.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

/// The progression in memory, counting its writes.
final class _CountingStore implements ProgressionStore {
  _CountingStore(this.saved);

  Progression saved;
  var saves = 0;

  @override
  Future<Progression> load() async => saved;

  @override
  Future<void> save(Progression progression) async {
    saves++;
    saved = progression;
  }
}

void main() {
  test('Given jokers unlocked since the Spellbook was last opened, When it '
      'is marked seen, Then every unlocked joker counts as seen', () async {
    // Given
    final starting = startingProgression(const TwoWorldRules());
    final store = FakeProgressionStore()
      ..saved = starting.copyWith(
        unlockedJokers: {...starting.unlockedJokers, .stonemason, .quarry},
      );

    // When
    await MarkSpellbookSeenBehavior(store: store)();

    // Then
    expect(store.saved.spellbookSeen, store.saved.unlockedJokers);
  });

  test('Given nothing new, When the Spellbook is marked seen, Then nothing is '
      'written', () async {
    // Given
    final store = _CountingStore(startingProgression(const TwoWorldRules()));

    // When
    await MarkSpellbookSeenBehavior(store: store)();

    // Then
    expect(store.saves, 0);
  });
}
