import 'package:app_update_domain/app_update_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [UpdateDismissals] under one key on the device.
final class SharedPreferencesUpdateDismissals implements UpdateDismissals {
  const SharedPreferencesUpdateDismissals();

  static const _key = 'update.dismissedVersion';

  @override
  Future<void> dismiss(String version) async =>
      (await SharedPreferences.getInstance()).setString(_key, version);

  @override
  Future<String?> dismissedVersion() async =>
      (await SharedPreferences.getInstance()).getString(_key);
}
