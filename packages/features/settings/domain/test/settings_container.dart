import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

import 'fake_mail_app.dart';

/// What the app reports about a release build on an iPhone.
const testAppDetails = AppDetails(
  build: '2',
  device: 'iPhone 15 Pro',
  os: 'iOS 18.1',
  version: '1.0.0',
);

/// A launch of the app over [store], on the phone [appDetails] describes
/// ([testAppDetails] unless given). Progress clears into [onClearProgress],
/// and mail drafts open in [mailApp].
ProviderContainer launchWith(
  SettingsStore store, {
  AppDetails appDetails = testAppDetails,
  FakeMailApp? mailApp,
  ClearProgressFun? onClearProgress,
}) {
  final container = ProviderContainer(
    overrides: bindProviders(
      appDetails: (ref) async => appDetails,
      clearProgress: (ref) => onClearProgress ?? () async {},
      composeEmail: (ref) => (mailApp ?? FakeMailApp()).compose,
      settingsStore: (ref) => store,
    ),
  );
  addTearDown(container.dispose);

  return container;
}
