// The ids a build needs: read from `app/env/prod.json` (the one file that holds
// them all, passed with --dart-define-from-file; Gradle and an Xcode build
// phase read the native ones from it too), with a named placeholder until the
// real id is in it. The release build scripts refuse a file that still holds
// one; docs/console-setup.md lists them all. A debug run gets them with
// `flutter run --dart-define-from-file=env/prod.json`.

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

/// The Remove ads product, the same id on both stores.
const iapRemoveAds = String.fromEnvironment(
  'IAP_REMOVE_ADS',
  defaultValue: 'PLACEHOLDER_IAP_REMOVE_ADS',
);

/// The devices that get AdMob's test ads even from a release build (comma
/// separated; the ids the ad SDK logs at launch). Empty: none.
const admobTestDeviceIds = String.fromEnvironment('ADMOB_TEST_DEVICE_IDS');

/// The leaderboards: Game Center's ids are ours, Play Games' are the console's.
const leaderboardIds = (
  gameCenterBest: String.fromEnvironment(
    'GAME_CENTER_LEADERBOARD_BEST',
    defaultValue: 'PLACEHOLDER_GAME_CENTER_LEADERBOARD_BEST',
  ),
  gameCenterDaily: String.fromEnvironment(
    'GAME_CENTER_LEADERBOARD_DAILY',
    defaultValue: 'PLACEHOLDER_GAME_CENTER_LEADERBOARD_DAILY',
  ),
  playBest: String.fromEnvironment(
    'PLAY_LEADERBOARD_BEST',
    defaultValue: 'PLACEHOLDER_PLAY_LEADERBOARD_BEST',
  ),
  playDaily: String.fromEnvironment(
    'PLAY_LEADERBOARD_DAILY',
    defaultValue: 'PLACEHOLDER_PLAY_LEADERBOARD_DAILY',
  ),
);
