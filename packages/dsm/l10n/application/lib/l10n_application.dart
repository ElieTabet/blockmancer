library;

/// Application localization.
///
/// slang-generated, type-safe translations (en base, fr). Widgets read them reactively via
/// the generated `context.t` extension — the app must be wrapped once in `TranslationProvider`.
/// The initial locale is resolved from the device via `LocaleSettings.useDeviceLocaleSync()`;
/// switch at runtime with `LocaleSettings.setLocaleSync(...)`.
export 'i18n/strings.g.dart';
