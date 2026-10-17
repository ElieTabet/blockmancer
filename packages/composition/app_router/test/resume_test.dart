import 'package:app_router/app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' show gameRulesProvider;
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:shared_domain/shared_domain.dart';

import 'pump_app_router.dart';
import 'stub_features.dart';

// The whole loop through the real screens and the real engine: what is under
// test is that a run left behind comes back as it stood, across a relaunch.
void main() {
  testWidgets('a run left mid-round is continued after the app is killed', (
    tester,
  ) async {
    // Given: today's run, its starting joker picked and a first piece placed
    final store = MemoryRunStore();
    await pumpAppRouter(
      tester,
      deepLink: [const TabShellRoute()],
      runStore: store,
    );
    await tester.tap(find.text(homeDailyTitle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take').first);
    await tester.pumpAndSettle();
    final playing = ProviderScope.containerOf(
      tester.element(find.byType(GameWidget)),
    );
    final rules = playing.read(gameRulesProvider);
    final anchor =
        [
          for (var row = 0; row < Board.size; row++)
            for (var col = 0; col < Board.size; col++) Cell(col: col, row: row),
        ].firstWhere(
          (cell) => rules.canPlace(
            playing.read(gameProvider).run,
            anchor: cell,
            trayIndex: 0,
          ),
        );
    playing.read(gameProvider.notifier).place(anchor: anchor, trayIndex: 0);
    await tester.pumpAndSettle();
    final onScreen = playing.read(gameProvider);
    expect(onScreen.run.tray.first, isNull);

    // When: the app is killed and launched again
    await tester.pumpWidget(const SizedBox());
    final router = await pumpAppRouter(
      tester,
      deepLink: [const TabShellRoute()],
      runStore: store,
    );
    await tester.tap(find.text('Continue run'));
    await tester.pumpAndSettle();

    // Then: the same board, tray and score
    expect(rootStackNames(router), [TabShellRoute.name, GameRoute.name]);
    final game = ProviderScope.containerOf(
      tester.element(find.byType(GameWidget)),
    ).read(gameProvider);
    expect(game.run, onScreen.run);
    expect(game.mode, onScreen.mode);
  });
}
