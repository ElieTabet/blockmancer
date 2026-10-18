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
/// mail drafts open in [mailApp], and the play stats export as [playStats].
/// The consent form answers [consent], one after another; what reaches the
/// consent form, Analytics and the browser is recorded in [calls].
ProviderContainer launchWith(
  SettingsStore store, {
  AppDetails appDetails = testAppDetails,
  List<String>? calls,
  List<ConsentAnswer> consent = const [
    (canRequestAds: true, privacyOptionsRequired: false),
  ],
  FakeMailApp? mailApp,
  ClearProgressFun? onClearProgress,
  String playStats = '{"installId":"ab12","schema":1}',
}) {
  final answers = [...consent];

  final container = ProviderContainer(
    overrides: bindProviders(
      appDetails: (ref) async => appDetails,
      clearProgress: (ref) => onClearProgress ?? () async {},
      composeEmail: (ref) => (mailApp ?? FakeMailApp()).compose,
      exportTestStats: (ref) =>
          () async => playStats,
      gatherConsent: (ref) => () async {
        calls?.add('gather');

        return answers.length > 1 ? answers.removeAt(0) : answers.single;
      },
      openUrl: (ref) => (url) async {
        calls?.add('open $url');

        return true;
      },
      setAnalyticsConsent: (ref) =>
          ({required granted}) async => calls?.add('analytics: $granted'),
      settingsStore: (ref) => store,
      showPrivacyOptions: (ref) =>
          () async => calls?.add('privacy options'),
    ),
  );
  addTearDown(container.dispose);

  return container;
}
