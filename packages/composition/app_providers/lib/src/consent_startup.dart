import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/settings_domain.dart' as settings;

/// Asks for consent where the law requires it, before any ad is requested:
/// once the first frame is up, since the form is drawn over the app. Ads
/// wait for it; the game doesn't.
Future<void> gatherConsent(ProviderContainer container) =>
    container.read(settings.consentProvider.notifier).gather();
