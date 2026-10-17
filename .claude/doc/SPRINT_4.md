# Blockmancer — Sprint 4 (phase 2, part 1: the world map)

**Start only after the hallway test has passed** (see SPRINT_3.md, Task 8).
Read `BLOCKMANCER_BRIEF.md` first; its rules and working agreement still apply.
The canvas world-map prototype is the visual reference: daily run card on top, a winding path of 5 worlds,
3 stars per world, a detail sheet per world.

**Goal:** long-term progression. Two playable worlds (Rubble, Gravity), stars, and jokers that unlock as you
advance. Still out of scope: ads, purchases, leaderboards, notifications, Firebase.

Stop after each task, run analyze and tests, and report what changed.

---

## Task 1 — Progression model and save v2

- `Progression`: per world `{unlocked, bossBeaten, stars: {bossBeaten, noRevive, scoreThreshold}}`,
  plus `unlockedJokers: Set<JokerId>` and `tutorialDone`.
- Starting state: World 1 unlocked; 10 starting jokers unlocked (all current jokers except Stonemason, Quarry
  and the two new Gravity jokers).
- Bump the save schema to `version: 2` with a real `migrate(v1 → v2)`: existing players keep their best scores
  and get the starting progression.

**Done when** a migration test turns a recorded v1 save into a valid v2 save, and progression round-trips through JSON.

## Task 2 — `WorldRule` in the engine

- A `WorldRule` interface with hooks: `onRoundSetup` (e.g. place stones), `transformAnchor` (where a placement
  actually lands), `onBossOnly` flag. A world = its 4 rounds + boss, its rule applying to the **boss round only**.
- Move Rubble (6 stones at boss start) onto `WorldRule` with no behaviour change (existing tests must pass untouched).
- **Gravity rule:** after the player chooses an anchor, the piece falls straight down as one rigid shape until one
  more row down would leave the board or overlap a filled cell or stone; it lands there. Line clears happen after
  landing. `preview` must show the **landing** position, not the drop point.

**Done when** tests cover: a piece falling to the bottom, landing on an overhang, landing on a stone, a piece that
cannot be dropped in a column that is full to the top (not placeable), and the preview matching the landing spot.

## Task 3 — Two new jokers (unlocked by beating Gravity)

| Id | Name | Effect | Type | Partner |
|---|---|---|---|---|
| `anchor` | Anchor | +4 mult when the move clears the bottom row | additive | `avalanche` |
| `avalanche` | Avalanche | +25 chips for every filled cell left in the two bottom rows after a clear | chips | `anchor` |

Both work in every world, not only Gravity. Constants go in `RunConfig`.

**Done when** each has a test alone and with its partner, and the balance bot can run the `anchor,avalanche` build.

## Task 4 — Unlock gating

- Joker offers draw only from `unlockedJokers` (minus owned). The pair bias only proposes unlocked partners.
- Beating a world's boss for the first time unlocks the next world and that world's 2 jokers
  (Rubble → Stonemason, Quarry; Gravity → Anchor, Avalanche).
- An unlock celebration sheet after the boss: "New world: Gravity" and the 2 joker cards.
- The daily run uses **all jokers** regardless of unlocks, so the leaderboard stays fair.

**Done when** a test proves a fresh profile is never offered a locked joker in world runs, and daily runs can be.

## Task 5 — World map screen

- Becomes the home screen after the tutorial.
- Top: the daily run card (date, best today, play).
- Path of 5 worlds: Rubble, Gravity playable; Fog, Speed, Mirror shown as "Coming soon" (locked, greyed).
- Each node: number, name, 3 stars (filled/empty), states done / current / locked, a "you are here" marker.
- Practice mode stays reachable (small entry, e.g. in the header).

**Done when** progression changes are reflected immediately on return from a run, and the screen stays smooth
on a mid-range Android phone.

## Task 6 — World detail sheet

Tap a world: name and status, its boss rule in one sentence, points needed to beat the boss, the 3 star objectives
with achieved state, the 2 jokers it unlocks, and "Start run" / "Replay for the missing star". Locked worlds show
"Beat the previous boss to unlock" (no purchase button yet; that comes with IAP in phase 3).

## Task 7 — Stars

- ★1 beat the boss · ★2 beat the boss without using revive · ★3 reach the world's run-total threshold
  (in `RunConfig`, per world).
- Stars are awarded at run end and never removed.

**Done when** a test awards each star independently, and the run-end screen shows newly earned stars.

## Task 8 — Bot support and thresholds

- The balance bot takes `--world rubble|gravity` and applies the world rule to the boss.
- Report boss win rate per build for both worlds, and the 50th and 80th percentile run totals.
- Set each world's ★3 threshold near the bot's 80th percentile with a matching pair (so ★3 takes skill and a good build).

**Done when** the report for both worlds is committed to `docs/balance/` and thresholds in `RunConfig` cite it.

---

## Sprint 5 preview (phase 2, part 2)

4 more jokers (to reach 20), a joker collection screen, map animations and unlock polish, and a full balance
pass with real playtest data — ending with the phase 2 gate.
