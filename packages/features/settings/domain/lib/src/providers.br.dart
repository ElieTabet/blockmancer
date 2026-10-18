import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/src/behaviors/reset_progress_behavior.dart';
import 'package:settings_domain/src/behaviors/send_feedback_behavior.dart';
import 'package:settings_domain/src/behaviors/test_stats_summary_behavior.dart';
import 'package:settings_domain/src/contracts/settings_store.dart';
import 'package:settings_domain/src/entities/app_details.br.dart';
import 'package:settings_domain/src/entities/app_language.dart';
import 'package:settings_domain/src/entities/app_settings.br.dart';
import 'package:settings_domain/src/notifiers/consent_notifier.br.dart';
import 'package:settings_domain/src/notifiers/settings_notifier.br.dart';
import 'package:settings_domain/src/providers_di.br.dart' as di;

part 'providers.br.g.dart';

// settings_domain — public providers exposed by this layer. The leaves are
// what composition hands the features that obey a setting; while the settings
// load, each reads as a first launch has it.

typedef ResetProgressFun = Future<void> Function();

typedef SendFeedbackFun = Future<bool> Function();

/// See [TestStatsSummaryBehavior].
typedef TestStatsSummaryFun = Future<String> Function();

const _defaults = AppSettings();

/// The language the player chose. A future, so the app can be put in it
/// before its first frame rather than switch after.
@riverpod
Future<AppLanguage> appLanguage(Ref ref) =>
    ref.watch(settingsProvider.selectAsync((settings) => settings.language));

@riverpod
bool dailyReminderOn(Ref ref) =>
    ref.watch(settingsProvider).value?.dailyReminder ?? _defaults.dailyReminder;

/// Whether the player wants the daily reminder. A future, so the reminder is
/// never scheduled, or cancelled, on a default before the stored answer.
@riverpod
Future<bool> dailyReminderEnabled(Ref ref) => ref.watch(
  settingsProvider.selectAsync((settings) => settings.dailyReminder),
);

@riverpod
bool hapticsOn(Ref ref) =>
    ref.watch(settingsProvider).value?.haptics ?? _defaults.haptics;

@riverpod
bool reduceMotionOn(Ref ref) =>
    ref.watch(settingsProvider).value?.reduceMotion ?? _defaults.reduceMotion;

/// See [ResetProgressBehavior].
@riverpod
ResetProgressFun resetProgress(Ref ref) => ResetProgressBehavior(
  clearProgress: ref.watch(di.clearProgressProvider),
  resetTutorial: ref.watch(settingsProvider.notifier).resetTutorial,
).call;

/// See [SendFeedbackBehavior].
@riverpod
SendFeedbackFun sendFeedback(Ref ref) => SendFeedbackBehavior(
  appDetails: ref.watch(di.appDetailsProvider.future),
  composeEmail: ref.watch(di.composeEmailProvider),
).call;

@riverpod
bool soundOn(Ref ref) =>
    ref.watch(settingsProvider).value?.sound ?? _defaults.sound;

@riverpod
TestStatsSummaryFun testStatsSummary(Ref ref) => TestStatsSummaryBehavior(
  appDetails: ref.watch(di.appDetailsProvider.future),
  exportTestStats: ref.watch(di.exportTestStatsProvider),
).call;

/// Whether the player has been through the tutorial. A future, so a launch
/// waits for the stored answer instead of showing the tutorial on a default.
@riverpod
Future<bool> tutorialSeen(Ref ref) => ref.watch(
  settingsProvider.selectAsync((settings) => settings.tutorialSeen),
);

/// The studio site's privacy policy, which the stores and the consent form
/// link to as well.
const privacyPolicyUrl = 'https://studio.elietabet.com/privacy';

const supportUrl = 'https://studio.elietabet.com/support';

typedef OpenLinkFun = Future<bool> Function();

/// Whether Settings offers "Privacy choices": only where the consent form
/// says the player must be able to change their answer.
@riverpod
bool privacyChoicesRequired(Ref ref) =>
    ref.watch(consentProvider)?.privacyOptionsRequired ?? false;

@riverpod
OpenLinkFun openPrivacyPolicy(Ref ref) {
  final openUrl = ref.watch(di.openUrlProvider);

  return () => openUrl(privacyPolicyUrl);
}

@riverpod
OpenLinkFun openSupport(Ref ref) {
  final openUrl = ref.watch(di.openUrlProvider);

  return () => openUrl(supportUrl);
}

List<Override> bindProviders({
  required Future<AppDetails> Function(Ref ref) appDetails,
  required di.ClearProgressFun Function(Ref ref) clearProgress,
  required di.ComposeEmailFun Function(Ref ref) composeEmail,
  required di.ExportTestStatsFun Function(Ref ref) exportTestStats,
  required di.GatherConsentFun Function(Ref ref) gatherConsent,
  required di.OpenUrlFun Function(Ref ref) openUrl,
  required di.SetAnalyticsConsentFun Function(Ref ref) setAnalyticsConsent,
  required SettingsStore Function(Ref ref) settingsStore,
  required di.ShowPrivacyOptionsFun Function(Ref ref) showPrivacyOptions,
}) => [
  di.appDetailsProvider.overrideWith(appDetails),
  di.clearProgressProvider.overrideWith(clearProgress),
  di.composeEmailProvider.overrideWith(composeEmail),
  di.exportTestStatsProvider.overrideWith(exportTestStats),
  di.gatherConsentProvider.overrideWith(gatherConsent),
  di.openUrlProvider.overrideWith(openUrl),
  di.setAnalyticsConsentProvider.overrideWith(setAnalyticsConsent),
  di.settingsStoreProvider.overrideWith(settingsStore),
  di.showPrivacyOptionsProvider.overrideWith(showPrivacyOptions),
];
