// The composition wiring itself: appOverrides() must satisfy every DI slot the
// app reads at runtime. The app smoke test doesn't cover this — a missing bind
// would otherwise only surface on the first real request.
//
// The DI slots aren't exported from their packages' barrels (they're bound, not
// read, by consumers), so this reaches into src/ the way the feature tests do.

import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/providers_di.br.dart' as game_di;
import 'package:keychain/keychain.dart';
import 'package:network/network.dart';
import 'package:network/src/providers_di.br.dart' as network_di;
import 'package:screen_header/screen_header.dart' show ScreenHeaderRouting;
import 'package:screen_header/src/providers_di.br.dart' as header_di;
import 'package:push/push.dart';
import 'package:push/src/providers_di.br.dart' as push_di;
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications;
import 'package:push_notifications_presentation/src/providers_di.br.dart'
    as push_notifications_di;
import 'package:telemetry/telemetry.dart';

void main() {
  const stubAndroidPackage = 'com.elietabet.blockmancer';
  const stubAppVersion = '1.0.0';
  const stubBaseUrl = 'https://stub.test/v1';

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: appOverrides(
        androidPackageName: stubAndroidPackage,
        apiBaseUrl: stubBaseUrl,
        appVersion: stubAppVersion,
        collectsTelemetry: false,
        router: AppRouter(),
      ),
    );
    addTearDown(container.dispose);

    return container;
  }

  test('the network slots are bound, so both clients resolve', () {
    final container = buildContainer();

    expect(container.read(httpClientProvider), isA<DioHttpClient>());
    expect(container.read(publicHttpClientProvider), isA<DioHttpClient>());
  });

  // The app owns its configuration and hands the base URL down; composition
  // never learns how it is shaped.
  test('the base URL is the one the app passed in', () {
    expect(buildContainer().read(network_di.apiBaseUrlProvider), stubBaseUrl);
  });

  test('secure storage backs the keychain slot', () {
    expect(
      buildContainer().read(keychainRepositoryProvider),
      isA<SecureKeychainRepository>(),
    );
  });

  test('the game reaches the engine only through its rules slot', () {
    expect(
      buildContainer().read(game_di.gameRulesProvider),
      isA<BlockmancerEngine>(),
    );
  });

  // Push crosses four packages and never lets any but `push` name Firebase:
  // push_notifications decides, `device` reports the token, and the router
  // opens what a tap is about. These binds are the whole join.
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

  // Whatever waits for the phone to come back online may not name the plugin
  // that says so.
  test('the connectivity slot is bound to the plugin', () {
    expect(
      buildContainer().read(connectivityMonitorProvider),
      isA<PlusConnectivityMonitor>(),
    );
  });

  // The header's own session slots. It never names `auth`, so these binds are
  // the only thing that makes the sign-in/sign-out control work at all — on
  // every screen that wears the band.
  test('the header session contracts are bound to auth', () {
    final container = buildContainer();

    expect(
      container.read(header_di.isAuthenticatedProvider),
      isA<AsyncValue<bool>>(),
    );
    expect(
      container.read(header_di.logoutProvider),
      isA<header_di.LogoutFun>(),
    );
    expect(
      container.read(header_di.screenHeaderRoutingProvider),
      isA<ScreenHeaderRouting>(),
    );
  });
}
