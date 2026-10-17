import 'package:app_providers/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/settings_domain.dart' as settings;

/// Loads the sounds into memory, and keeps them following Settings' sound
/// switch. Never throws: a failed start leaves the app silent for the session.
Future<void> initializeSounds(ProviderContainer container) {
  final sounds = container.read(gameSoundsProvider);

  container.listen(
    settings.soundOnProvider,
    (_, on) => sounds.enabled = on,
    fireImmediately: true,
  );

  return sounds.init();
}

/// The app's tap, for the design system's `DSPressFeedback`.
void playTapSound(ProviderContainer container) =>
    container.read(gameSoundsProvider).play(.tap);
