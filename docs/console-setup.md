# Console setup

Everything to do by hand outside the code, in order, for Blockmancer 1.0. For each step: the
console, where to click, the values to enter, and which ID to send back. The code is already
wired for each one. Sections a task hasn't reached yet are marked as such and get filled in with
it.

- Firebase project: **blockmancer-a153f**
- Bundle id / package name: **com.elietabet.blockmancer** (iOS and Android)

## Placeholders

Every ID the stores and AdMob give us lives in one file, **`app/env/prod.json`**, passed to the
release builds with `--dart-define-from-file`. Until the real ID is in, it holds a named
`PLACEHOLDER_…`. `melos run build-ios` / `build-android` refuse to build while one is left
(`scripts/check_release_ids.sh`); the test builds (`build-ios-test`, `build-android-test`) only
warn, since they play Google's test ad units.

| Key in `app/env/prod.json` | Status | Where the real value comes from |
|---|---|---|
| `APP_STORE_ID` | `PLACEHOLDER_APP_STORE_ID` | App Store Connect → the app → App Information → **Apple ID** (a number, e.g. `6740000000`). Used for the store link of the update screen and banner. |
| `ADMOB_APP_ID_IOS` | received | AdMob → Apps → Blockmancer (iOS) → App settings → **App ID** (`ca-app-pub-…~…`) |
| `ADMOB_APP_ID_ANDROID` | received | AdMob → Apps → Blockmancer (Android) → App settings → **App ID** |
| `ADMOB_REWARDED_IOS` | received | AdMob → iOS app → Ad units → **revive** → Ad unit ID (`ca-app-pub-…/…`) |
| `ADMOB_REWARDED_ANDROID` | received | AdMob → Android app → Ad units → **revive** |
| `ADMOB_INTERSTITIAL_IOS` | received | AdMob → iOS app → Ad units → **run_end** |
| `ADMOB_INTERSTITIAL_ANDROID` | received | AdMob → Android app → Ad units → **run_end** |

The product and leaderboard IDs are ours to choose, not placeholders: enter them in the consoles
exactly as written in their sections below.

## Firebase

### 1. Apps and config files (done)

Both apps are registered in **blockmancer-a153f** with the bundle id above, and their config
files are committed:

- iOS: `app/ios/Runner/GoogleService-Info.plist` (in the Runner target)
- Android: `app/android/app/google-services.json`

Nothing to send back. If either app is ever re-created, download its file again into the same
place.

### 2. Analytics settings

Firebase console → ⚙ Project settings → **Integrations** → Google Analytics → open the linked
property, then in Google Analytics → **Admin**:

1. **Data collection and modification → Data retention** → Event data retention: **14 months**
   (the longest without a paid property) → Save.
2. **Data collection and modification → Data collection** → **Google signals: off** (the app
   asks for no cross-device data, and the privacy answers assume it).
3. Leave **advertising features** off until AdMob is linked (Task 3).

What the app sends: the automatic events plus `run_start`, `joker_pick`, `round_end`, `revive`,
`run_end` and `world_unlock` (parameters in CLAUDE.md, Local stats). Only a release build against
production collects; a debug build sends nothing.

### 3. Crashlytics

Firebase console → **Crashlytics** → select each app → **Enable Crashlytics** (if it isn't).

To check it works: install a **test build** (`melos run build-ios-test` / `build-android-test`,
uploaded to TestFlight / Play internal testing), open Settings → **Test crash**. The app closes;
relaunch it, and the crash appears in Crashlytics within a few minutes. The release build has no
such row.

The build scripts upload the Dart symbols themselves; iOS dSYMs go up from the Runner target's
"Upload Crashlytics symbols" build phase.

### 4. Remote Config

Every number a run plays with, and the update versions, can change from the console without a
release.

- **The keys:** [`docs/remote-config/keys.md`](remote-config/keys.md) — name, type, default,
  allowed range, what it changes (68 keys). A value outside its range, or not a number, is
  ignored and the default plays.
- **The template:** [`docs/remote-config/template.json`](remote-config/template.json), generated
  from the code's own defaults (`packages/composition/app_providers/tool/remote_config_template.dart`;
  a test fails if it drifts). Publishing it changes nothing until a value is edited.

Publish the template once, so every key is visible and editable:

1. Firebase console → **Run** → **Remote Config**.
2. If the project has no template yet, create any parameter to open the editor.
3. ⋮ menu at the top right → **Publish from a file** → choose `docs/remote-config/template.json`
   → **Publish**.

Or with the Firebase CLI (check `firebase --help deploy` for your version):
add `"remoteconfig": {"template": "docs/remote-config/template.json"}` to a `firebase.json` at the
repo root, then `firebase deploy --only remoteconfig --project blockmancer-a153f`.

How the app reads them: fetched at launch, at most every 12 hours (every 5 minutes in a test
build); a run reads them as it starts, so a change reaches the next run, never one in progress.
The update check waits up to 2 seconds for the launch's fetch.

**Kill switch:** set `min_version_ios` / `min_version_android` above a broken version (e.g.
`1.0.1` to stop 1.0.0) and publish: that version shows "Update required" with a store button from
its next launch. `latest_version_*` shows a dismissible banner on the map instead, once per
version. All four default to `0.0.0`, which asks nothing.

## AdMob

*(Consent and ads: Tasks 2 and 3.)* The app IDs and the two ad units per platform are received
(table above).

## App Store Connect

*(Purchase, Game Center and privacy answers: Tasks 2, 4 and 6.)* Send back the **Apple ID** of
the app (`APP_STORE_ID`, above) once the app record exists.

## Play Console

*(In-app product, Play Games and Data safety: Tasks 2, 4 and 6.)*
