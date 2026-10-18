import 'package:app_update_data/app_update_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Given no banner closed, Then none is remembered', () async {
    expect(
      await const SharedPreferencesUpdateDismissals().dismissedVersion(),
      isNull,
    );
  });

  test('Given a banner closed, When the app relaunches, Then its version is '
      'remembered', () async {
    // Given
    await const SharedPreferencesUpdateDismissals().dismiss('1.1.0');

    // When / Then
    expect(
      await const SharedPreferencesUpdateDismissals().dismissedVersion(),
      '1.1.0',
    );
  });
}
