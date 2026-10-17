import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_presentation/settings_presentation.dart'
    as settings_ui;

/// The one language step startup has to take, exposed here so the app shell
/// can take it without importing a feature — the same reason it imports none.
Future<void> applyStoredLanguage(ProviderContainer container) =>
    container.read(settings_ui.applyStoredLanguageProvider)();
