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
| `ADMOB_REWARDED_IOS` | received | AdMob → iOS app → Ad units → **revive** → Ad unit ID (`ca-app-pub-…/…`) |
| `ADMOB_REWARDED_ANDROID` | received | AdMob → Android app → Ad units → **revive** |
| `ADMOB_INTERSTITIAL_IOS` | received | AdMob → iOS app → Ad units → **run_end** |
| `ADMOB_INTERSTITIAL_ANDROID` | received | AdMob → Android app → Ad units → **run_end** |

Two IDs are read by native code at launch, so they live in the native files instead (and a
placeholder there blocks a release build too):

| Native file | ID | Status |
|---|---|---|
| `app/ios/Runner/Info.plist` → `GADApplicationIdentifier` | AdMob iOS **App ID** (`ca-app-pub-…~…`) | received |
| `app/android/app/src/main/AndroidManifest.xml` → `com.google.android.gms.ads.APPLICATION_ID` | AdMob Android **App ID** | received |

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

### 1. Apps and ad units (done)

Both apps exist (iOS and Android, publisher `pub-9236909266129177`), each with two ad units:

| Ad unit name | Format | Used for |
|---|---|---|
| `revive` | Rewarded | The revive after a lost round |
| `run_end` | Interstitial | Between runs: on Play again or leaving a finished run |

Their IDs are in the tables above. Debug and test builds use Google's public test units, never
these; only a release build (not a test build) plays them.

The interstitial's pacing is Remote Config's (`interstitial_min_completed_runs` 3,
`interstitial_every_n_run_ends` 2, `interstitial_min_seconds` 90; keys.md): never in the tutorial
or a player's first session, never mid-run. Leave AdMob's own frequency capping off: the app caps
itself. Analytics receives `ad_shown(type)`, `ad_reward_earned` and `ad_failed(type, code)`; linking
AdMob to the Firebase project (AdMob → Apps → the app → App settings → **Link to Firebase**) adds
AdMob's own revenue events.

### 2. Privacy & messaging (consent)

AdMob → **Privacy & messaging**:

1. **European regulations (GDPR)** → **Create message** → apps: both Blockmancer apps;
   languages: English and French; consent options: **Consent** and **Do not consent** (the "Do not
   consent" button keeps the form fair; the app plays the same either way); privacy policy URL:
   `https://studio.elietabet.com/privacy`; targeting: **EEA, UK and Switzerland** → **Publish**.
2. **IDFA explainer** (iOS only) → **Create message** → app: Blockmancer (iOS); languages: English
   and French → **Publish**. When the player taps Continue, iOS shows its tracking alert with the
   app's own text (`NSUserTrackingUsageDescription` in `Info.plist`: "This lets Blockmancer show
   ads that suit you better. Ads appear either way, and your choice never changes the game.").
3. Optional: **US state regulations** message, if you want it (the app doesn't need it to run).

How the app uses it: at every launch, once the first frame is up, it asks Google's UMP whether a
message is due, shows it if so, and only then may request ads; Analytics' consent mode follows
the answer. Settings shows **Privacy choices** (reopens the message) only where UMP says the
player must be able to change their answer, plus **Privacy policy** and **Support** links.

To test the EEA form from anywhere: install a test build run with
`flutter run --release --dart-define-from-file=env/prod.json --dart-define=TEST_TOOLS=true
--dart-define=UMP_DEBUG_EEA=true` (from `app/`), copy the device id the UMP SDK logs ("Use new
ConsentDebugSettings.Builder().addTestDeviceHashedId(…)"), and run again with
`--dart-define=UMP_TEST_DEVICE_ID=<that id>` added: the form shows as in the EEA. Decline: the
game plays as usual.

### 3. app-ads.txt

Host a file at **`https://studio.elietabet.com/app-ads.txt`** containing exactly:

```
google.com, pub-9236909266129177, DIRECT, f08c47fec0942fa0
```

and set the developer website of both store listings to `https://studio.elietabet.com` (AdMob
looks for app-ads.txt at the root of the developer website's domain). AdMob → Apps → View all
apps → **app-ads.txt** tab shows when it has been found (it can take a day).

### 4. Payments

AdMob → **Payments** → payment info: address, tax information (W-8BEN or your country's
equivalent for a French micro-entreprise), and the bank account; payments start once earnings
pass the threshold.

## App Store Connect

Send back the **Apple ID** of the app (`APP_STORE_ID`, above) once the app record exists.

### App Privacy

App Store Connect → the app → **App Privacy** → Get Started, answering what the SDKs collect
(Firebase Analytics, Crashlytics, AdMob):

| Data type | Collected | Linked to the player | Used to track | Purposes |
|---|---|---|---|---|
| Identifiers → Device ID | Yes (AdMob, only with tracking allowed) | No | **Yes** | Third-party advertising |
| Usage Data → Product Interaction | Yes (Analytics events) | No | No | Analytics |
| Usage Data → Advertising Data | Yes (AdMob) | No | Yes | Third-party advertising |
| Diagnostics → Crash Data | Yes (Crashlytics) | No | No | App functionality |
| Diagnostics → Performance Data | Yes (Crashlytics) | No | No | App functionality |
| Purchases → Purchase History | Yes (Task 4, Remove ads) | No | No | App functionality |

No contact info, no location, no user content: the app has no account. "Used to track" answers
must match the IDFA: the app asks the tracking question (ATT) through the IDFA explainer.

### In-app purchase: Remove ads

App Store Connect → the app → **Monetization → In-App Purchases** → **+**:

- Type: **Non-Consumable**
- Reference name: `Remove ads`
- Product ID: **`remove_ads`** (exactly; the app asks for this id)
- Price: **$3.99** (Price Schedule → United States, $3.99; other countries follow Apple's tiers)
- Localizations: English "Remove ads" / "No more ads between runs, for good. The revive's
  optional ad stays."; French "Supprimer les pubs" / "Plus de pubs entre les parties, pour de bon.
  La pub facultative pour revivre reste."
- Review screenshot: Settings with the **Remove ads** row (any test build)
- Review notes: "Settings → Remove ads buys it; Settings → Restore purchases restores it. It
  removes the interstitial between runs; the rewarded ad offered to revive stays, opt-in."
- Then add it to the app version's **In-App Purchases** section before submitting the build.

To test: App Store Connect → **Users and Access → Sandbox → Testers** → add a tester; on the
iPhone, Settings → App Store → Sandbox Account → sign in; buy and restore from a TestFlight build.

*(Game Center: Task 6.)*

## Play Console

### Data safety

Play Console → the app → **Policy and programs → App content → Data safety**:

- Does the app collect or share user data? **Yes.** Encrypted in transit: **Yes.** Can users ask
  for deletion: **No** (no account; nothing is tied to a person — say so in the form's note).
- **Device or other IDs** — collected and shared (AdMob: advertising id) — purposes: Advertising
  or marketing, Analytics; optional: **No**.
- **App activity → App interactions** — collected (Analytics events) — Analytics.
- **App info and performance → Crash logs, Diagnostics** — collected (Crashlytics) — App
  functionality, Analytics.
- **Financial info → Purchase history** — collected (Task 4) — App functionality.

### Ads

App content → **Ads** → "Does your app contain ads?" **Yes**. Advertising ID: declare its use for
**Advertising or marketing** and **Analytics** (the manifest declares `AD_ID`).

### In-app product: Remove ads

Play Console → the app → **Monetize with Play → Products → In-app products** → **Create
product**:

- Product ID: **`remove_ads`** (exactly)
- Name / description: as in App Store Connect, in English and French
- Default price: **USD 3.99** → **Update exchange rates** for the other countries
- **Activate** it. (Play only lists products once the app has a build with the BILLING permission
  uploaded to a track: upload a test build to internal testing first; `in_app_purchase` adds the
  permission.)

To test: Play Console → **Settings → License testing** → add the testers' Google accounts; install
the build from the internal testing track (not a sideloaded APK) and buy: test cards are offered.

*(Play Games: Task 6.)*
