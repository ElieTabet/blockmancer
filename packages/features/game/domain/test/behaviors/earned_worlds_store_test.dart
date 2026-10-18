import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/earned_worlds_store.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

/// A player who beat Gravity's boss while Fog was still coming soon.
Progression _beatGravityBeforeFog() {
  final fresh = startingProgression(const TwoWorldRules());

  return fresh.copyWith(
    worlds: {
      ...fresh.worlds,
      .gravity: fresh.worlds[WorldId.gravity]!.copyWith(
        bossBeaten: true,
        unlocked: true,
      ),
    },
  );
}

void main() {
  test('Given Gravity beaten before Fog had rules, When a release that plays '
      'Fog reads the progression, Then Fog is open, and the next write keeps '
      'it', () async {
    // Given
    final store = FakeProgressionStore()..saved = _beatGravityBeforeFog();
    final earned = EarnedWorldsStore(
      rules: const TwoWorldRules(fogPlayable: true),
      store: store,
    );

    // When
    final read = await earned.load();
    await earned.save(read);

    // Then
    expect(read.worlds[WorldId.fog]?.unlocked, isTrue);
    expect(read.worlds[WorldId.fog]?.bossBeaten, isFalse);
    expect(store.saved.worlds[WorldId.fog]?.unlocked, isTrue);
  });

  test('Given Gravity beaten, When Fog is still coming soon, Then it stays '
      'locked', () async {
    // Given
    final store = FakeProgressionStore()..saved = _beatGravityBeforeFog();

    // When
    final read = await EarnedWorldsStore(
      rules: const TwoWorldRules(),
      store: store,
    ).load();

    // Then
    expect(read, store.saved);
    expect(read.worlds[WorldId.fog]?.unlocked, isFalse);
  });

  test('Given no boss beaten, When the progression is read, Then only the '
      'first world is open', () async {
    // Given
    final store = FakeProgressionStore()
      ..saved = startingProgression(const TwoWorldRules());

    // When
    final read = await EarnedWorldsStore(
      rules: const TwoWorldRules(fogPlayable: true),
      store: store,
    ).load();

    // Then
    expect(identical(read, store.saved), isTrue);
  });
}
