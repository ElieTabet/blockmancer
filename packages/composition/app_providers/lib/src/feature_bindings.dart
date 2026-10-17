import 'package:ads/ads.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:home_presentation/home_presentation.dart' as home_ui;
import 'package:push/push.dart' as push;
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications_domain;
import 'package:push_notifications_presentation/push_notifications_presentation.dart'
    as push_notifications_ui;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_data/settings_data.dart';
import 'package:settings_domain/settings_domain.dart' as settings;
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
  // The game reaches the rules, its storage and the ad network only through
  // these slots.
  ...game.bindProviders(
    bestScores: (ref) => const SharedPreferencesBestScores(),
    clock: (ref) => const SystemClock(),
    gameRules: (ref) => const BlockmancerEngine(),
    runStore: (ref) => const SharedPreferencesRunStore(),
  ),
  ...game_ui.bindProviders(
    hapticsOnSetting: (ref) => ref.watch(settings.hapticsOnProvider),
    playSound: (ref) {
      final sounds = ref.watch(gameSoundsProvider);

      return (sound, {semitones = 0, variance = 0}) => sounds.play(
        switch (sound) {
          .bossStart => .bossStart,
          .bossWin => .bossWin,
          .clear => .clear,
          .joker => .joker,
          .kaching => .kaching,
          .place => .place,
          .roundLost => .roundLost,
          .roundWon => .roundWon,
          .tick => .tick,
        },
        semitones: semitones,
        variance: variance,
      );
    },
    reduceMotionSetting: (ref) => ref.watch(settings.reduceMotionOnProvider),
    rewardedAction: (ref) => const RewardedAds().show,
    soundOnSetting: (ref) => ref.watch(settings.soundOnProvider),
  ),
  // Home shows the game's bests and saved run without knowing the game.
  ...home_ui.bindProviders(
    dailyBest: (ref) => ref.watch(game.todaysDailyBestProvider.future),
    hasSavedRun: (ref) => ref.watch(game.hasSavedRunProvider.future),
    practiceBest: (ref) =>
        ref.watch(game.bestScoreProvider(const .practice()).future),
  ),
  // Settings resets the game's progress without knowing the game.
  ...settings.bindProviders(
    clearProgress: (ref) => ref.watch(game.clearProgressProvider),
    settingsStore: (ref) => const SharedPreferencesSettingsStore(),
  ),
];
