import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/record_pick_behavior.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

void main() {
  late FakeProgressionStore store;
  late RecordPickBehavior record;

  setUp(() {
    store = FakeProgressionStore()
      ..saved = startingProgression(const TwoWorldRules());
    record = RecordPickBehavior(store: store);
  });

  test('a first pick counts once, from nothing', () async {
    // When
    await record(.twin);

    // Then
    expect(store.saved.jokerStats, {
      JokerId.twin: const JokerStats(
        bestRunTotal: 0,
        runsWon: 0,
        timesPicked: 1,
      ),
    });
  });

  test(
    "a pick adds to what the joker had, and leaves the others' alone",
    () async {
      // Given
      store.saved = store.saved.copyWith(
        jokerStats: const {
          .twin: JokerStats(bestRunTotal: 4000, runsWon: 1, timesPicked: 2),
          .patience: JokerStats(bestRunTotal: 900, runsWon: 0, timesPicked: 1),
        },
      );

      // When
      await record(.twin);

      // Then
      expect(store.saved.jokerStats, const {
        JokerId.twin: JokerStats(
          bestRunTotal: 4000,
          runsWon: 1,
          timesPicked: 3,
        ),
        JokerId.patience: JokerStats(
          bestRunTotal: 900,
          runsWon: 0,
          timesPicked: 1,
        ),
      });
    },
  );
}
