# Blockmancer — implementation brief for the coding agent

You are implementing **Blockmancer**, a single-player block-puzzle roguelite for iOS and Android, in Flutter.
Read this whole file before writing code. When something here conflicts with the generated project's
own conventions (CLAUDE.md, README, lint rules), follow the project's conventions and flag the conflict.

## 1. Product in one paragraph

An 8×8 board, a tray of 3 pieces. The player drags pieces onto the board; full rows and columns clear and score
**chips × mult**. A run is a starting joker pick, 4 rounds and a boss; each round has a points target and a limited
number of pieces. After each round the player picks one joker that changes the scoring. A world map gives long-term
progression; a daily run (same seed for everyone) gives competition. Free to play, ads and in-app purchases.

## 2. Fixed decisions (do not change without asking)

| Topic | Decision |
|---|---|
| Bundle id | `com.elietabet.blockmancer` |
| Dart package prefix | `blockmancer` |
| Architecture | Melos monorepo, Clean Architecture, Riverpod, auto_route (as generated) |
| Game rules | Pure Dart package `packages/blockmancer_engine`, **no Flutter import** (enforce with `import_lint`) |
| Rendering | Flutter widgets + `CustomPainter`. **No Flame**, no game engine |
| Backend | None. Firebase only (Analytics, Crashlytics, Remote Config, Messaging) |
| Login | None. Players open straight into the game |
| Notifications | Local notifications for the daily run and streaks; FCM topics for campaigns |
| Leaderboards | `games_services` (Game Center / Play Games), behind an interface — **not in Sprint 1** |
| Languages | English and French |
| Brand | Background `#14172B`, accent `#FFB547`, jokers `#A57BFF`; DM Sans, Fredoka for titles and scores |

## 3. Working agreement

- Small, focused changes; one task per pull request or commit series.
- Run `melos analyze` and `melos test` (or the project's equivalents) before saying a task is done.
- Do **not** add a dependency without saying why and asking first.
- Do **not** invent APIs of packages you have not checked; read the package docs or source.
- Every engine rule gets a unit test. Every bug fix gets a regression test.
- Keep the engine deterministic: no `DateTime.now()`, no `dart:math` `Random`, no I/O inside the engine.

## 4. Game rules (exact spec, mirrors the validated prototype)

### 4.1 Board and pieces
- Board: 8×8 cells. A cell is `empty`, `filled(colorIndex)` or `stone`.
- Pieces are defined by cell offsets `(row, col)`. Catalog (19 shapes):
  1. `[(0,0)]`
  2. `[(0,0),(0,1)]` 3. `[(0,0),(1,0)]`
  4. `[(0,0),(0,1),(0,2)]` 5. `[(0,0),(1,0),(2,0)]`
  6. `[(0,0),(1,0),(1,1)]` 7. `[(0,0),(0,1),(1,0)]` 8. `[(0,0),(0,1),(1,1)]` 9. `[(0,1),(1,0),(1,1)]`
  10. `[(0,0),(0,1),(1,0),(1,1)]`
  11. `[(0,0),(0,1),(0,2),(0,3)]` 12. `[(0,0),(1,0),(2,0),(3,0)]`
  13. `[(0,0),(0,1),(0,2),(1,1)]` 14. `[(0,0),(1,0),(2,0),(2,1)]` 15. `[(0,1),(1,1),(2,0),(2,1)]`
  16. `[(0,1),(0,2),(1,0),(1,1)]`
  17. 3×3 square (9 cells)
  18. `[(0,0)…(0,4)]` (5 horizontal) 19. `[(0,0)…(4,0)]` (5 vertical)
- No rotation. Placement anchor in the engine API = the piece's top-left bounding-box cell.
  (The UI snaps by the piece's centre under the finger; converting to the anchor is the UI's job.)
- A placement is valid when every cell is inside the board and empty (stones block).

### 4.2 Clearing and scoring
After placing, every full row and every full column clears at once (stones in a cleared line are removed too).
- Placement points: `+n` where n = cells in the piece (always).
- If at least one line cleared:
  - `chips = 10 × (number of distinct cells cleared)`
  - `mult = number of lines cleared`
  - Apply jokers: **additive effects first, then multiplicative**, in the order listed in 4.3.
  - Move score = `n + chips × mult` (+ flat bonuses).
- `streak` = consecutive moves that cleared at least one line (resets to 0 on a non-clearing move).

### 4.3 Jokers (14, designed in 7 pairs)

**Source of truth: `RunConfig`.** Every number below is a default. The values the game plays with
are `RunConfig.jokers` (`JokerTuning`) and `RunConfig.traySize`, set in `blockmancer_engine`'s
`default_config.dart`, and every joker text (Spellbook, pick sheet, joker bar, unlock sheets) reads
its numbers from there; no string holds a literal number.

| Id | Name | Effect | Type | Partner |
|---|---|---|---|---|
| `stonemason` | Stonemason | +50 chips per stone cleared; +2 stones at the start of every round | chips | `quarry` |
| `combo` | Combo King | +(streak − 1) mult | additive | `collector` |
| `patience` | Patience | each non-clearing move stores +2 mult; the next clear adds the stored mult, then resets it | additive | `twin` |
| `precision` | Precision | +6 mult when a 1–2 cell piece completes a line | additive | `tiny` |
| `collector` | Collector | +1 mult for every two jokers owned, itself included (was per joker owned until Sprint 7's Task 0) | additive | `combo` |
| `twin` | Twin Lines | ×3 mult when 2+ lines clear at once | multiplicative | `patience` |
| `column` | Column Hunter | ×2 mult when the move clears a column | multiplicative | `sweep` |
| `heavy` | Heavyweight | ×2 mult when a 4+ cell piece completes a line | multiplicative | `bigbox` |
| `sweep` | Clean Sweep | +500 points when the board becomes completely empty | flat bonus | `column` |
| `quarry` | Quarry | after each clearing move, one random empty cell becomes a stone | board effect | `stonemason` |
| `bigbox` | Big Box | pieces of 5+ cells drawn with weight ×3 | draw weight | `heavy` |
| `tiny` | Tiny Tools | pieces of 1–2 cells drawn with weight ×3 | draw weight | `precision` |
| `pockets` | Deep Pockets | +4 pieces every round | round setup | `saver` |
| `saver` | Saver | when a round is won, +40 run points per unused piece | round end | `pockets` |

Implement each joker as its own class implementing a `JokerEffect` interface with hooks
(e.g. `onRoundSetup`, `pieceWeight`, `onScore(additive|multiplicative)`, `afterMove`, `onRoundWon`).
Adding a joker must never require editing the others.

### 4.4 Run structure
- Start: pick 1 joker from 3 offers.
- Rounds (targets and pieces will move to Remote Config later; hard-code for now):

| Round | Target | Pieces | Special |
|---|---|---|---|
| 1 | 250 | 14 | |
| 2 | 500 | 16 | |
| 3 | 900 | 18 | |
| 4 | 1,400 | 20 | |
| Boss "Rubble" | 2,000 | 22 | 6 stones placed at round start |

- After rounds 1–4: pick 1 joker from 3 offers (jokers already owned are excluded).
  Offer bias: if an owned joker's partner is still available, with probability 0.75 one offer slot is that partner.
- Each round starts with an empty board (+ stones if any), score 0, streak 0, stored mult 0.
- Tray: 3 pieces; when all 3 are used and pieces remain, draw the next 3 (fewer if fewer remain).
- Round won when round score ≥ target. Boss won = run won. Run total = sum of round scores + Saver bonuses.
- Round lost when (a) no pieces remain, or (b) none of the remaining tray pieces fits anywhere.
- Revive (rewarded ad later): clear the 2 rows with the most occupied cells, +3 pieces.

### 4.5 Randomness and the daily run
- Implement **mulberry32** in the engine (do not use `dart:math`):
  ```
  state = (state + 0x6D2B79F5) & 0xFFFFFFFF
  t = imul(state ^ (state >>> 15), state | 1)
  t ^= t + imul(t ^ (t >>> 7), t | 61)
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296
  ```
  Use 32-bit arithmetic explicitly so results match on VM and web.
- Use **separate streams** derived from the run seed: pieces, offers, stones. A player's joker choices must not
  shift the stone or offer sequences of other streams.
- Daily seed = UTC date as `yyyymmdd` integer (e.g. 20261016). Endless/world runs use a random seed.

### 4.6 Engine API (target shape)
```dart
RunState startRun({required int seed, required RunConfig config});
(RunState, List<GameEvent>) pickJoker(RunState s, JokerId id);
(RunState, List<GameEvent>) place(RunState s, {required int trayIndex, required Cell anchor});
(RunState, List<GameEvent>) revive(RunState s);
bool canPlace(RunState s, int trayIndex, Cell anchor);
PlacementPreview preview(RunState s, int trayIndex, Cell anchor); // fits?, colliding cells, lines that would clear
```
`RunState` is immutable (freezed or hand-written `==`). Events: `PiecePlaced`, `LinesCleared(rows, cols, cells)`,
`JokerFired(id, delta)`, `ScoreAdded(chips, mult, total)`, `StonePlaced`, `TrayRefilled`, `RoundWon`, `RoundLost`,
`RunWon`, `OffersPresented`. The UI animates events; it never recomputes rules.

## 5. Sprint 1 (about 40 h) — tasks and acceptance criteria

Goal: a full run playable on a real iPhone and Android phone, ugly but correct.

1. **Engine package** — `packages/blockmancer_engine` created, pure Dart, `import_lint` forbids Flutter imports.
   *Done when* analyze passes and a Flutter import in the engine fails the lint.
2. **Board + shapes** — model, catalog of 19 shapes, `canPlace`, `place`, row/column/cross clears.
   *Done when* tests cover: out of bounds, overlap, stone blocking, single row, single column, row+column cross
   (the shared cell counted once), stones removed in cleared lines.
3. **PRNG** — mulberry32 + stream derivation.
   *Done when* a golden test fixes the first 30 pieces of seed 20261016 and passes on VM and `--platform chrome`.
4. **Scoring + 4 jokers** — pipeline (additive then multiplicative) with Patience, Twin Lines, Combo King, Collector.
   *Done when* each joker has a test alone and with its partner, including Patience storing then spending mult.
5. **Run state machine** — start pick → rounds → picks → boss → end; win/lose conditions; revive; offer bias.
   *Done when* a scripted test plays a full seeded run to the end deterministically.
6. **Board UI** — `CustomPainter` board, tray, drag with ~60 px lift on touch, shadow preview from
   `engine.preview` (piece colour when it fits, red on collision, outline on lines that would clear).
   *Done when* placement works by drag on a device at 60 fps in profile mode.
7. **Score feedback** — banner naming the jokers that fired with chips × mult = total.
8. **Device check** — play 5 runs on iOS and Android; list what feels off in `docs/playtest-notes.md`.

Out of scope for Sprint 1: world map, ads, purchases, leaderboards, notifications, sound, localisation polish.

## 6. Reference material
- The playable HTML prototypes (Block Run, world map) are the behavioural reference for rules and feel.
- The full plan (phases, architecture, platform services, launch gates) lives in `IMPLEMENTATION_PLAN.md`, next to this file.
