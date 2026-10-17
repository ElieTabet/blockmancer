import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/src/behaviors/reset_progress_behavior.dart';
import 'package:settings_domain/src/behaviors/send_feedback_behavior.dart';
import 'package:settings_domain/src/behaviors/test_stats_summary_behavior.dart';
import 'package:settings_domain/src/contracts/settings_store.dart';
import 'package:settings_domain/src/entities/app_details.br.dart';
import 'package:settings_domain/src/entities/app_language.dart';
import 'package:settings_domain/src/entities/app_settings.br.dart';
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

List<Override> bindProviders({
  required Future<AppDetails> Function(Ref ref) appDetails,
  required di.ClearProgressFun Function(Ref ref) clearProgress,
  required di.ComposeEmailFun Function(Ref ref) composeEmail,
  required di.ExportTestStatsFun Function(Ref ref) exportTestStats,
  required SettingsStore Function(Ref ref) settingsStore,
}) => [
  di.appDetailsProvider.overrideWith(appDetails),
  di.clearProgressProvider.overrideWith(clearProgress),
  di.composeEmailProvider.overrideWith(composeEmail),
  di.exportTestStatsProvider.overrideWith(exportTestStats),
  di.settingsStoreProvider.overrideWith(settingsStore),
];
