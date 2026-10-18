// The release IDs a build needs: read from `app/env/prod.json` (the one file
// that holds them, passed with --dart-define-from-file), with a named
// placeholder until the real ID is in it. The release build scripts refuse a
// file that still holds one; docs/console-setup.md lists them all.

/// The App Store's numeric id for the app, for its store page.
const appStoreId = String.fromEnvironment(
  'APP_STORE_ID',
  defaultValue: 'PLACEHOLDER_APP_STORE_ID',
);

/// Each store's page for the app.
const storeUrls = (
  android:
      'https://play.google.com/store/apps/details?id=com.elietabet.blockmancer',
  ios: 'https://apps.apple.com/app/id$appStoreId',
);

/// The AdMob units a release build plays; every other build plays Google's
/// test units (`TestAdUnits`).
const admobUnits = (
  interstitialAndroid: String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ANDROID',
    defaultValue: 'PLACEHOLDER_ADMOB_INTERSTITIAL_ANDROID',
  ),
  interstitialIos: String.fromEnvironment(
    'ADMOB_INTERSTITIAL_IOS',
    defaultValue: 'PLACEHOLDER_ADMOB_INTERSTITIAL_IOS',
  ),
  rewardedAndroid: String.fromEnvironment(
    'ADMOB_REWARDED_ANDROID',
    defaultValue: 'PLACEHOLDER_ADMOB_REWARDED_ANDROID',
  ),
  rewardedIos: String.fromEnvironment(
    'ADMOB_REWARDED_IOS',
    defaultValue: 'PLACEHOLDER_ADMOB_REWARDED_IOS',
  ),
);
