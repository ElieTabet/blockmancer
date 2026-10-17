// The composition wiring itself: appOverrides() must satisfy every DI slot the
// app reads at runtime. The app smoke test doesn't cover this — a missing bind
// would otherwise only surface on the first real request.
//
// The DI slots aren't exported from their packages' barrels (they're bound, not
// read, by consumers), so this reaches into src/ the way the feature tests do.

import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/src/providers_di.br.dart' as game_ui_di;
import 'package:push/push.dart';
import 'package:push/src/providers_di.br.dart' as push_di;
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications;
import 'package:push_notifications_presentation/src/providers_di.br.dart'
    as push_notifications_di;
import 'package:telemetry/telemetry.dart';

void main() {
  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: appOverrides(collectsTelemetry: false, router: AppRouter()),
    );
    addTearDown(container.dispose);

    return container;
  }

  test('the game reaches the engine and its storage only through slots', () {
    final container = buildContainer();

    expect(container.read(game.gameRulesProvider), isA<BlockmancerEngine>());
    expect(
      container.read(game.bestScoresProvider),
      isA<SharedPreferencesBestScores>(),
    );
  });

  test('a revive costs nothing until there is an ad network', () async {
    expect(
      await buildContainer().read(game_ui_di.rewardedActionProvider)(),
      isTrue,
    );
  });

  // Push crosses three packages and never lets any but `push` name Firebase:
  // push_notifications decides and the router opens what a tap is about.
  // These binds are the whole join.
  test('the push slots are bound across push, its feature and the rest', () {
    final container = buildContainer();

    expect(
      container.read(push_di.pushMessagingProvider),
      isA<FirebasePushMessaging>(),
    );
    // Read from one container, which is what proves the device ↔
    // push_notifications pair is not circular.
    expect(
      container.read(push_notifications.askForNotificationsProvider),
      isA<push_notifications.AskForNotificationsFun>(),
    );
    expect(
      container.read(push_notifications.pushDestinationsProvider),
      isA<push_notifications.PushDestinationsFun>(),
    );
    expect(
      container.read(push_notifications.reportPushTokenProvider),
      isA<push_notifications.ReportPushTokenFun>(),
    );
    expect(
      container.read(push_notifications_di.initializeMessagingProvider),
      isA<push_notifications_di.InitializeMessagingFun>(),
    );
    expect(
      container.read(push_notifications_di.reportNonFatalProvider),
      isA<push_notifications_di.ReportNonFatalFun>(),
    );
    expect(
      container.read(push_notifications_di.pushNotificationsRoutingProvider),
      isA<PushNotificationsRoutingImpl>(),
    );
  });

  // Only `telemetry` names the analytics and crash plugins, and the app alone
  // says whether this build collects.
  test('the telemetry slots are bound', () {
    final container = buildContainer();

    expect(container.read(telemetryProvider), isA<FirebaseTelemetry>());
    expect(container.read(collectsTelemetryProvider), false);
  });
}
