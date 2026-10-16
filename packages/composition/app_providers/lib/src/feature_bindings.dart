import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:push/push.dart' as push;
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications_domain;
import 'package:push_notifications_presentation/push_notifications_presentation.dart'
    as push_notifications_ui;
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
/// [router] is passed in because a tapped push is routed without a
/// `BuildContext`: the trigger is the OS handing over a tap, not a widget.
///
/// [collectsTelemetry] is the app's to say, like the rest of its configuration:
/// whether this build sends usage statistics and crash reports.
List<Override> featureBindingOverrides({
  required bool collectsTelemetry,
  required AppRouter router,
}) => [
  // Constructed with no arguments on purpose: the two messaging plugins stay
  // inside `push`.
  ...push.bindProviders(pushMessaging: (ref) => push.FirebasePushMessaging()),
  // The same arrangement for the analytics and crash plugins.
  ...telemetry.bindProviders(
    collectsTelemetry: (ref) => collectsTelemetry,
    telemetry: (ref) => telemetry.FirebaseTelemetry(),
  ),
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
];
