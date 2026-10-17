import 'package:settings_domain/settings_domain.dart';

/// The settings kept in memory, as the device would keep them across launches.
class FakeSettingsStore implements SettingsStore {
  FakeSettingsStore([this.saved]);

  AppSettings? saved;

  @override
  Future<AppSettings> load() async => saved ?? const AppSettings();

  @override
  Future<void> save(AppSettings settings) async => saved = settings;
}
