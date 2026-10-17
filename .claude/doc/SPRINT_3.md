# Blockmancer — Sprint 3 (weeks 5 and 6, about 40 h) — ends phase 1

Read `BLOCKMANCER_BRIEF.md` first; its rules and working agreement still apply.
`docs/reference/blockmancer_reference.html` stays the behavioural reference for rules.

**Goal:** make the game feel good in a stranger's hands, then run the hallway test that decides whether phase 2 starts.
Still out of scope: world map, ads, purchases, leaderboards, notifications, Firebase.

Stop after each task, run analyze and tests, and report what changed.

---

## Task 1 — Tune the round targets

- Move every tunable number into one immutable `RunConfig` (round targets, pieces per round, boss stones,
  joker constants such as Patience +2, Twin ×3, Saver +40). Nothing tunable stays hard-coded in jokers or rounds.
- Apply the targets agreed from the balance bot table (they will be provided; until then keep the current values).
- Re-run the bot and commit its output to `docs/balance/<date>.md`.

**Done when** the bot reads `RunConfig`, and changing a value there changes the bot output with no other edit.
This `RunConfig` is what Firebase Remote Config will feed in phase 3.

## Task 2 — Juice (animations)

Drive everything from the engine's events; never recompute rules in the UI. Queue events and play them in order;
input stays locked until the queue is empty, with a "skip" on tap after 300 ms for impatient players.

- **Place:** the piece snaps into its cells with a short squash (about 120 ms).
- **Clear:** cleared cells flash white, then burst into small particles in their colour (about 350 ms).
- **Score count-up, Balatro style:** chips count up, then mult, then the product appears and flies into the round
  score. Each joker that fired pulses in the joker bar, in the order the engine applied it.
- **Combo:** "Combo ×N" pops near the board on streaks of 3 or more.
- **Big moments:** a light screen shake on 2+ lines, a stronger one on boss win. Disabled when reduce motion is on.
- Respect the platform's reduce-motion setting (`MediaQuery.disableAnimations`) and an in-app toggle.

**Done when** a full run plays at a steady 60 fps in profile mode on a mid-range Android phone, and a widget test
checks that input is locked while the event queue plays.

## Task 3 — Haptics and sound

- Haptics: light on place, medium on clear, heavy on combo ≥ 3 and on round win.
- Sounds: place, clear (pitch rising with the streak), joker fire, round won, round lost, button tap.
  Use a CC0 sound pack (for example Kenney's) and record each file's source and licence in `assets/sounds/LICENSES.md`.
- **Ask before adding the audio dependency**; latency matters, so justify the choice in one paragraph.
- Separate on/off switches for sound and haptics, persisted.

**Done when** sounds play with no audible delay on both platforms and both switches survive a restart.

## Task 4 — First-run tutorial

- Shown once (persisted flag), skippable at any step, replayable from Settings.
- Run 0 is a guided practice: a fixed tiny seed, no starting joker.
  1. "Drag a piece onto the board" (highlight a legal spot).
  2. "Fill a row to clear it" (a board prepared so one placement clears a line).
  3. "Chips × mult = score" (pause on the count-up with a short label).
  4. "Pick your first joker — they work in pairs" (the real starting pick).
- Then the normal run starts.

**Done when** a fresh install lands in the tutorial, and a second launch does not.

## Task 5 — App icon and launch screen

- Use `assets/brand/blockmancer_logo_1024.png` (transparent) on the primary colour `#14172B`.
- Generate the icons and native splash with the project's existing `flutter_launcher_icons` and
  `flutter_native_splash` setup. Check the Android adaptive icon keeps the mascot inside the safe zone.

**Done when** the icon reads clearly on both home screens and the splash shows no white flash.

## Task 6 — Settings and localisation

- Settings: sound, haptics, reduce motion, language (system / English / French), replay tutorial, reset progress
  (with confirmation).
- Every user-facing string goes through slang, in English and French. Joker names and effects included.
  French copy should read naturally, not word for word.

**Done when** switching the language changes every screen with no hard-coded string left (add a test or a lint
that fails on raw string literals in widgets, if the project has one).

## Task 7 — Internal test builds

- iOS: build uploaded to TestFlight, internal testers only.
- Android: build on Play Console internal testing.
- Version shown in Settings; a "Send feedback" row opening an email to `support@elietabet.com` with the version and
  device prefilled.

**Done when** two other people can install the build from each store's internal channel.

## Task 8 — Hallway test (the gate)

Not code: a protocol to run once tasks 1–7 are done.

- 5 to 10 people who have not seen the game. Hand them the phone, say only "It's a puzzle game, try it."
- Watch for 10 minutes without helping. Note where they hesitate, what they say out loud, whether they read the
  jokers.
- **The key signal:** after their first run ends, do they start a second one on their own?
- Record each session in `docs/playtest-notes.md`: who (first name only), run length, second run yes/no,
  quotes, confusion points.

**Gate:** 6 of 10 (or the same share of fewer) start a second run unprompted → phase 2 (world map, worlds, more
jokers). Below that → fix the top confusion points and test again before adding features.
