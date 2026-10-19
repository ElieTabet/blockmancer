import 'dart:async';

import 'package:app_router/app_router.dart';
import 'package:auto_route/auto_route.dart' show PageRouteInfo;
import 'package:app_update_presentation/app_update_presentation.dart'
    show UpdateRequiredRoute;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' show gameRulesProvider;
import 'package:game_presentation/game_presentation.dart' show GameRoute;
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/game_widget.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:splash_presentation/splash_presentation.dart' show SplashRoute;

import 'pump_app_router.dart';
import 'stub_features.dart';

/// What Remote Config publishes, changed as the console would.
final class _Published extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  void publish(String key, String value) => state = {...state, key: value};
}

final _publishedProvider = NotifierProvider<_Published, Map<String, String>>(
  _Published.new,
);

// The real router, the real screens and the real update check: what is under
// test is where a version published as too old lands the player, and when.
void main() {
  Map<String, String> atLaunch = const {};

  setUp(() => atLaunch = const {});

  Future<AppRouter> pumpApp(
    WidgetTester tester, {
    List<PageRouteInfo<dynamic>> deepLink = const [TabShellRoute()],
    MemoryRunStore? runStore,
  }) => pumpAppRouter(
    tester,
    deepLink: deepLink,
    remoteValue: (ref) {
      final published = ref.watch(_publishedProvider);

      return (key) => published[key] ?? atLaunch[key];
    },
    runStore: runStore,
  );

  void publish(WidgetTester tester, String key, String value) =>
      ProviderScope.containerOf(
        tester.element(find.byType(Router<Object>)),
      ).read(_publishedProvider.notifier).publish(key, value);

  testWidgets('on the map, a newer version brings the banner, and a raised '
      'minimum the update screen in place of everything', (tester) async {
    // Given
    final router = await pumpApp(tester);
    expect(find.text('A new version is out'), findsNothing);

    // When
    publish(tester, 'latest_version_ios', '1.1.0');
    await tester.pumpAndSettle();

    // Then
    expect(find.text('A new version is out'), findsOneWidget);

    publish(tester, 'min_version_ios', '1.0.1');
    await tester.pumpAndSettle();
    expect(rootStackNames(router), [UpdateRequiredRoute.name]);
  });

  testWidgets('a minimum raised while the app is in the background shows '
      'the update screen right on return', (tester) async {
    // Given
    final router = await pumpApp(tester);
    // What the fetch on return brings, as it lands.
    final fetchedOnReturn = AppLifecycleListener(
      onResume: () => publish(tester, 'min_version_ios', '1.0.1'),
    );
    addTearDown(fetchedOnReturn.dispose);
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();

    // When
    for (final state in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pumpAndSettle();

    // Then
    expect(rootStackNames(router), [UpdateRequiredRoute.name]);
  });

  testWidgets('mid-run, the update screen waits for the move to play out and '
      'its save to land', (tester) async {
    // Given: today's run, its starting joker picked
    final store = MemoryRunStore();
    final router = await pumpApp(tester, runStore: store);
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
    store.gate = Completer<void>();

    // When: a piece is placed, and the minimum raised as it lands
    playing.read(gameProvider.notifier).place(anchor: anchor, trayIndex: 0);
    publish(tester, 'min_version_ios', '1.0.1');
    await tester.pump(const Duration(milliseconds: 100));

    // Then: the run stays while the move plays and while its save is open
    expect(rootStackNames(router), [TabShellRoute.name, GameRoute.name]);

    await tester.pump(const Duration(seconds: 3));
    expect(rootStackNames(router), [TabShellRoute.name, GameRoute.name]);
    expect(store.saved?.run.tray.first, isNotNull, reason: 'the pick’s save');

    store.gate!.complete();
    await tester.pumpAndSettle();
    expect(store.saved?.run.tray.first, isNull);
    expect(rootStackNames(router), [UpdateRequiredRoute.name]);
  });

  testWidgets('a minimum known at launch is the splash’s to show, once', (
    tester,
  ) async {
    // Given
    atLaunch = const {'min_version_ios': '1.0.1'};

    // When
    final router = await pumpApp(tester, deepLink: [const SplashRoute()]);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Then
    expect(rootStackNames(router), [UpdateRequiredRoute.name]);
    expect(find.text('Update required'), findsOneWidget);
  });
}
