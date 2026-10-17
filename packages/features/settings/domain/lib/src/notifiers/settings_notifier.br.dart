import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/src/entities/app_language.dart';
import 'package:settings_domain/src/entities/app_settings.br.dart';
import 'package:settings_domain/src/package_name.dart';
import 'package:settings_domain/src/providers_di.br.dart' as di;
import 'package:timber/timber.dart';

part 'settings_notifier.br.g.dart';

/// The player's settings, read once and kept for as long as the app runs.
///
/// A change shows at once and is written after. Writes land in the order they
/// were made, so the last change is the one kept; one that fails is logged,
/// and the change still holds until the app closes.
@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  Future<void> _lastWrite = Future.value();

  @override
  Future<AppSettings> build() async {
    try {
      return await ref.watch(di.settingsStoreProvider).load();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The settings could not be read; using the defaults',
        exception: error,
        stackTrace: stackTrace,
      );

      return const AppSettings();
    }
  }

  Future<void> markTutorialSeen() =>
      _update((settings) => settings.copyWith(tutorialSeen: true));

  /// Offers the tutorial again, as on a first launch.
  Future<void> resetTutorial() =>
      _update((settings) => settings.copyWith(tutorialSeen: false));

  Future<void> setHaptics(bool on) =>
      _update((settings) => settings.copyWith(haptics: on));

  Future<void> setLanguage(AppLanguage language) =>
      _update((settings) => settings.copyWith(language: language));

  Future<void> setReduceMotion(bool on) =>
      _update((settings) => settings.copyWith(reduceMotion: on));

  Future<void> setSound(bool on) =>
      _update((settings) => settings.copyWith(sound: on));

  Future<void> _update(
    AppSettings Function(AppSettings settings) change,
  ) async {
    // A change made while the settings load lands on what was loaded, not on
    // the defaults.
    if (!state.hasValue) await future;

    final next = change(state.requireValue);
    final store = ref.read(di.settingsStoreProvider);

    state = AsyncData(next);

    final write = _lastWrite.then((_) => store.save(next));

    // One failed write mustn't block the ones queued behind it.
    _lastWrite = write.then((_) {}, onError: (Object _) {});

    try {
      await write;
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Saving the settings failed; the change lasts this session',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
