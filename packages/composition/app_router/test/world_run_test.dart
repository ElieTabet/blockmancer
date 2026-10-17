import 'package:app_router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart'
    show GameMode, initialProgressionProvider;
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:shared_domain/shared_domain.dart';

import 'pump_app_router.dart';

// The real route and the real engine: what is under test is that a world
// named in the route is the world played, with the player's jokers only.
void main() {
  testWidgets(
    "a world opened from its route plays that world, offering the player's "
    'jokers',
    (tester) async {
      // Given / When
      final router = await pumpAppRouter(
        tester,
        deepLink: [
          const TabShellRoute(),
          GameRoute(launch: .world, world: .gravity),
        ],
      );

      // Then
      expect(rootStackNames(router), [TabShellRoute.name, GameRoute.name]);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameWidget)),
      );
      final game = container.read(gameProvider);
      expect(game.mode, const GameMode.world(world: .gravity));
      expect(game.run.config.world, WorldId.gravity);
      expect(
        game.run.config.jokerPool.toSet(),
        container.read(initialProgressionProvider).unlockedJokers,
      );
    },
  );
}
