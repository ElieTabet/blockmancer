import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';

extension AppLanguageLocale on AppLanguage {
  /// Shows the app in this language; every `context.t` rebuilds.
  void apply() => switch (this) {
    .en => LocaleSettings.setLocaleSync(.en),
    .fr => LocaleSettings.setLocaleSync(.fr),
    .system => LocaleSettings.useDeviceLocaleSync(),
  };
}
