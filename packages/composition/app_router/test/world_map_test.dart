import 'package:app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart'
    show GameMode, gameRulesProvider, recordProgressionProvider;
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:home_presentation/src/widgets/world_node.dart';
import 'package:shared_domain/shared_domain.dart';

import 'pump_app_router.dart';
import 'stub_features.dart';

Finder _in(WorldId world, Finder matching) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) => widget is WorldNode && widget.world == world,
  ),
  matching: matching,
);

// The real route tree, the real engine and the game's own progression: what
// is under test is that a world opened from the map plays that world, and
// that what its run earned is on the map the moment the run is left.
void main() {
  testWidgets("Given a new player's map, "
      "When Rubble's run is started from its sheet and its boss beaten, and "
      'the run is left, '
      'Then Home shows Rubble done with its stars and Gravity where the '
      'player is', (tester) async {
    // Given
    final router = await pumpAppRouter(
      tester,
      deepLink: [const TabShellRoute()],
    );
    expect(_in(.rubble, find.byIcon(Icons.location_on_rounded)), findsOne);

    // When: Rubble's sheet opened from the map, and its run started
    await tester.tap(find.text('Rubble'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start run'));
    await tester.pumpAndSettle();

    // Then
    expect(rootStackNames(router), [TabShellRoute.name, GameRoute.name]);
    final playing = ProviderScope.containerOf(
      tester.element(find.byType(GameWidget)),
    );
    expect(
      playing.read(gameProvider).mode,
      const GameMode.world(world: .rubble),
    );

    // When: its boss beaten without a revive, as the run's end records it,
    // and the run left
    final rules = playing.read(gameRulesProvider);
    await playing.read(recordProgressionProvider)(
      const .world(world: .rubble),
      rules
          .startRun(
            config: rules.configFor(.rubble, jokerPool: const []),
            seed: 1,
          )
          .copyWith(phase: const .won()),
    );
    await tester.tap(find.bySemanticsLabel(gameLeaveLabel));
    await tester.pumpAndSettle();

    // Then
    expect(rootStackNames(router), [TabShellRoute.name]);
    expect(_in(.rubble, find.byIcon(Icons.check_rounded)), findsOne);
    expect(_in(.rubble, find.byIcon(Icons.star_rounded)), findsNWidgets(2));
    expect(_in(.rubble, find.byIcon(Icons.location_on_rounded)), findsNothing);
    expect(_in(.gravity, find.byIcon(Icons.lock_rounded)), findsNothing);
    expect(_in(.gravity, find.byIcon(Icons.location_on_rounded)), findsOne);
  });
}
