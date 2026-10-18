import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/notifiers/drag_notifier.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';

/// The drag shadow of the first tray piece hovering at [anchor], in a run in
/// [world], [boss] round or not.
Future<List<Cell>> _heldAt(
  Cell anchor, {
  required bool boss,
  required WorldId world,
}) async {
  final rules = FakeGameRules(
    start: runIn(
      const .playing(),
      roundIndex: boss ? 1 : 0,
    ).copyWith(config: testConfig.copyWith(world: world)),
  );
  final container = ProviderContainer(overrides: gameOverrides(rules));
  addTearDown(container.dispose);
  container
    ..listen(gameProvider, (_, _) {})
    ..listen(dragProvider, (_, _) {});
  container.read(dragProvider.notifier)
    ..begin(0)
    ..hover(anchor);

  return container.read(dragProvider)!.held;
}

void main() {
  test(
    "in Mirror's boss, the shadow knows the cells under the finger",
    () async {
      expect(
        await _heldAt(const Cell(col: 2, row: 3), boss: true, world: .mirror),
        const [Cell(col: 2, row: 3)],
      );
    },
  );

  test(
    'anywhere else, the piece lands where it is held: nothing to outline',
    () async {
      expect(
        await _heldAt(const Cell(col: 2, row: 3), boss: false, world: .mirror),
        isEmpty,
      );
      expect(
        await _heldAt(const Cell(col: 2, row: 3), boss: true, world: .gravity),
        isEmpty,
      );
    },
  );
}
