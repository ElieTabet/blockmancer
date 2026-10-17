import 'package:settings_domain/src/entities/app_settings.br.dart';

/// The settings kept on this device.
abstract interface class SettingsStore {
  /// A first launch's settings when nothing is saved; a value that can't be
  /// read is its default.
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);
}
