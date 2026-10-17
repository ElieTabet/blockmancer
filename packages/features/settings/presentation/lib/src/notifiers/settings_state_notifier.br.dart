import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/entities/app_language_locale.dart';
import 'package:settings_presentation/src/package_name.dart';
import 'package:settings_presentation/src/providers_di.br.dart' as di;
import 'package:timber/timber.dart';

part 'settings_state_notifier.br.g.dart';

/// Settings' choices. Holds nothing: each change is the player's settings to
/// keep, and closing is [SettingsRouting]'s to follow.
@riverpod
class SettingsStateNotifier extends _$SettingsStateNotifier {
  @override
  void build() {}

  void close(BuildContext context) =>
      ref.read(di.settingsRoutingProvider).onCloseRequested(context);

  void replayTutorial(BuildContext context) =>
      ref.read(di.settingsRoutingProvider).onReplayTutorialRequested(context);

  Future<void> resetProgress() async {
    final resetProgress = ref.read(resetProgressProvider);

    try {
      await resetProgress();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Resetting the progress failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Whether a mail draft opened; when not, the player is shown the address
  /// to write to.
  Future<bool> sendFeedback() async {
    final sendFeedback = ref.read(sendFeedbackProvider);

    try {
      return await sendFeedback();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Sending feedback failed',
        exception: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  Future<void> setHaptics(bool on) => _settings.setHaptics(on);

  /// Shows the app in [language] once it is kept.
  Future<void> setLanguage(AppLanguage language) async {
    await _settings.setLanguage(language);

    language.apply();
  }

  Future<void> setReduceMotion(bool on) => _settings.setReduceMotion(on);

  Future<void> setSound(bool on) => _settings.setSound(on);

  /// Whether the share sheet opened with the testers' stats. [origin] is the
  /// row's rect, which an iPad's popover points from.
  Future<bool> shareTestStats({Rect? origin}) async {
    final summary = ref.read(testStatsSummaryProvider);
    final shareText = ref.read(di.shareTextProvider);

    try {
      return await shareText(
        await summary(),
        origin: origin,
        subject: testStatsSubject,
      );
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Sharing the test stats failed',
        exception: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  SettingsNotifier get _settings => ref.read(settingsProvider.notifier);
}
