import 'package:app_providers/app_providers.dart';
import 'package:app_providers/src/providers_internal.br.dart';
import 'package:app_router/app_router.dart';
import 'package:app_update_domain/app_update_domain.dart' as app_update;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_remote_values.dart';

// The real wiring from Remote Config to the update check: what is under test
// is that what a return to the app fetches reaches the check without a
// relaunch.
void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  test('a minimum the fetch on return brings makes this version required at '
      'once', () async {
    // Given: version 1.0.0, started with nothing published
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Blockmancer',
      buildNumber: '1',
      buildSignature: '',
      packageName: 'com.elietabet.blockmancer',
      version: '1.0.0',
    );
    final values = FakeRemoteValues();
    final container = ProviderContainer(
      overrides: [
        ...appOverrides(
          collectsTelemetry: false,
          router: AppRouter(),
          testTools: false,
        ),
        remoteValuesProvider.overrideWithValue(values),
      ],
    );
    addTearDown(container.dispose);
    fetchRemoteConfig(container);
    container.listen(app_update.updateRequiredProvider, (_, _) {});
    expect(
      await container.read(app_update.updateRequiredProvider.future),
      isFalse,
    );

    // When: the app goes to the background, and comes back to a raised
    // minimum
    values.onFetch = {'min_version_android': '1.0.1'};
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      binding.handleAppLifecycleStateChanged(state);
    }

    await pumpEventQueue();

    // Then
    expect(
      await container.read(app_update.updateRequiredProvider.future),
      isTrue,
    );
    expect(values.fetches, 2);
  });
}
