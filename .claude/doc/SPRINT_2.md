# Blockmancer — Sprint 2 (weeks 3 and 4, about 40 h)

Read `BLOCKMANCER_BRIEF.md` first; its rules (section 4) and working agreement (section 3) still apply.
`docs/reference/blockmancer_reference.html` is the behavioural source of truth when this file is ambiguous.

**Goal:** the whole run is real — all 14 jokers, the joker pick, the boss, the daily seed, and a run that survives
the app being killed. Still no ads, purchases, leaderboards, notifications, map or sound.

Work through the tasks in order. Stop after each task, run analyze and tests, and report what changed.

---

## Task 1 — The 10 remaining jokers (engine)

Stonemason, Quarry, Precision, Heavyweight, Big Box, Tiny Tools, Column Hunter, Clean Sweep, Deep Pockets, Saver
(effects in the brief, section 4.3). Each is its own `JokerEffect` class; no edits to existing jokers.

**Done when**
- each joker has a unit test alone and one with its partner;
- Big Box and Tiny Tools change draw weights only (test: 10,000 draws on a fixed seed, 5+ cell / 1–2 cell shares
  roughly triple versus no joker);
- Quarry's stone and Stonemason's extra stones come from the **stones** PRNG stream, never the pieces stream
  (test: owning Quarry does not change the sequence of pieces drawn);
- Saver's bonus is added to the run total when a round is won, not to the round score.

## Task 2 — Joker pick and joker bar (app)

- Bottom sheet with the 3 offers: name, one-line effect, "Pairs with: X"; when it completes a pair with an owned
  joker, highlight it (amber border, "★ Completes a pair with your X").
- Starting pick before round 1 uses the same sheet with its own title.
- Joker bar above the board: chips with ★ when the partner is owned; tap a chip to show its effect.

**Done when** a widget test covers the pair highlight and the sheet cannot be dismissed without a pick.

## Task 3 — Round flow UI (app)

- Round card: round name and number (`Round · 2 / 5`, `Boss · Rubble`), score / target with a progress bar,
  pieces left, combo streak and Patience's stored mult when non-zero.
- Stones drawn distinctly from filled cells.
- "Round cleared" → joker pick sheet; "Out of pieces" / "No room left" → lost sheet.
- Input is locked while the score breakdown animates (from Sprint 1's events).

**Done when** a full run from the starting pick to the boss result is playable on a device.

## Task 4 — Revive and run end (app)

- Lost sheet: "Revive" button calling `engine.revive` (the rewarded ad comes in phase 3; keep the call behind a
  `RewardedAction` interface whose current implementation always succeeds), and "End run".
- Run-end screen: run total, the build (owned jokers), local best for this mode, "Play again".

**Done when** revive restores play exactly as the engine test expects, and the local best persists across launches.

## Task 5 — Daily run and practice run

- Home with two entries: **Daily run** (seed = UTC date `yyyymmdd`) and **Practice** (random seed).
- The daily best is stored per date; a new UTC day shows a fresh daily run.
- Read the date from an injectable `Clock`, never `DateTime.now()` directly, so tests can fix the day.

**Done when** two devices (or a test with two clocks set to the same UTC day in different time zones) get the same
first 30 pieces, and the day changes at 00:00 UTC.

## Task 6 — Local save and resume

- Serialize `RunState` (and the PRNG stream states) to JSON after every move, after every pick, and on
  `AppLifecycleState.paused`.
- On launch, offer "Continue run" when a saved run exists.
- Schema field `version: 1` and a `migrate(json)` hook (no-op today).

**Done when**
- a test round-trips `RunState` → JSON → `RunState` with full equality, including mid-round with stones and a
  stored Patience bank;
- killing the app mid-round and relaunching resumes on the same board, tray and score.

## Task 7 — Replay determinism (engine)

- Record each action as a compact move log: `pick(jokerId)`, `place(trayIndex, row, col)`, `revive`.
- `replay(seed, moves)` rebuilds the final `RunState`.

**Done when** a test plays 3 scripted runs (different builds), replays their logs, and gets identical final states
and totals. This is the foundation for future server-side score verification.

## Task 8 — Balance bot v0 (tool)

- A Dart CLI in `packages/blockmancer_engine/tool/balance_bot.dart`, depending only on the engine.
- Greedy policy: for every tray piece and every legal anchor, simulate the move and keep the highest immediate score;
  ties broken by fewest occupied cells. Picks jokers by a fixed build list passed on the command line.
- `dart run tool/balance_bot.dart --runs 2000 --build patience,twin` prints: % of runs clearing each round,
  median run total, and boss win rate.

**Done when** it runs 2,000 runs in under a minute on a laptop and prints a table for at least these builds:
none, patience+twin, combo+collector, heavy+bigbox, stonemason+quarry.

---

## After Sprint 2

Send the bot table back for tuning the round targets (the brief's aim: about 70% of runs clear round 3, about 25%
beat the boss with a matching pair). Sprint 3 will be juice (animations, sound, haptics), first-run onboarding and
the hallway test that gates phase 2.
