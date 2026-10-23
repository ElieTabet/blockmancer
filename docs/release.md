# Release checklist — Blockmancer 1.0

Everything between a green `main` and 1.0 in both stores, in order. Each console step's detail
(where to click, the exact values) is in [`console-setup.md`](console-setup.md); the store texts
are in [`store-listing.md`](store-listing.md). Tick a box once it is done.

## 1. Blockers

- [x] **Legal notice:** Settings' **Legal notice** opens `studio.elietabet.com/legal`. The page
  is live (`elietabet-studio-site`, `legal/` and `fr/legal/`).

## 2. Before building

- [x] `main` green: `melos run analyze` and `melos run test`.
- [x] No placeholder left in `app/env/prod.json` (the release builds refuse to build otherwise:
  `scripts/check_release_ids.sh`). Optional: your phones in `ADMOB_TEST_DEVICE_IDS`, so a release
  build serves you test ads instead of real ones.
- [x] **Remote Config** published with every key in `docs/remote-config/keys.md` (75 today).
  Publishing `template.json` over a live template puts back every value edited in the console:
  add new keys by hand instead (console-setup.md, Remote Config).
- [x] `min_version_ios` / `min_version_android` at `0.0.0` (they block every version below them).
- [x] The studio site's pages live: `/privacy`, `/support` and `/app-ads.txt`.
- [x] Testers who had a build from before the varied daily reminders (1.0.0+3 and earlier):
  uninstall and reinstall once, or they get two reminders every evening.

## 3. Build 1.0.0

- [ ] `melos run build` → both platforms, **release**, version `1.0.0+<next build>`, then commit
  the version bump in `app/pubspec.yaml`. It is exactly `melos run build-android` and
  `build-ios`: cleaned, obfuscated, `TEST_TOOLS` off, real ad units, Dart symbols uploaded to
  Crashlytics (iOS dSYMs go up from Xcode's build phase). Artefacts land in `build/outputs/`.
- [ ] Keep `build/debug-info/<platform>/<version>`: Crashlytics needs it to read that version's
  stack traces.
- [ ] Android: `app/android/key.properties` holds the upload key (without it Gradle signs with the
  debug key, which Play refuses).

## 4. Play Console

- [ ] **App content:** Data safety, Ads ("contains ads": yes), advertising ID, content rating
  questionnaire, target audience, privacy policy URL (`https://studio.elietabet.com/privacy`).
  Answers in console-setup.md, Play Console. For the target audience, ages 13 and up keep the app
  out of Play's Families policy, which the ad setup isn't made for (the ads aren't tagged as
  child-directed).
- [ ] **Store listing**, English (United States) and French (France): app name, short and full
  description (store-listing.md), the icon (512×512), the feature graphic (1024×500), at least 2
  phone screenshots, category **Games → Puzzle**, contact email `support@elietabet.com`, website
  `https://studio.elietabet.com`.
- [ ] Remove ads (`blockmancer.remove_ads`) **active**, its name and description in both
  languages.
- [ ] Play Games Services project **published** (Review and publish), with both leaderboards.
- [ ] Upload the `.aab` to **internal testing** and read Play's **pre-launch report**; fix what it
  flags.
- [ ] From the internal testing build, on a license tester account: one sandbox purchase, then a
  reinstall and Restore purchases.

## 5. App Store Connect

- [ ] **App Privacy** answers (console-setup.md, App Store Connect), and the tracking question:
  the app asks it (ATT, through AdMob's IDFA explainer).
- [ ] **Age rating** questionnaire; **App Information:** category **Games → Puzzle** (secondary
  **Strategy**), privacy policy URL, the name "Blockmancer: Puzzle Roguelite".
- [ ] **Version 1.0:** subtitle, promotional text, description, keywords (store-listing.md) in
  English (U.S.) and French; support URL `https://studio.elietabet.com/support`; screenshots in
  the sizes App Store Connect asks for: iPhone 6.9" (or 6.7") and 6.5", and **iPad 13"**, since
  the app runs on iPad too (Xcode's device family is iPhone and iPad; making it iPhone-only would
  drop the iPad screenshots).
- [ ] Remove ads ready to submit **with the version** (its review screenshot and notes), Game
  Center enabled on the version with both leaderboards.
- [ ] **Small Business Program** joined (15% commission instead of 30%).
- [ ] Upload the `.ipa` (Transporter or Xcode's Organizer), pick the build, then on TestFlight:
  one sandbox purchase, then a reinstall and Restore purchases.
- [ ] **Phased release for automatic updates:** on.

## 6. Both stores, once

- [ ] Tax and bank details (App Store Connect → Business; Play Console → Payments profile); AdMob's
  payment profile.
- [ ] **EU trader status** (Digital Services Act): trader, with the address and phone the stores
  show publicly.

## 7. Before submitting

- [ ] 10 full runs on a real iPhone and a real Android phone, the release builds: a world run to
  its boss, a daily run, a revive with an ad, the interstitial after the 3rd finished run, the
  rating prompt after a boss win (TestFlight never shows it on iOS: check it with
  `flutter run --release`).
- [ ] The daily reminder: a run played to its end, notifications allowed, then the clock set to
  17:59 and the phone locked: it arrives (with a banner on Android), and a tap opens Home on the
  daily card, from a closed app and from the background.
- [ ] Leaderboards: on Android with no Google account, no sign-in screen at launch or after a run,
  only on **Leaderboard**; signed in, a daily run's score reaches the board. Game Center the same
  on iOS.
- [ ] The consent form in the EEA (a test build with `UMP_DEBUG_EEA`, console-setup.md, AdMob).

## 8. Launch

- [ ] **iOS:** submit for review; once approved, release with the 7-day phased release.
- [ ] **Android:** promote the internal testing build to **production** as a **staged rollout at
  20%**.
- [ ] Watch Crashlytics every day. Raise Android 20% → 50% → 100% over the week while it stays
  clean; pause the rollout (and the phased release) if it isn't.
- [ ] **No marketing for 2 weeks.** Read D1 and D7 retention, and tune through Remote Config.

## If a version is broken

- **Kill switch:** Remote Config → `min_version_ios` / `min_version_android` above the broken
  version (e.g. `1.0.1` to stop 1.0.0) → Publish. That version shows "Update required" from its
  next launch, or as soon as the value reaches an open app.
- Halt the Play rollout and pause the App Store phased release, ship the fix, then lower nothing:
  the minimum stays where it is.
