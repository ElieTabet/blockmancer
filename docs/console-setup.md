# Console setup

Everything to do by hand outside the code, in order, for Blockmancer 1.0. For each step: the
console, where to click, the values to enter, and which ID to send back. The code is already
wired for each one. Sections a task hasn't reached yet are marked as such and get filled in with
it.

- Firebase project: **blockmancer-a153f**
- Bundle id / package name: **com.elietabet.blockmancer** (iOS and Android)

## Placeholders

Every ID the stores and AdMob give us lives in one file, **`app/env/prod.json`**:

- Dart reads it with `String.fromEnvironment`, passed by `--dart-define-from-file=env/prod.json`
  (the build scripts do; for a debug run, add it to `flutter run`).
- Android's Gradle reads it into the manifest (`app/android/app/build.gradle.kts`), in every
  build.
- An Xcode build phase ("Set AdMob app id") writes the iOS app id into the built `Info.plist`, in
  every build.

Until a real ID is in, it holds a named `PLACEHOLDER_…`. `melos run build-ios` / `build-android`
refuse to build while one is left (`scripts/check_release_ids.sh`); the test builds
(`build-ios-test`, `build-android-test`) only warn.

| Key in `app/env/prod.json` | Status | Used for / where it comes from |
|---|---|---|
| `ADMOB_APP_ID_IOS` | ✅ done | AdMob iOS **App ID**, every build (Xcode build phase → `GADApplicationIdentifier`) |
| `ADMOB_APP_ID_ANDROID` | ✅ done | AdMob Android **App ID**, every build (Gradle → `com.google.android.gms.ads.APPLICATION_ID`) |
| `ADMOB_REWARDED_IOS` | ✅ done | iOS `revive` unit, release builds only |
| `ADMOB_INTERSTITIAL_IOS` | ✅ done | iOS `run_end` unit, release builds only |
| `ADMOB_REWARDED_ANDROID` | ✅ done | Android `revive` unit, release builds only |
| `ADMOB_INTERSTITIAL_ANDROID` | ✅ done | Android `run_end` unit, release builds only |
| `ADMOB_TEST_DEVICE_IDS` | ⏳ empty | Your phones, comma separated, so a release build serves you test ads (see below) |
| `IAP_REMOVE_ADS` | ✅ done | `blockmancer.remove_ads`, both stores |
| `GAME_CENTER_LEADERBOARD_DAILY` | ✅ done | `blockmancer.daily_run` |
| `GAME_CENTER_LEADERBOARD_BEST` | ✅ done | `blockmancer.best_run` |
| `APP_STORE_ID` | ✅ done | `6823742423`, the app's **Apple ID**: the update screen's store link and Rate Blockmancer |
| `PLAY_GAMES_APP_ID` | ✅ done | `363871737582`, the Play Games Services project id; Gradle → the manifest's `com.google.android.gms.games.APP_ID` |
| `PLAY_LEADERBOARD_DAILY` | ✅ done | `CgkI7q3Iw8sKEAIQAw`, the Daily run leaderboard |
| `PLAY_LEADERBOARD_BEST` | ✅ done | `CgkI7q3Iw8sKEAIQBA`, the Best run leaderboard |

Debug and test builds always play Google's test ad units, never these.

**Every id is in.** Still optional: your test devices.

### Your phones as AdMob test devices

So a release build on your own phone never serves you live ads (AdMob forbids clicking your own):

1. Run a release build on the phone (`flutter run --release --dart-define-from-file=env/prod.json`
   from `app/`), and request an ad (lose a round: the revive loads one).
2. Copy the id from the log — Android: "Use RequestConfiguration.Builder().setTestDeviceIds(
   Arrays.asList("33BE2250B43518CCDA7DE426D04EE231"))"; iOS: "GADMobileAds.sharedInstance
   .requestConfiguration.testDeviceIdentifiers = @[ @"2077ef9a63d2b398840261c8221a0c9b" ]".
3. Add it to `ADMOB_TEST_DEVICE_IDS` (comma separated) and send it to me, or simply commit it.
4. Also in AdMob → **Settings → Test devices → Add test device** (name, platform, the same id):
   that covers builds made before the id was in the file.

## The studio site ✅

Live at **studio.elietabet.com**: `/privacy` (leads to `/blockmancer/privacy`, the privacy policy,
also given to both stores and the consent form), `/support` and `/app-ads.txt`.

⚠️ Settings' **Legal notice** still opens `/legal`, which the site no longer has (404): remove the
row from the app, or put the page back on the site.

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

### 4. Remote Config ✅

Every number a run plays with, and the update versions, can change from the console without a
release.

- **The keys:** [`docs/remote-config/keys.md`](remote-config/keys.md) — name, type, default,
  allowed range, what it changes (68 keys). A value outside its range, or not a number, is
  ignored and the default plays.
- **One parameter per number, never one JSON value.** The run's config is not published as a
  whole: each number is its own parameter, read and checked on its own (`game_domain`'s
  `run_tuning.dart`). A malformed, out-of-range or missing value plays the in-app default for
  that number alone, and every other published number still plays. An app version only asks for
  the keys it knows, so parameters added for a later version are never read by an older one.
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

How the app reads them:
- **While the app is open, live:** a published change arrives within seconds, through Remote
  Config's real-time listener, and is applied at once. The map's and the Spellbook's numbers
  update on screen.
- **Fetched** at launch and on every return to the app, at most every 12 hours (every 5 minutes
  in a test build); within that limit the fetch answers with the values already held.
- **A run reads them as it starts**, so a change reaches the next run, never one in progress.
- **The update check** waits up to 2 seconds for the launch's fetch, then decides again at every
  change.
- **Cost:** fetch requests are free up to 100,000 a day, then $0.06 per 10,000. A player makes
  at most 2 a day (the 12-hour limit), plus 1 per change published while their app is open; the
  live connection itself is no request. So free up to about 50,000 players a day, about $0.60 a
  day at 100,000. Keep the 12-hour limit in release builds; a test build's 5 minutes is up to
  about 300 a day per tester.

#### How to add a world's config

A new world (a `WorldId` value with its config in the engine, `isPlayable` true):

1. **Nothing to write for its boss and third star.** `boss_target_<world>` and `star3_<world>`
   come with the world, defaulting to what its run plays in the app (`configFor`).
2. **Its rule's own numbers** (as `tide_boss_gaps` or `fog_boss_cells`): one entry each in
   `_keys` in `packages/features/game/domain/lib/src/entities/run_tuning.dart`, with
   `world: .<world>` so it tunes that world's run alone, an allowed range, and a description.
   The default is always read from the run, never written in the entry.
3. **Regenerate the template and the table:**
   `cd packages/composition/app_providers && dart run tool/remote_config_template.dart` (a test
   fails until it is run). Commit `docs/remote-config/`.
4. **In the console**, only to change a value: **Add parameter** with the key's name, type
   Number and the default from `keys.md`. Nothing has to be published for the world to play:
   with no value, the app plays its own default. Don't re-publish `template.json` over a live
   template to add keys; it puts back every edited value.

Older app versions never ask for the new keys, so they ignore them. Never rename a key, reuse an
old one or change what it means: versions already shipped keep reading it as they did.

**Kill switch:** set `min_version_ios` / `min_version_android` above a broken version (e.g.
`1.0.1` to stop 1.0.0) and publish: that version shows "Update required" with a store button, in
place of everything and with no way back. `latest_version_*` shows a dismissible banner on the
map instead, once per version. All four default to `0.0.0`, which asks nothing.

When a player sees it:
- **App open:** within seconds (the live listener). Mid-run, once the move being played has
  played out and been saved; the run resumes after the update.
- **App closed:** at the next launch, on the splash, if the launch's fetch lands within 2
  seconds; otherwise as soon as it does.
- **App in the background:** on return. The return's fetch obeys the 12-hour limit, so within
  it the app keeps the values it held, and the change comes from the live listener as it
  reconnects, or at the latest from the first fetch past the limit.

## AdMob

### 1. Apps and ad units ✅

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

### 3. app-ads.txt ✅

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

The app's **Apple ID** is in (`APP_STORE_ID`, 6823742423).

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

### In-app purchase: Remove ads ✅

App Store Connect → the app → **Monetization → In-App Purchases** → **+**:

- Type: **Non-Consumable**
- Reference name: `Remove ads`
- Product ID: **`blockmancer.remove_ads`** ✅ (exactly; the app asks for this id)
- Price: **$3.99** (Price Schedule → United States, $3.99; other countries follow Apple's tiers)
- Localizations: English "Remove ads" / "No more ads between runs, and revive without watching
  a video. For good."; French "Supprimer les pubs" / "Plus de pubs entre les parties, et revivre
  sans regarder de vidéo. Pour de bon."
- Review screenshot: Settings with the **Remove ads** row (any test build)
- Review notes: "Settings → Remove ads buys it; Settings → Restore purchases restores it. It
  removes the interstitial between runs, and a revive no longer asks for a rewarded ad (the
  number of revives per run is unchanged)."
- Then add it to the app version's **In-App Purchases** section before submitting the build.

To test: App Store Connect → **Users and Access → Sandbox → Testers** → add a tester; on the
iPhone, Settings → App Store → Sandbox Account → sign in; buy and restore from a TestFlight build.

### Rating prompt ✅

Nothing to set up: the app asks StoreKit for its own prompt (`review_cooldown_days`, 60, in Remote
Config). To see it: **TestFlight never shows it** (Apple); run a build from Xcode on a device
(`flutter run --release` from `app/`), where it always shows, but submits nothing. Settings →
**Rate Blockmancer** opens the App Store page (needs `APP_STORE_ID`).

### Game Center: the two leaderboards ✅

The code submits every run's total to **`blockmancer.best_run`** and each daily run's to
**`blockmancer.daily_run`** too, and the daily card's **Leaderboard** opens the daily one. The
player is signed in once the consent form has gone; a refusal only leaves the boards empty.

1. **Capability.** The Game Center entitlement is committed (`Runner.entitlements`). Xcode →
   Runner → **Signing & Capabilities** should list **Game Center**; with automatic signing the
   App ID and profiles pick it up at the next build. (Explicit App IDs have Game Center on by
   default.)
2. App Store Connect → the app → **Game Center** (sidebar) → enable it, then **Leaderboards → +**:

   | | Daily run | Best run |
   |---|---|---|
   | Type | **Recurring** | **Classic** |
   | Reference name | Daily run | Best run |
   | Leaderboard ID | **`blockmancer.daily_run`** ✅ | **`blockmancer.best_run`** ✅ |
   | Score format type | Integer | Integer |
   | Score submission type | Best score | Best score |
   | Sort order | High to low | High to low |
   | Score range | (leave empty) | (leave empty) |
   | Recurrence | Starts at **00:00 UTC** (any coming day), duration **1 day**, restarts every **1 day** | — |

   For each, **Localization → +**: English — name "Daily run" / "Best run", score format
   "Integer", suffix " points" (" point" for one); French — "Partie du jour" / "Meilleure
   partie", suffix " points". An image is optional.
3. On the **version** page (App Store tab → the 1.0 version), tick **Game Center** and add both
   leaderboards, or they won't go live with the app.

**To test:** a development or TestFlight build uses Game Center's sandbox: Settings → Game Center
→ sign in, then play a daily run to its end; the Leaderboard button shows the score (scores can
take a minute to appear). Leaderboards don't need review to show in the sandbox.

### Daily reminder ✅

Nothing to set up: it is a local notification, scheduled on the phone, with no server and no
capability (the push entitlement already covers asking for notifications). To see it: play a
daily run to its end, allow notifications, then set the phone's clock to 17:59 (Settings →
General → Date & Time) and lock it.

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

### In-app product: Remove ads ✅

Play Console → the app → **Monetize with Play → Products → One-time products** → **Create
one-time product**. The page asks for the `BILLING` permission until a build that has it is
uploaded to a track: 1.0.0+4 is the first.

- Product ID: **`blockmancer.remove_ads`** ✅ (exactly); purchase option ID: **`buy`**
- Name / description: as in App Store Connect, in English and French
- Default price: **USD 3.99** → **Update exchange rates** for the other countries
- **Activate** it. (Play only lists products once the app has a build with the BILLING permission
  uploaded to a track: upload a test build to internal testing first; `in_app_purchase` adds the
  permission.)

To test (not done yet): Play Console → **Settings → License testing** → add the testers' Google
accounts; install the build from the internal testing track (not a sideloaded APK) and buy: test
cards are offered.

### Rating prompt ✅

Nothing to set up. Play shows its in-app review only for an app installed from Play: install the
internal testing build from the Play Store app, on an account that hasn't reviewed it (Play's
quota hides it otherwise; internal app sharing shows it every time, with a placeholder submit).

### Play Games Services: the project and the two leaderboards

Play has no board that resets at a chosen hour: every Play leaderboard keeps its own daily,
weekly and all-time views, its day ending at midnight Pacific time. So the daily run gets a board
of its own, opened on its **daily** view, and the best run another, opened on all time. The day
boundary differs from the run's (00:00 UTC) by 7–8 hours: logged in `docs/decisions.md`.

The project id and both leaderboard ids are in `prod.json` ✅. (Had one been a placeholder, Android
would play without leaderboards: the code switches them off.)

1. Play Console → the app → **Grow users → Play Games Services → Setup and management →
   Configuration** → **Create new Play Games Services project** → **Use an existing Google
   Cloud project: blockmancer-a153f** (the Firebase project's).
2. The **project id** is in: `PLAY_GAMES_APP_ID` = 363871737582 ✅.
3. **Credentials → Add credential → Android**:
   - Configure the **OAuth consent screen** if asked (Google Cloud → APIs & Services → OAuth
     consent screen: External, app name Blockmancer, support email, publish it).
   - Create the **Android OAuth client**: package **com.elietabet.blockmancer**, SHA-1 of the
     **app signing key** (Play Console → Test and release → **App integrity → App signing** →
     App signing key certificate). Add a second credential with the **upload key**'s SHA-1 (same
     page) so internal-sharing builds sign in, and a third with the debug keystore's
     (`keytool -list -v -keystore ~/.android/debug.keystore -storepass android`) for
     `flutter run`.
4. **Leaderboards → Create leaderboard**, twice:

   | | Daily run | Best run |
   |---|---|---|
   | Name | Daily run (FR: Partie du jour) | Best run (FR: Meilleure partie) |
   | Score formatting | **Numeric**, 0 decimal places | **Numeric**, 0 decimal places |
   | Ordering | **Larger is better** | **Larger is better** |
   | Limits | (none) | (none) |

   Done: `PLAY_LEADERBOARD_DAILY` = `CgkI7q3Iw8sKEAIQAw`, `PLAY_LEADERBOARD_BEST` = `CgkI7q3Iw8sKEAIQBA` ✅.
5. **Testers** → add your Google accounts (needed while the Games project is unpublished), then
   **Review and publish** the Games project once the app goes live.

**To test:** an internal-testing build (or `flutter run` with the debug SHA-1 registered), signed
in to Play Games with a tester account; play a daily run to its end, then tap **Leaderboard**.

### Daily reminder

Nothing to set up in the console: a local notification, scheduled on the phone. The app asks for
`RECEIVE_BOOT_COMPLETED` (to schedule it again after a restart) and no exact-alarm permission, so
the Data safety form and the permissions declaration don't change. To see it: play a daily run to
its end, allow notifications, set the clock to 17:59 and lock the phone; Android may deliver it a
few minutes late (battery saving).
