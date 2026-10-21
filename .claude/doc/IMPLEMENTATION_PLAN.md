# Blockmancer — Implementation Plan

Oct 16, 2026 · @Elie

## Start here: decisions and first steps

Coding starts with the project generator and the pure-Dart engine; store accounts, Firebase and the website run in parallel and never block Sprint 1.

| Item | Decision |
| --- | --- |
| Game name | Blockmancer; App Store title "Blockmancer: Puzzle Roguelite" (the bare name is reserved) |
| Bundle id | `com.elietabet.blockmancer`; iOS App ID registered with Game Center and Push Notifications |
| Dart package prefix | `blockmancer` |
| Pricing | Free, earning through ads and in-app purchases (free is permanent on Google Play) |
| Backend and login | None for the MVP: Firebase only, force update through Remote Config, players open straight into the game |
| Notifications | Local notifications for the daily run and streaks; FCM topics for campaigns; token storage only if a personal campaign needs it |
| Website | `studio.elietabet.com` for every game: studio home, `/blockmancer` (game page), `/privacy`, `/support`, `/legal` (legal notice), and one `app-ads.txt` at its root for all games |
| Logo and brand | Cube mascot with combo burst (transparent 1024 px PNG); primary `#14172B`, accent `#FFB547`; DM Sans, Fredoka for titles |

**First steps, in order**

1. Check "Blockmancer" in the EUIPO and USPTO trademark databases before investing more in the brand.
2. Create the Firebase project (EU location), add the iOS and Android apps with the bundle id, download both config files, upload the APNs .p8 key.
3. Run the generator: Backend off, Login off, Firebase on, English and French, notification channel "Daily run", tests on.
4. Add `packages/blockmancer_engine` (pure Dart) with an `import_lint` rule that forbids Flutter imports in it.
5. Start Sprint 1 (last section).

**In parallel**

- [ ] Google Play Console account
- [ ] Legal status for the income (ask an accountant; micro-entreprise is the usual option) and a business address for the stores' public contact details
- [ ] Read the side-activity and IP clauses of your employment contract
- [ ] Register `elietabet.com`, point `studio.elietabet.com` at Firebase Hosting, publish the privacy page before the first TestFlight or closed test

## Goal and scope

Ship a free-to-play Blockmancer MVP to an Android soft launch in about 20 weeks (about 400 hours at 20 h/week), then launch globally on iOS and Android if retention clears the bar.

**In the MVP**

- Core loop: 8×8 board, 3-piece tray, drag and drop with shadow and red collision preview, line clears scored as chips × mult
- Runs: a starting joker, 4 rounds and a boss, one joker pick after each round
- 26 jokers in 13 pairs
- World map with all 5 worlds (Rubble, Gravity, Fog, Tide, Mirror), 3 stars per world, joker unlocks
- Daily run: the same seed for everyone, ranked on a daily leaderboard
- Game Center and Google Play Games: leaderboards and achievements
- Monetization: rewarded revive, interstitial between runs, remove-ads and world-pack purchases
- Languages: English and French

**After the MVP** (live updates): new worlds with 2 jokers each, weekly leagues, cloud save, more languages, server-side score verification.

**Success:** soft-launch D1 retention of 35% or more and D7 of 10% or more, the kill-or-scale rule set at the start of the project.

## Phases and timeline

At 20 h/week the MVP reaches an Android soft launch in about 20 weeks (all 5 worlds ship at launch); global launch follows only if retention clears the bar.

&#91;embedded content: roadmap · 5 phases, 4 gates\]

Each gate is a go or no-go: if the hallway test or the soft-launch retention fails, stop before paying for the next phase.

## Architecture

One Melos monorepo, Clean Architecture boundaries enforced with `import_lint`: the app shell routes, features present, the engine decides, the kit talks to the platform.

&#91;embedded content: architecture · Melos monorepo, 4 layers\]

Features call the engine for every rule and the kit interfaces for every service; only the bottom box knows about Firebase, AdMob or the stores, so the next game reuses the kit unchanged.

## Core game engine (pure Dart)

All game rules live in one pure Dart package, `blockmancer_engine`, with no Flutter import. It is the domain layer: fully unit-tested, reusable by a headless balancing bot, and identical on iOS, Android and web.

- **State is immutable.** `RunState` holds the board, tray, remaining pieces, round, score, streak, stored mult and owned jokers. Every action returns a new state plus a list of events.
- **One entry point per action.** `place(state, trayIndex, cell)`, `pickJoker(state, jokerId)`, `revive(state)`. Each returns `(RunState, List<GameEvent>)`.
- **Events drive the UI.** `PiecePlaced`, `LinesCleared(rows, cols, cells)`, `JokerFired(id, effect)`, `ScoreAdded(chips, mult, total)`, `RoundWon`, `RunLost`. The presentation layer animates events; it never recomputes rules.
- **Scoring pipeline.** Chips and mult start from the clear, then joker effects apply in two passes: additive first (Combo, Patience, Precision, Collector), multiplicative second (Twin, Column, Heavyweight). Each joker is a small class implementing `JokerEffect`, so adding one never touches the others.
- **Seeded randomness.** Use our own PRNG (mulberry32, as in the prototype) instead of `dart:math` `Random`, so a daily seed deals exactly the same pieces on every platform. The seed is derived from the UTC date.
- **World rules as modifiers.** A boss rule (stones, gravity, fog, timer, mirror) is a `WorldRule` that hooks into setup, placement or piece generation. Gravity, for example, transforms the target cell before `place` validates it.
- **Run flow as a state machine.** Starting joker → round 1 to 4 → joker pick after each → boss → run end, with revive as a side transition.
- **Tests.** Unit tests for placement, cross row-and-column clears, every joker alone and in its pair, and golden tests that fix the first 30 pieces of a known seed.

## Presentation: rendering, drag and juice

Plain Flutter widgets and `CustomPainter` are enough; no game engine (Flame) is needed for a turn-based grid.

- **Board.** One `CustomPainter` draws the 8×8 grid, filled cells, stones and the placement shadow in a single pass, so dragging stays at 60 fps or more.
- **Drag and drop.** A custom `GestureDetector` on each tray piece, not `Draggable`, to control the lift: the piece floats about 60 px above the finger and snaps to the nearest cell. Snapping is computed from the whole piece's centre, not its first block as in the prototype.
- **Shadow preview.** On every cell change, call `engine.canPlace` and `engine.previewClears`: piece colour at 60% when it fits, red with solid red on colliding cells when it doesn't, white outline on lines that would clear.
- **Juice, the part that sells the game.** Cleared lines flash then burst into particles; the score counts up chips, then mult, then total, the way Balatro does; each joker that fires pulses in the joker bar in order; haptics on place, clear and big combos; short sounds with rising pitch on combos.
- **State.** A Riverpod `Notifier` holds `RunState`, calls the engine and queues its events for an animation controller, so animations play in sequence and input is locked meanwhile.
- **Screens.** World map, run (board), joker pick sheet, run end with daily ranking, settings. Routing with `auto_route`.

## Platform services

Every service sits behind an interface in a reusable kit package, so the next game in the portfolio plugs them in unchanged. No custom backend for the MVP.

| Need | Choice | Phase |
| --- | --- | --- |
| Save and resume a run | Local JSON snapshot of `RunState` + progression (shared\_preferences or a file via path\_provider) | 1 |
| Leaderboards and achievements | `games_services` package: Game Center on iOS, Play Games on Android; daily leaderboard reset (verify setup in App Store Connect and Play Console) | 3 |
| Analytics and crashes | Firebase Analytics + Crashlytics; events per round, joker picks, revives, run end | 3 |
| Live tuning | Firebase Remote Config: round targets, piece weights, ad frequency, min app version | 3 |
| Ads | AdMob with UMP consent: rewarded revive, interstitial between runs only, never mid-run | 3 |
| Purchases | `in_app_purchase` or RevenueCat: Remove ads, World pack, Supporter bundle | 3 |
| Force and optional updates | Remote Config `min_version` / `latest_version` per platform, as designed earlier | 3 |
| Daily reminder | Local notifications for the daily run and streaks; FCM topics for campaigns | 4 |
| Cloud save, score verification | Firestore + a Cloud Function replaying the move log against the seed | After MVP |

## Content and balancing

Balance with a bot before balancing with people: because the engine is pure Dart, a headless bot can play thousands of runs overnight.

- **Jokers.** Keep the pair design: 26 at launch (2 per world plus the star unlocks), more with each new world. Every joker gets a one-line rule and a partner.
- **Worlds.** All 5 at launch: Rubble (stones), Gravity (pieces fall), Fog (hidden cells), Tide (the board rises), Mirror (placements reflected). Speed was dropped: a timer fought the think-it-through design.
- **Bot.** A greedy bot that tries every placement and keeps the best score, run on 10,000 seeds per joker build. Output: score distribution per round and per build.
- **Targets.** Set round targets so the bot clears round 3 in about 70% of runs and the boss in about 25% with a matching pair. Keep all targets in Remote Config.
- **Outliers.** Any build that beats the boss in over 80% of bot runs gets nerfed; any joker picked under 5% of the time by real players gets reworked.
- **Live metrics.** Fail rate per round, joker pick rate, win rate per joker and per pair, revive rate.

## Validation and launch

Three checkpoints, each able to stop the project before more time goes in.

**Launch decision (18 Oct):** no soft launch. iOS and Android launch together right after phase 3: Apple's 7-day phased release and a Play staged rollout from 20% (the Play account has no closed-testing requirement). No marketing for the first 2 weeks; Crashlytics, D1/D7 and Remote Config replace the soft launch. The checkpoints below stay as targets, and the D1/D7 kill-or-scale rule now applies to the first weeks after launch.

1. **Hallway test (end of phase 1).** 5 to 10 people play for 10 minutes with no explanation. Pass if at least 6 start a second run on their own.
2. **Closed beta (end of phase 3).** TestFlight and Play internal testing with 30 to 50 players for two weeks; fix crashes and confusing moments.
3. **Soft launch (phase 4).** Android only, in 1 or 2 English-speaking markets, small paid install budget to reach about 1,000 players.

Targets I propose for the soft launch (to adjust with your own judgement):

| Metric | Target |
| --- | --- |
| D1 retention | 35% or more |
| D7 retention | 10% or more |
| Runs per player per day | 3 or more |
| Rewarded revive opt-in | 30% or more of lost runs |
| Crash-free sessions | 99.5% or more |

**Kill or scale:** D1 and D7 both at target → global launch on iOS and Android with new worlds as updates. Below target after two tuning iterations → stop, keep the kit, move to the next game.

## Risks and open decisions

The biggest risk is design, not tech: jokers that don't change how people play.

| Risk | Mitigation |
| --- | --- |
| Jokers don't change strategy, so it feels like Block Blast with bonuses | Hallway-test gate at the end of phase 1; pairs and bot data to find dead builds |
| Too complex for the Block Blast audience | First run with one joker and no boss; unlock mechanics one world at a time |
| Scope creep at 20 h/week | MVP list is fixed; anything else goes to "After the MVP" |
| Faked daily scores | Accept at launch; add move-log replay through a Cloud Function if needed |
| Daily seed differs across platforms | Own PRNG + golden tests on known seeds |
| A big studio copies the idea | Ship fast, keep a world-and-joker update cadence |
| Trademark trouble | Never use "Block Blast" or "Balatro" in the name, keywords or store text |

**Open decisions**

- [ ] Store listing text and screenshots
- [ ] Pure free-to-play, or free plus a one-time "full game" unlock
- [ ] `in_app_purchase` directly or RevenueCat
- [ ] Audio package (low latency matters for combo sounds)
- [ ] Soft-launch markets and test budget

## Sprint 1 checklist (weeks 1 and 2, about 40 h)

Goal: a full run playable on a real iPhone and a real Android phone, ugly but correct.

- [x] Generate the workspace with the Foundation generator, then add `packages/blockmancer_engine` and `packages/kit_design_system`
- [x] Lints, `import_lint` boundaries (the engine may not import Flutter), CI running analyze and tests on every pull request
- [x] Engine: `Board` (8×8; empty, filled with colour, stone) and the 19-shape catalog with normalized offsets
- [x] Engine: `canPlace`, `place`, row and column clears, with tests including a cross clear
- [x] Engine: mulberry32 PRNG + golden test fixing the first 30 pieces of seed 20261016
- [x] Engine: scoring pipeline (additive then multiplicative) + 4 jokers: Patience, Twin Lines, Combo King, Collector, each tested alone and in pairs
- [x] Engine: run state machine (starting joker → rounds → pick → boss → end) and revive
- [x] App: board `CustomPainter`, tray, drag with lift, shadow and red collision preview from `engine.canPlace`
- [x] App: score breakdown banner naming the jokers that fired
- [x] Play 5 complete runs on device and note what feels off

## Sprint 2 checklist (weeks 3 and 4, about 40 h)

Goal: the whole run is real: 14 jokers, the joker pick, the boss, the daily seed, and a run that survives the app being killed.

- [x] Engine: the 10 remaining jokers, each tested alone and with its partner
- [x] App: joker pick sheet with pair hints, joker bar with ★ on completed pairs, tap a joker to read it
- [x] App: round card (target, progress, pieces left, combo and stored mult), round won and round lost sheets, stones on the board
- [x] App: revive (button only, no ad yet) and the run-end screen with the run total and local best
- [x] Daily run from the UTC date + practice run with a random seed
- [x] Local save: the run is saved after every move and on app pause, resumed on launch, schema versioned
- [x] Engine: replay test: a seed plus a move log reproduces the exact final state
- [x] Tool: headless balance bot printing clear rates per round and per joker pair

Details and acceptance criteria are in `SPRINT_2.md` in the repo.

## Sprint 3 checklist (weeks 5 and 6, about 40 h) — ends phase 1

Goal: the game feels good enough to put in a stranger's hands, then the hallway test decides whether phase 2 starts.

- [x] Tune round targets from the balance bot, all in one `RunConfig` (targets still the prototype values until the bot table is reviewed)
- [x] Juice: snap on place, line-clear flash and particles, Balatro-style score count-up, jokers pulsing as they fire
- [x] Haptics and sound effects, each with an off switch; reduce-motion support (sounds being reworked to feel more rewarding)
- [x] First-run tutorial: drag, clear a line, read chips × mult, first joker pick; shown once, skippable
- [x] App icon and launch screen from the logo
- [x] Settings screen and all strings in English and French
- [x] Internal test builds on TestFlight and Play internal testing
- [ ] Hallway test: 5 to 10 people, 10 minutes each; pass if 6 of 10 start a second run on their own

Details and acceptance criteria are in `SPRINT_3.md` in the repo.

## Sprint 4 checklist (phase 2, part 1: the world map)

Goal: the world map gives long-term progression: two playable worlds, stars, and jokers that unlock as you advance.

- [x] Progression model and save schema v2 (worlds, stars, unlocked jokers), with migration from v1
- [x] Engine: `WorldRule` abstraction; Rubble moved onto it; new Gravity rule
- [x] Engine: 2 new jokers unlocked by Gravity (Anchor, Avalanche)
- [x] Joker pool gated by unlocks; offers only draw from unlocked jokers
- [x] World map screen (5 worlds, 2 playable, 3 shown as coming soon) with the daily run card on top
- [x] World detail sheet: boss rule, star objectives, jokers it unlocks, start button
- [x] Stars: beat the boss, win without revive, reach the world's score threshold
- [x] Balance bot supports world rules; star thresholds set from its output

Details and acceptance criteria are in `SPRINT_4.md` in the repo.

## Sprint 5 checklist (phase 2, part 2)

Goal: the MVP content is complete (20 jokers in 10 pairs), the map feels rewarding, the numbers are tuned, and a one-week tester round decides whether phase 3 starts.

- [x] Engine: 4 new jokers in 2 pairs: Full House ↔ On the Brink (crowded board), Finisher ↔ Hat Trick (planning a whole tray)
- [x] Unlocks by total stars: 4★ → Full House and On the Brink, 6★ → Finisher and Hat Trick
- [x] Save schema v3 with per-joker stats (picked, runs won, best run), chained migrations from v1 and v2
- [x] Joker collection screen ("Spellbook"): 20 cards by pair, locked cards show how to unlock them
- [x] Map and unlock polish: path draw-in, stars filling, card flips; reduce motion respected
- [x] `AnalyticsSink` interface with a local implementation and a "Share test stats" export (Firebase plugs in at phase 3)
- [x] Full balance pass: every pair in both worlds, boss win rate 15–40% with a matching pair, changes in `RunConfig` only

Details and acceptance criteria are in `SPRINT_5.md` in the repo.

## Sprint 6 checklist (phase 2, part 3: Fog and Tide)

Goal: worlds 3 and 4. Each boss rule stays turn-based, and every new joker works in every world.

- [x] Engine: fog cells (block placement, count as occupied, hidden content never visible to the preview or the bot), save schema v4
- [x] World 3, Fog: 8 fog cells at boss start, 3 hiding stones, revealed by filling next to them; jokers Lantern ↔ Ember
- [x] World 4, Tide: each new tray pushes the board up one row and a stone row with 2 gaps rises; pushed off the top = lost; jokers Sprinter ↔ Momentum
- [x] Map and detail sheets for Fog and Tide; a first-time card explaining each boss rule (Gravity included)
- [x] Bot runs --world fog and --world tide (tuning merged into the Sprint 7 balance pass)

Details and acceptance criteria are in `SPRINTS_6_7.md` in the repo.

## Sprint 7 checklist (phase 2, part 4: Mirror and the gate) — ends phase 2

Goal: the launch content is complete (5 worlds, 26 jokers in 13 pairs), balanced as a whole, then a tester week decides whether phase 3 starts.

- [x] World 5, Mirror: every placement reflected across the centre line, preview on the landing cells; jokers Symmetry ↔ Prism
- [x] The full map: all 5 worlds, a completion moment, Spellbook with 26 cards
- [x] Full balance pass: 13 pairs × 5 worlds, boss win rate 15–40% with a matching pair, difficulty rising along the map
- [ ] Phase 2 gate: replaced by the launch decision (no tester week); the same signals are read from D1/D7 after launch

Details and acceptance criteria are in `SPRINTS_6_7.md` in the repo.

## Sprint 8 checklist (phase 3: services, monetization, launch)

Goal: ship 1.0 on iOS and Android the same week, with every task below in 1.0. The agent keeps docs/console-setup.md: every step to do by hand in Firebase (Remote Config keys and template), AdMob, App Store Connect and Play Console.

- [x] Firebase: Analytics sink, Crashlytics, Remote Config feeding `RunConfig`, force and optional updates, `TEST_TOOLS` flag
- [x] Consent and privacy: UMP form, iOS tracking prompt, "Privacy choices" in Settings
- [x] Ads: rewarded revive, interstitial between runs only (capped through Remote Config)
- [x] Remove ads purchase at $3.99 with restore; the rewarded revive stays
- [x] Rating prompt: native review API after a boss win or a new star, never after a loss, at most once per version, no pre-prompt; "Rate Blockmancer" in Settings
- [x] Daily run leaderboard (Game Center, Play Games)
- [x] Daily reminder notification and streak
- [ ] Store listing, privacy labels and Data safety, DSA trader status, tax and bank, staged rollouts on both stores, 10 runs played on real phones

Details and acceptance criteria are in `SPRINT_8.md` in the repo.

## Phase 3 backlog (kept for when Firebase is added)

**Test tools behind a build flag.** Do this in the same sprint as the Firebase Analytics sink, before any build goes past internal testing. The `AnalyticsSink` interface and its 6 events stay; Firebase plugs in behind them. The local stats store and the "Share test stats" row exist only in test builds. Keep `share_plus` for a future "share my daily score" button.

Prompt for the agent:

```
Add a compile-time flag TEST_TOOLS (const bool.fromEnvironment, default false), set to true only in the TestFlight and Play internal build scripts.
- Settings → "Share test stats" is shown only when TEST_TOOLS is true.
- Wire AnalyticsSink through DI: TEST_TOOLS → CompositeSink([FirebaseAnalyticsSink, LocalStatsSink]); release → FirebaseAnalyticsSink only.
- On launch with TEST_TOOLS false, delete any local stats data once.
- Tests: the row is hidden and the local sink is not registered when the flag is false; the composite forwards each event to every sink.
Document the flag and the build commands in CLAUDE.md. One commit, analyze and tests, then stop.
```
