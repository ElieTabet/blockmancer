import 'package:ads/ads.dart';
import 'package:app_info/app_info.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:external_links/external_links.dart' as external_links;
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
    bestScores: (ref) => SharedPreferencesBestScores(
      startingProgression: ref.watch(game.initialProgressionProvider),
    ),
    clock: (ref) => const SystemClock(),
    gameRules: (ref) => const BlockmancerEngine(),
    progressionStore: (ref) => SharedPreferencesProgressionStore(
      startingProgression: ref.watch(game.initialProgressionProvider),
    ),
    runStore: (ref) => const SharedPreferencesRunStore(),
  ),
  ...game_ui.bindProviders(
    hapticsOnSetting: (ref) => ref.watch(settings.hapticsOnProvider),
    // Settings keeps the tutorial seen, without the game knowing Settings.
    markTutorialSeen: (ref) =>
        ref.watch(settings.settingsProvider.notifier).markTutorialSeen,
    playSound: (ref) {
      final sounds = ref.watch(gameSoundsProvider);

      return (sound, {semitones = 0, variance = 0}) => sounds.play(
        switch (sound) {
          .bossStart => .bossStart,
          .bossWin => .bossWin,
          .cheer => .cheer,
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
  // Home shows the game's map, bests and saved run without knowing the game,
  // and obeys Settings' reduce motion without knowing Settings.
  ...home_ui.bindProviders(
    dailyBest: (ref) => ref.watch(game.todaysDailyBestProvider.future),
    dailyDate: (ref) => ref.watch(game.todaysDailyDateProvider),
    hasSavedRun: (ref) => ref.watch(game.hasSavedRunProvider.future),
    markJokersAnnounced: (ref) => ref.watch(game.markJokersAnnouncedProvider),
    practiceBest: (ref) =>
        ref.watch(game.bestScoreProvider(const .practice()).future),
    // Watched, so a run's end refreshing the progression refreshes the map.
    progression: (ref) => ref.watch(game.progressionProvider.future),
    reduceMotionSetting: (ref) => ref.watch(settings.reduceMotionOnProvider),
    worlds: (ref) => ref.watch(game.worldSummariesProvider),
  ),
  // Settings resets the game's progress without knowing the game, and shows
  // the build and opens the mail app without knowing either plugin.
  ...settings.bindProviders(
    appDetails: (ref) async {
      final info = await readAppInfo();

      return settings.AppDetails(
        build: info.build,
        device: info.device,
        os: info.os,
        version: info.version,
      );
    },
    clearProgress: (ref) => ref.watch(game.clearProgressProvider),
    composeEmail: (ref) => external_links.composeEmail,
    settingsStore: (ref) => const SharedPreferencesSettingsStore(),
  ),
  // The splash opens the tutorial on a first launch without knowing Settings.
  ...splash_ui.bindProviders(
    tutorialSeen: (ref) => ref.watch(settings.tutorialSeenProvider.future),
  ),
];
