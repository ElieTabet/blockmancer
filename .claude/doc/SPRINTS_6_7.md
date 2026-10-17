# Blockmancer — Sprints 6 and 7 (phase 2, parts 3 and 4: Fog, Tide, Mirror) — ends phase 2

Read `BLOCKMANCER_BRIEF.md` first; its rules and working agreement still apply. This file replaces
`SPRINT_6.md` and `SPRINT_7.md`. It builds on Sprint 4 (`WorldRule`, map, stars, unlocks, bot `--world`) and Sprint 5
(20 jokers, save v3, Spellbook, map polish, `AnalyticsSink`, tuned `RunConfig`).

**Goal:** the launch content is complete — 5 worlds (Rubble, Gravity, Fog, Tide, Mirror), 26 jokers in 13 pairs —
balanced as a whole, then a one-week tester round decides whether phase 3 (services and monetization) starts.
Still out of scope: ads, purchases, leaderboards, notifications, Firebase.

## How to work

- Do the tasks **in order**, one commit (or commit series) per task. Run analyze and all tests after each task;
  never start the next task with a failing test.
- Don't stop between Tasks 1 and 5. Whenever you have to interpret a rule, choose the reading closest to this file,
  write it in `docs/decisions.md` (task, rule, your reading, why) and carry on.
- **Stop points:** after the "before" report of Task 6 (wait for my go before changing `RunConfig`), and after
  Task 6 is finished (Task 7 is run by a human).
- Rules common to every task:
  - A world's rule applies to its **boss round only**; rounds 1–4 are normal.
  - Every new joker works in every world, not only its own. Each joker is its own `JokerEffect` class.
  - All numbers go in `RunConfig`. All strings in English and French (slang).
  - The engine stays deterministic: randomness only from the run's named streams; no clock, no I/O.
  - The map, Spellbook and unlock chain are data-driven: adding a world or joker means data and strings, not new
    screen code.

| # | Task | Ends with |
|---|---|---|
| 1 | Shared engine changes: fog cells, save v4, `WorldRule` hooks | tests |
| 2 | World 3: Fog + Lantern, Ember | tests, bot `--world fog` |
| 3 | World 4: Tide + Sprinter, Momentum | tests, bot `--world tide` |
| 4 | World 5: Mirror + Symmetry, Prism | tests, bot `--world mirror` |
| 5 | Map, detail sheets, first-time boss cards, Spellbook to 26 | full run Rubble → Mirror on device |
| 6 | Full balance pass (5 worlds) | **stop after the "before" report**, then tune |
| 7 | Phase 2 gate: tester week | human, not code |

---

## Task 1 — Shared engine changes

**Fog cell state**
- New cell state `fog(hidesStone: bool)`.
- Fog **blocks placement** like a stone and **counts as occupied** for line checks and for Full House / On the Brink.
- Fog in a cleared line is removed with the line (whatever it hid is gone too).
- What a fog cell hides is engine state only: `preview`, the UI and the balance bot never read `hidesStone`.

**Save v4**
- Schema `version: 4`; the board serializes the fog state. `migrate(v3 → v4)` only bumps the version (no v3 save can
  contain fog). The v1 → v2 → v3 → v4 chain works end to end.

**`WorldRule` hooks** (no world uses them until Tasks 3 and 4)
- `onTrayDealt(state)` — called when a new tray is dealt, with a flag telling whether it is the round's first tray.
- `transformPlacement(cells)` — maps the piece's cells chosen by the player to the cells where it actually lands.
  The existing anchor transform (Gravity) is re-expressed through it with no behaviour change.

**Done when** the board round-trips with fog cells; recorded v1, v2 and v3 saves migrate to v4; a test proves the
preview output is identical whether a fog cell hides a stone or not; both hooks are tested with a fake rule; all
Gravity tests pass unchanged.

## Task 2 — World 3: Fog

**Boss rule:** at boss start, 8 fog cells are placed on empty cells (positions from the **stones** stream), 3 of them
hiding a stone. After a placement and its clears, every fog cell orthogonally adjacent to a cell of the placed piece is
**revealed**: it becomes empty, or a stone if it hid one.
Order of a move: place → score and clear lines → Lantern removals → reveal.

- Board: fog drawn as a soft cloud tile, clearly different from stones; a short puff on reveal (instant with reduce
  motion). The preview marks fog cells as blocked, exactly like stones.
- New events: `FogPlaced(cells)`, `FogRevealed(cell, becameStone)`.

| Id | Name | Effect | Type | Partner |
|---|---|---|---|---|
| `lantern` | Lantern | stones and fog cells orthogonally adjacent to a cleared line are removed too | board effect | `ember` |
| `ember` | Ember | ×2 mult when the move removes at least one stone or fog cell | multiplicative | `lantern` |

- Lantern's removals are part of the clear: they count for Ember on the same move but add no chips (chips stay
  10 × cells in cleared lines). Stones or fog removed inside a cleared line also count for Ember.
- Unlocks: beating Gravity unlocks Fog (plus Anchor and Avalanche, as before); beating Fog unlocks Tide, Lantern
  and Ember.

**Done when** tests cover: fog blocking placement, fog cleared inside a line, reveal to empty, reveal to stone, the
move order above, Lantern alone and with Ember (including a Lantern removal triggering Ember), and `--world fog`.

## Task 3 — World 4: Tide

**Boss rule:** every time a new tray is dealt, except the boss's first tray, the tide rises:
1. every cell moves up one row; the top row's contents leave the board;
2. a new bottom row enters: stones in 6 columns and 2 empty gaps (gap columns from the **stones** stream).
- If any filled cell, stone or fog cell is pushed off the top, the round is lost ("Flooded"); revive works as usual
  (a tray dealt after a revive also triggers a rise).
- The rising row has gaps, so the rise itself never completes a line. Filling the gaps clears the row like any line
  (stones included), which is how the player fights back.
- Implemented with `onTrayDealt`; no save change beyond v4.
- New event `TideRose(gapColumns)`, and a `flooded` reason on `RoundLost`.
- UI: the board slides up (about 250 ms, instant with reduce motion); the top row shows a warning tint when it has any
  occupied cell, so the danger is visible before the next tray; "Tide in N" on the round card, N = pieces left in the
  tray.

| Id | Name | Effect | Type | Partner |
|---|---|---|---|---|
| `sprinter` | Sprinter | +5 mult when the first piece placed from a fresh tray clears a line | additive | `momentum` |
| `momentum` | Momentum | +2 mult × streak on every clearing move, where streak = consecutive trays (including the current one) whose first piece cleared a line | additive | `sprinter` |

- Momentum: if the current tray's first piece did not clear, the streak is 0 for the rest of that tray. The streak
  lives in the run snapshot (save v4, no extra migration needed if the field defaults to 0).
- Unlocks: beating Tide unlocks Mirror, Sprinter and Momentum.
- Bot: `--world tide`. The greedy bot ignores the coming rise; that's fine (real players will do better).

**Done when** tests cover: a rise shifting cells up, the stone row with exactly 2 gaps from the stones stream, a rise
pushing an occupied top row off (loss, `flooded`), filling the gaps to clear the risen row, no rise on the boss's first
tray, a rise after revive, replay of a run with rises, Sprinter and Momentum alone and together (including the streak
resetting), and `--world tide`.

## Task 4 — World 5: Mirror

**Boss rule:** every placement is reflected across the board's vertical centre line: each cell `(r, c)` of the piece
lands on `(r, 7 − c)`. Both the position and the shape are mirrored.

- Implemented with `transformPlacement`; `canPlace` and `preview` work on the **landing** cells.
- UI during the Mirror boss: a thin centre line on the board; while dragging, an outline under the finger and the
  solid ghost on the landing cells (red when they collide).

| Id | Name | Effect | Type | Partner |
|---|---|---|---|---|
| `symmetry` | Symmetry | +4 mult when, after the clear, the board is left-right symmetric and not empty | additive | `prism` |
| `prism` | Prism | +15 chips per occupied cell whose mirror cell `(r, 7 − c)` is also occupied, counted after the clear | chips | `symmetry` |

- For both, "occupied" = filled cells and stones (colour ignored). Any fog cell makes the board not symmetric, and a
  fog cell never counts for Prism.
- Both apply only to clearing moves.
- Unlocks: beating Mirror unlocks Symmetry and Prism (the final reward).

**Done when** tests cover: landing cells for an asymmetric piece (e.g. shape 14), a collision on the mirrored side, a
placement legal on the finger side but illegal mirrored, the preview matching the landing, both jokers alone and
together (including the fog cases), and `--world mirror`.

## Task 5 — Map, detail sheets and Spellbook for the full game

- All 5 worlds playable; no "Coming soon" left. Unlock chain: Rubble → Gravity → Fog → Tide → Mirror.
- Detail sheets for Fog, Tide and Mirror: the boss rule in one sentence, points needed, 3 stars, the 2 jokers unlocked.
- **First-time boss card:** the first time a player reaches a world's boss, a short card explains the rule with a
  small animation, for Gravity, Fog, Tide and Mirror. Examples: "Fog hides the board. Fill next to it to see what's
  underneath." / "Every new tray, the tide rises one row. Don't let it push your blocks off the top." /
  "Everything you place lands mirrored." Shown once per world, replayable from the detail sheet.
- A "world complete" moment after the first Mirror win: all 5 nodes lit, total stars out of 15.
- Spellbook shows 26 cards in 13 pairs with the new unlock conditions (data only, no screen change).
- Star-threshold unlocks (4★, 6★) stay as they are.

**Done when** a fresh profile can reach and beat every world in order with each world and joker pair unlocking
exactly once; a test checks every first-time card shows once; the map stays at 60 fps in profile mode on a mid-range
Android phone with all nodes unlocked.

## Task 6 — Full balance pass (all 5 worlds)

Use the bot exactly as fixed in Sprint 5: pick policy "build joker when offered, otherwise first offer", baselines
`random` and `empty`, all jokers unlocked, seeds 1–10,000.

**Report** (13 pairs + `random` + `empty`, each of the 5 worlds, 10,000 runs) with these columns per build:
round 1–4 clear rates, boss win, boss win | r4 cleared, boss win | pair done, P50 and P80 run totals, jokers owned,
pair done %. Plus a `solo` row per new joker (6), 2,000 runs, its own world.

**Stop here** and send the "before" report. Change nothing in `RunConfig` until I reply "go".

**Targets** (after "go"):
- Round 3: `random` ≈ 65%, strong pairs ≈ 70–75%; planning pairs (Finisher/Hat Trick, Column/Sweep,
  Anchor/Avalanche, Symmetry/Prism) within 8 points of `random`, not at parity (the greedy bot undervalues them).
- Boss: "boss win | r4 cleared" ≈ 50–65% (the boss is a wall); "boss win | pair done" 25–40%;
  `random` overall boss win ≈ 15–25%.
- **Difficulty rises along the map:** each world's boss slightly harder than the previous one for `random`
  (separate boss targets per world in `RunConfig`).
- Allowed changes: round targets, pieces per round, boss stones and fog counts, joker constants. Prefer target changes
  over joker changes.
- Iterate at 2,000 runs; confirm the final values at 10,000 with the same seeds.
- Set each world's ★3 threshold at the P80 of its best pair (pair-done runs only).
- Commit the before/after report to `docs/balance/<date>-sprint7.md`, each change with its reason.

**Done when** every world meets the targets and the rising difficulty, or the report explains each outlier. Then build
TestFlight and Play internal builds with the version bumped, and stop.

## Task 7 — Phase 2 gate: one-week tester round (human, not code)

- 10 to 20 testers (hallway testers plus new ones), 7 days, no reminders after day 1.
- At the end, each tester sends Settings → "Share test stats" plus one sentence: "What made you stop?"
- Record in `docs/playtest-notes.md`: days played, runs per play day, furthest world, jokers never picked.

**Gate (to adjust with judgement):**
- at least 40% of testers play on 3 or more different days;
- median of 3 or more runs per play day;
- at least half of the testers beat the Rubble boss, and at least a quarter reach Fog.

Pass → phase 3 (Firebase, leaderboards, ads, purchases, Remote Config). Below → fix the top reasons people stopped and
run the week again.
