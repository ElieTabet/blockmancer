# Blockmancer — Sprint 8 (phase 3: services, monetization, launch)

Read `BLOCKMANCER_BRIEF.md` first; its rules and working agreement still apply.

**Decision:** no soft launch. iOS and Android launch together: Apple's 7-day phased release and a Google Play staged
rollout starting at 20% (the Play account has no closed-testing requirement). The launch itself is the test: no marketing for the first 2 weeks, watch Crashlytics and D1/D7, tune through
Remote Config.

Every service sits behind an interface in the kit (as the plan's architecture says), so the next game reuses it.
**Ask before adding each dependency** (expected: firebase_* packages, google_mobile_ads, in_app_purchase,
in_app_review, games_services); check each package's current docs before using its API.

Everything in this sprint ships in 1.0; nothing is deferred to 1.1.

**Console setup guide (deliverable of every task).** Keep `docs/console-setup.md` up to date as you go: everything
I must do by hand outside the code, in order, so I can follow it step by step. For each item: the console (Firebase,
AdMob, App Store Connect, Play Console, Google Cloud), where to click, the exact values to enter, and which ID to
send back to you. At minimum:
- **Firebase:** apps registered (bundle ids), config files and where they go, Analytics settings (data retention,
  Google signals off unless needed), Crashlytics enabled, Remote Config: **a table of every key** (name, type,
  default, allowed range, what it changes) plus a template JSON you generated from `RunConfig` defaults; say how to
  publish it (check the current Firebase docs: console import or REST/CLI) and keep in-app defaults identical.
- **AdMob:** the app on both platforms, the ad units to create (rewarded revive, interstitial) with their names,
  the UMP/Privacy & messaging setup (GDPR message, IDFA explainer for iOS), `app-ads.txt` content and where to host it
  (`studio.elietabet.com`), and payment/tax profile.
- **App Store Connect:** the in-app purchase (product id, type non-consumable, price tier, review screenshot and
  notes), Game Center leaderboards (ids, sort order, score format, daily recurrence), App Privacy answers matching
  what the SDKs collect, the tracking (ATT) usage string.
- **Play Console:** the in-app product, Play Games Services project and leaderboards (ids), Data safety answers,
  ads declaration, upload key and Play App Signing.
- **Placeholders:** until I send the real IDs, put clearly named placeholders in one config file (never scattered),
  and list in the guide which placeholder each ID replaces. Release builds must fail to build if a placeholder is left.

---

## Task 1 — Firebase core

- `FirebaseAnalyticsSink` behind the existing `AnalyticsSink`; Crashlytics with Flutter and platform error handlers.
- **Remote Config feeds `RunConfig`:** the bundled defaults are the current tuned values; fetch with a sensible
  minimum interval; a fetched config applies to the **next** run, never mid-run. Bad or missing values fall back to
  the defaults (test it).
- **Force and optional updates:** keys `min_version_ios` / `min_version_android` and `latest_version_ios` /
  `latest_version_android`, default `0.0.0`, compared with `pub_semver`. Below min → blocking screen with a store
  button; below latest → dismissible banner on the map, once per version.
- **Test tools flag:** `TEST_TOOLS` (`const bool.fromEnvironment`, default false), true only in test build scripts.
  Test builds: `CompositeSink([FirebaseAnalyticsSink, LocalStatsSink])` and the "Share test stats" row.
  Release: Firebase only, the row hidden, local stats data deleted once. Document the flag in CLAUDE.md.

**Done when** tests cover the Remote Config fallback, the version comparisons (equal, older, newer, malformed), and
the flag; Crashlytics receives a test crash from a test build.

## Task 2 — Consent and privacy

- Google UMP consent form before any ad request (required in the EEA and UK); Analytics consent mode set from it.
- iOS App Tracking Transparency: shown after the UMP form (UMP can present its explainer first). If declined,
  ads stay non-personalised.
- Settings → "Privacy choices" reopens the consent form (required when consent applies).
- Settings → links to the privacy policy and support on `studio.elietabet.com`.

**Done when** a fresh install in an EEA region shows the consent form before any ad loads (test with UMP's debug
geography), and declining still lets the game play normally.

## Task 3 — Ads

- AdMob, behind kit interfaces. Test ad unit ids in debug and `TEST_TOOLS` builds, real ids only in release.
- **Rewarded revive:** the existing `RewardedAction` gets an AdMob implementation. If no ad is available, the revive
  button says so and is disabled; never a dead tap.
- **Interstitial between runs only**, never mid-run, never in the tutorial or the player's first session.
  Remote Config caps: not before the 3rd completed run, at most every 2nd run end, at least 90 s apart.
- Ads preloaded so the run-end screen never waits on the network.
- Analytics events: `ad_shown(type)`, `ad_reward_earned`, `ad_failed(type, code)`.

**Done when** tests cover the interstitial caps and the no-ad revive state, and both ad types show with test ids on
both platforms.

## Task 4 — Remove ads purchase

- One non-consumable: **Remove ads**, $3.99 (price set in the stores). It removes interstitials permanently, and
  with it the revive is granted without an ad: same revive limit per run as everyone, just no video. The lost
  sheet shows "Revive" (no ad icon) instead of "Watch an ad to revive".
- Settings → "Remove ads" and "Restore purchases" (Apple requires restore).
- Entitlement stored locally and re-checked from the store on launch; restored on reinstall.
- Analytics events: `purchase_started`, `purchase_completed`, `purchase_restored`, `purchase_failed`.
- Use `in_app_purchase` directly (one non-consumable doesn't need RevenueCat); keep it behind a `Purchases`
  interface so RevenueCat can replace it later.

**Done when** a sandbox purchase and a restore work on both platforms, and a test proves no interstitial is shown
with the entitlement.

## Task 5 — Rating prompt

Use the platform's own in-app review API (`in_app_review`: StoreKit on iOS, Play In-App Review on Android).

- **When to ask** (all must be true): just after a boss win or a newly earned star, on the run-end screen, after the
  celebration finishes; at least 3 completed runs and 2 different days since install; no crash in this session;
  not asked in the last 60 days (Remote Config). Ask at most once per app version.
- **Never:** after a loss, during a run, in the tutorial, or with a custom "Do you like the game?" pre-prompt that
  routes unhappy players elsewhere (review gating; Google forbids it).
- The OS decides whether the dialog actually appears (Apple shows it at most 3 times a year), so the app only
  records that it asked: event `review_prompt_requested`.
- Settings → "Rate Blockmancer" opens the store page directly (always allowed).

**Done when** tests cover every condition above (eligible, too early, after a loss, already asked this version,
60-day cooldown), and the prompt appears on a device in a test build.

## Task 6 — Daily run leaderboard

- `games_services` behind a `Leaderboards` interface: Game Center on iOS, Play Games on Android.
- One daily leaderboard (resets daily, set up in App Store Connect and Play Console) and one all-time best run.
- Submit the score at the end of a daily run; "Leaderboard" button on the daily run card. Sign-in failure never
  blocks play.

**Done when** a score submitted from a test build appears on both platforms' leaderboards.

## Task 7 — Daily reminder and streak

- Local notification "Today's daily run is ready", once a day at a fixed local time, only after the player has
  played at least once; off switch in Settings; permission asked after the first daily run, never at first launch.
- Streak: days in a row with a daily run, shown on the daily run card.

**Done when** tests cover the reminder scheduling (not before the first daily run, cancelled when switched off, rescheduled after a time-zone change) and the streak (continues, breaks after a missed UTC day), and the notification appears on both platforms.

## Task 8 — Store listing and release (mostly human)

Agent:
- Release builds for both stores, version 1.0.0, test ids and `TEST_TOOLS` off; a release checklist in
  `docs/release.md` listing everything below.
- Store texts in English and French: subtitle, description, keywords (no "Block Blast" or "Balatro").

You:
- **Google Play:** Data safety form, content rating, "contains ads", target audience, store listing. Push the build
  through internal testing first to catch Play's pre-launch report warnings, then production.
- **App Store Connect:** app privacy labels, age rating, "contains ads" / tracking answers, screenshots (6.7" and
  6.5" iPhone at least), Small Business Program (15% instead of 30%), phased release on.
- **Both stores:** tax and bank details; EU trader status (DSA: address and phone shown publicly); the privacy policy
  live on `studio.elietabet.com` before submitting.
- **Before submitting:** play 10 full runs yourself on a real iPhone and a real Android phone, including one purchase
  and one restore in sandbox.

**Launch rules:** iOS phased release over 7 days; Android staged rollout starting at 20%, raised once Crashlytics
is clean (e.g. 20% → 50% → 100% over a week). No marketing for 2 weeks. Kill switch: raise `min_version_*` in Remote Config if a version is broken.
