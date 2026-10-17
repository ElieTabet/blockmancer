import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings_domain/src/entities/app_language.dart';

part 'app_settings.br.freezed.dart';

/// What the player has chosen. The defaults are a first launch's.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(true) bool haptics,
    @Default(AppLanguage.system) AppLanguage language,
    @Default(false) bool reduceMotion,
    @Default(true) bool sound,
    @Default(false) bool tutorialSeen,
  }) = _AppSettings;
}
