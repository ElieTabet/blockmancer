import 'package:app_info/app_info.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:app_providers/src/release_ids.dart';
import 'package:app_router/app_router.dart';
import 'package:app_update_data/app_update_data.dart';
import 'package:app_update_domain/app_update_domain.dart' as app_update;
import 'package:app_update_presentation/app_update_presentation.dart'
    as app_update_ui;
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:external_links/external_links.dart' as external_links;
import 'package:flutter/foundation.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_presentation/game_presentation.dart' as game_ui;
import 'package:home_presentation/home_presentation.dart' as home_ui;
import 'package:push/push.dart' as push;
import 'package:push_notifications_data/push_notifications_data.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications_domain;
import 'package:push_notifications_presentation/push_notifications_presentation.dart'
    as push_notifications_ui;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_data/settings_data.dart';
import 'package:settings_domain/settings_domain.dart' as settings;
import 'package:settings_presentation/settings_presentation.dart'
    as settings_ui;
import 'package:shop_data/shop_data.dart';
import 'package:shop_domain/shop_domain.dart' as shop;
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
/// whether this build sends usage statistics and crash reports. So is
/// [testTools]: whether it is a test build, with the testers' tools.
List<Override> featureBindingOverrides({
  required bool collectsTelemetry,
  required AppRouter router,
  required bool testTools,
}) => [
  testToolsProvider.overrideWithValue(testTools),
  // Constructed with no arguments on purpose: the two messaging plugins stay
  // inside `push`.
  ...push.bindProviders(pushMessaging: (ref) => push.FirebasePushMessaging()),
  // The same arrangement for the analytics and crash plugins.
  ...telemetry.bindProviders(
    collectsTelemetry: (ref) => collectsTelemetry,
    telemetry: (ref) => telemetry.FirebaseTelemetry(),
  ),
  ...push_notifications_domain.bindProviders(
    analyticsSink: (ref) => ref.watch(analyticsSinkProvider),
    cancelDailyReminder: (ref) => ref.watch(dailyReminderProvider).cancel,
    dailyReminderEnabled: (ref) =>
        ref.watch(settings.dailyReminderEnabledProvider.future),
    dailyStanding: (ref) => ref.watch(game.dailyStandingProvider),
    displayLanguage: (ref) => push_notifications_ui.displayLanguages(),
    hasCompletedRun: (ref) => ref.watch(game.hasCompletedRunProvider),
    launchMessage: (ref) => ref.watch(push.pushMessagingProvider).launchMessage,
    now: (ref) => const SystemClock().now,
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
    reminderLogStore: (ref) => const SharedPreferencesReminderLogStore(),
    reminderTexts: (ref) => push_notifications_ui.reminderMessageTexts,
    reminderTimes: (ref) => ref.watch(dailyReminderProvider).upcoming,
    replaceReminders: (ref) {
      final reminder = ref.watch(dailyReminderProvider);

      return (reminders) {
        final channel = push_notifications_ui.dailyReminderChannelTexts();

        return reminder.replace(
          reminders,
          channelDescription: channel.channelDescription,
          channelName: channel.channelName,
        );
      };
    },
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
    pushNotificationsRouting: (ref) => PushNotificationsRoutingImpl(
      router,
      revealDailyCard: ref.watch(home_ui.revealDailyCardProvider),
    ),
  ),
  // The game reaches the rules, its storage and the ad network only through
  // these slots.
  ...game.bindProviders(
    adsRemoved: (ref) => ref.watch(shop.removeAdsProvider.future),
    analyticsSink: (ref) => ref.watch(analyticsSinkProvider),
    appVersion: (ref) async => (await readAppInfo()).version,
    bestScores: (ref) => SharedPreferencesBestScores(
      startingProgression: ref.watch(game.initialProgressionProvider),
    ),
    clock: (ref) => const SystemClock(),
    engagementStore: (ref) => const SharedPreferencesEngagementStore(),
    gameRules: (ref) => const BlockmancerEngine(),
    onRunFinished: (ref) => ref
        .watch(push_notifications_domain.dailyReminderProvider.notifier)
        .runFinished,
    progressionStore: (ref) => SharedPreferencesProgressionStore(
      startingProgression: ref.watch(game.initialProgressionProvider),
    ),
    remoteValue: (ref) => ref.watch(liveRemoteValueProvider),
    requestReview: (ref) => ref.watch(storeReviewProvider).requestReview,
    runStore: (ref) => const SharedPreferencesRunStore(),
    sessionHadError: (ref) => ref.watch(telemetry.sessionHadErrorProvider),
    showInterstitial: (ref) => ref.watch(interstitialAdsProvider).show,
    submitBestScore: (ref) =>
        (score) =>
            ref.watch(leaderboardsProvider).submit(bestLeaderboard, score),
    submitDailyScore: (ref) =>
        (score) =>
            ref.watch(leaderboardsProvider).submit(dailyLeaderboard, score),
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
    preloadAds: (ref) {
      final interstitials = ref.watch(interstitialAdsProvider);
      final rewarded = ref.watch(rewardedAdsProvider);

      return () {
        interstitials.preload();
        rewarded.preload();
      };
    },
    reduceMotionSetting: (ref) => ref.watch(settings.reduceMotionOnProvider),
    rewardedAction: (ref) => ref.watch(rewardedAdsProvider).show,
    rewardedAdReady: (ref) => ref.watch(rewardedAdsProvider).readiness,
    soundOnSetting: (ref) => ref.watch(settings.soundOnProvider),
  ),
  // Home shows the game's map, bests and saved run without knowing the game,
  // and obeys Settings' reduce motion without knowing Settings.
  ...home_ui.bindProviders(
    dailyBest: (ref) => ref.watch(game.todaysDailyBestProvider.future),
    dailyDate: (ref) => ref.watch(game.todaysDailyDateProvider),
    dailyStreak: (ref) => ref.watch(game.dailyStreakProvider.future),
    dismissUpdateOffer: (ref) =>
        ref.watch(app_update.dismissUpdateOfferProvider),
    hasSavedRun: (ref) => ref.watch(game.hasSavedRunProvider.future),
    jokerCollection: (ref) => ref.watch(game.jokerCollectionProvider),
    markJokersAnnounced: (ref) => ref.watch(game.markJokersAnnouncedProvider),
    markSpellbookSeen: (ref) => ref.watch(game.markSpellbookSeenProvider),
    openStoreListing: (ref) =>
        ref.watch(app_update_ui.openStoreListingProvider),
    practiceBest: (ref) =>
        ref.watch(game.bestScoreProvider(const .practice()).future),
    // Watched, so a run's end refreshing the progression refreshes the map.
    progression: (ref) => ref.watch(game.progressionProvider.future),
    reduceMotionSetting: (ref) => ref.watch(settings.reduceMotionOnProvider),
    showDailyLeaderboard: (ref) =>
        () =>
            ref.watch(leaderboardsProvider).show(dailyLeaderboard, today: true),
    updateOffer: (ref) => ref.watch(app_update.updateOfferProvider.future),
    worlds: (ref) => ref.watch(game.worldSummariesProvider),
  ),
  // The update check compares this build's version with Remote Config's,
  // knowing neither the plugin behind the version nor Remote Config.
  ...app_update.bindProviders(
    appVersion: (ref) async => (await readAppInfo()).version,
    remoteValue: (ref) => ref.watch(liveRemoteValueProvider),
    remoteValuesFetched: (ref) => ref.watch(remoteValuesFetchedProvider.future),
    storePlatform: (ref) => defaultTargetPlatform == .iOS ? .ios : .android,
    storeUrls: (ref) => storeUrls,
    updateDismissals: (ref) => const SharedPreferencesUpdateDismissals(),
  ),
  ...app_update_ui.bindProviders(
    openUrl: (ref) => external_links.openExternalUrl,
    whenGameSettled: (ref) => ref.watch(game_ui.whenGameSettledProvider),
  ),
  // With the router instance, like push's: a published minimum blocks the app
  // wherever the player is, not from a screen.
  ...app_update_ui.bindRoutingProviders(
    appUpdateRouting: (ref) => AppUpdateRoutingImpl(router),
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
    exportTestStats: (ref) => ref.watch(playStatsProvider).exportJson,
    gatherConsent: (ref) => ref.watch(consentProvider).gather,
    openUrl: (ref) => external_links.openExternalUrl,
    setAnalyticsConsent: (ref) =>
        ref.watch(telemetry.telemetryProvider).setAnalyticsConsent,
    settingsStore: (ref) => const SharedPreferencesSettingsStore(),
    showPrivacyOptions: (ref) => ref.watch(consentProvider).showPrivacyOptions,
  ),
  // Remove ads: the shop decides, the stores' plugin stays in `purchases`.
  ...shop.bindProviders(
    analyticsSink: (ref) => ref.watch(analyticsSinkProvider),
    buyProduct: (ref) => ref.watch(purchasesProvider).buy,
    entitlementStore: (ref) => const SharedPreferencesEntitlementStore(),
    priceOf: (ref) => ref.watch(purchasesProvider).priceOf,
    purchaseUpdates: (ref) {
      final purchases = ref.watch(purchasesProvider);

      return () => purchases.updates;
    },
    recheckPurchases: (ref) => ref.watch(purchasesProvider).recheckQuietly,
    removeAdsProductId: (ref) => iapRemoveAds,
    restorePurchases: (ref) => ref.watch(purchasesProvider).restore,
  ),
  ...settings_ui.bindProviders(
    buyRemoveAds: (ref) => ref.watch(shop.removeAdsProvider.notifier).buy,
    crashForTest: (ref) => ref.watch(telemetry.telemetryProvider).crash,
    rateApp: (ref) => ref.watch(storeReviewProvider).openStoreListing,
    removeAdsOwned: (ref) => ref.watch(shop.removeAdsProvider).value ?? false,
    removeAdsPrice: (ref) => ref.watch(shop.removeAdsPriceProvider.future),
    restorePurchases: (ref) =>
        ref.watch(shop.removeAdsProvider.notifier).restore,
    shareText: (ref) => external_links.shareText,
    showsTestTools: (ref) => testTools,
  ),
  // The splash opens the tutorial on a first launch without knowing Settings.
  ...splash_ui.bindProviders(
    tutorialSeen: (ref) => ref.watch(settings.tutorialSeenProvider.future),
    updateRequired: (ref) =>
        ref.watch(app_update.updateRequiredProvider.future),
  ),
];
