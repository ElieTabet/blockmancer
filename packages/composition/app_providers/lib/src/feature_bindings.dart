import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:connectivity/connectivity.dart' as connectivity;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:keychain/keychain.dart' as keychain;
import 'package:network/network.dart' as network;
import 'package:push/push.dart' as push;
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications_domain;
import 'package:push_notifications_presentation/push_notifications_presentation.dart'
    as push_notifications_ui;
import 'package:result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_header/screen_header.dart' as screen_header;
import 'package:splash_presentation/splash_presentation.dart' as splash_ui;
import 'package:telemetry/telemetry.dart' as telemetry;

/// Binds every non-routing slot to its concrete implementation — the feature
/// contracts and the infrastructure alike.
///
/// Packages never import each other or the capability packages behind them:
/// each exposes a slot, and what fills it is injected here.
///
/// Wiring only. Each package decides what to do with what it is given, inside
/// its own package — nothing is composed or interpreted at this layer.
///
/// [apiBaseUrl] is passed in rather than read from a configuration package: the
/// app owns its configuration, and composition stays agnostic of how it is
/// shaped — the same property `network` itself has.
///
/// [router] is passed in for the same reason, and because a dead session has to be
/// routed away from without a `BuildContext` — the trigger is a 401 in the
/// network layer, not a widget.
///
/// [appVersion] is resolved by the app at boot: `package_info_plus` is a plugin, and keeping it in the app means nothing
/// below has to take one.
///
/// [httpProxy] is null in every build that isn't being inspected through an
/// HTTP debugging proxy, and comes from the app for the same reason
/// [apiBaseUrl] does — it is configuration, which composition passes along
/// rather than reads.
///
/// [androidPackageName] and [iosAppStoreId] say where this build's store
/// listing is, for the update screens. The id is null until Apple assigns one.
///
/// [collectsTelemetry] is the app's to say, like the rest of its configuration:
/// whether this build sends usage statistics and crash reports.
List<Override> featureBindingOverrides({
  required String androidPackageName,
  required String apiBaseUrl,
  required String appVersion,
  required bool collectsTelemetry,
  required AppRouter router,
  String? httpProxy,
  String? iosAppStoreId,
}) => [
  ...keychain.bindProviders(
    keychainRepository: (ref) =>
        const keychain.SecureKeychainRepository(FlutterSecureStorage()),
  ),
  // Constructed with no arguments on purpose: the two messaging plugins stay
  // inside `push`, the way `dio` stays inside `network`.
  ...push.bindProviders(pushMessaging: (ref) => push.FirebasePushMessaging()),
  // The same arrangement for the analytics and crash plugins.
  ...telemetry.bindProviders(
    collectsTelemetry: (ref) => collectsTelemetry,
    telemetry: (ref) => telemetry.FirebaseTelemetry(),
  ),
  ...connectivity.bindProviders(
    connectivityMonitor: (ref) => connectivity.PlusConnectivityMonitor(),
  ),
  ...network.bindProviders(
    apiBaseUrl: (ref) => apiBaseUrl,
    // No sign-in: there is never a token to attach.
    networkAuthToken: (ref) => const network.NoAuthTokenProvider(),
    httpProxy: (ref) => httpProxy,
  ),
  // push_notifications and device are a second mutual pair: device starts the
  // token sync once registration allows a report, and the sync hands each
  // token back to device to report.
  ...push_notifications_domain.bindProviders(
    launchMessage: (ref) => ref.watch(push.pushMessagingProvider).launchMessage,
    // The instance is captured, not the ref: these are called after an
    // await, by when an auto-disposed slot's ref may be gone.
    openedMessages: (ref) {
      final messaging = ref.watch(push.pushMessagingProvider);

      return () => messaging.openedMessages;
    },
    pushTokenChanges: (ref) {
      final messaging = ref.watch(push.pushMessagingProvider);

      return () => messaging.tokenChanges;
    },
    readPushToken: (ref) => ref.watch(push.pushMessagingProvider).currentToken,
    // No backend to tell: the token is FCM's to use, and nobody else's.
    reportPushToken: (ref) => (token) async {},
    requestPushPermission: (ref) =>
        ref.watch(push.pushMessagingProvider).requestPermission,
  ),
  ...push_notifications_ui.bindProviders(
    initializeMessaging: (ref) =>
        ref.watch(push.pushMessagingProvider).initialize,
    reportNonFatal: (ref) => ref.watch(telemetry.recordNonFatalProvider),
  ),
  // Bound here rather than with the other routing, like the app status's: a
  // tap arrives from the OS, so it navigates through the router instance.
  ...push_notifications_ui.bindRoutingProviders(
    pushNotificationsRouting: (ref) => PushNotificationsRoutingImpl(router),
  ),
  // The game screen reaches the rules only through this slot.
  ...game_ui.bindProviders(gameRules: (ref) => const BlockmancerEngine()),
  // The one session control every main screen wears. Bound once here rather
  // than per screen.
  // No backend: no one signs in, and the organization has no settings to
  // send. The header shows the screen's title alone.
  ...screen_header.bindProviders(
    isAuthenticated: (ref) async => false,
    logout: (ref) =>
        () async => const Success(unit),
    organizationName: (ref) => null,
  ),
  // Nothing to check, register or fetch at launch: the splash holds its
  // minimum and hands over.
  ...splash_ui.bindProviders(
    checkAppStatus: (ref) =>
        () async => true,
    isAuthenticated: (ref) async => false,
    prepareDevice: (ref) => () async {},
    refreshSettings: (ref) => () async {},
  ),
];
