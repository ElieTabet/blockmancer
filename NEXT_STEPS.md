# Next steps for Blockmancer

What the generator could not do for you. Tick them off, then delete this file.

## Replace the placeholder screen

- [ ] Home (`packages/features/home/`) is a placeholder. Replace it with the app's main screen,
      or add tabs beside it — see "A new tab" in CLAUDE.md.

## Signing

- [ ] **Android:** create an upload keystore and `app/android/key.properties` (storeFile,
      storePassword, keyAlias, keyPassword). Keep both out of git — `.gitignore` already does.
- [ ] **iOS:** open `app/ios/Runner.xcworkspace`, pick the signing team, and check that the signing profile carries the capabilities
      `app/ios/Runner/Runner.entitlements` asks for.

## Production API

The app was generated without one, so `app/env/prod.json` defines no `API_BASE_URL`. Until it
does, `flavor-prod` runs against the local dev API and both release scripts refuse to build.

- [ ] Add `"API_BASE_URL": "https://…"` to `app/env/prod.json`.
- [ ] Add password autofill's associated domain for its host to
      `app/ios/Runner/Runner.entitlements` (`com.apple.developer.associated-domains` →
      `webcredentials:<host>`), and serve `apple-app-site-association` from that host.

## Firebase

- [ ] Restrict the two API keys in Google Cloud (APIs & Services → Credentials) to the
      application id `com.elietabet.blockmancer` and the iOS bundle id `com.elietabet.blockmancer`.
- [ ] Upload the APNs authentication key in the Firebase console (Project settings → Cloud
      Messaging), or iOS pushes never arrive.
- [ ] Telemetry only sends from a **release build against production** — check Crashlytics and
      Analytics after the first such build.

## Stores

- [ ] Create the App Store Connect app and the Play Console listing for `com.elietabet.blockmancer`.

- [ ] Write the privacy policy and the App Store privacy details (Crashlytics and
      Analytics collect usage and crash data from release builds).
