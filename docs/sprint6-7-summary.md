# Sprints 6 and 7 — summary

Phase 2's launch content is in: 5 worlds (Rubble, Gravity, Fog, Tide, Mirror), 26 jokers in 13
pairs, first-time boss cards, the map's completion moment, and one balance pass over the whole.
Spec: `.claude/doc/SPRINTS_6_7.md`. Every rule that needed reading is in `docs/decisions.md`; the
balance tables are in `docs/balance/2026-10-18-sprint7.md`. The commits from `c665255` on are not
pushed yet.

## What shipped

| Task | Commit | What |
|---|---|---|
| 0a | `3fee5ce` | The 0.75 partner bias pinned by a test |
| 0b | `5fb8a92` | Collector: +1 mult for every two jokers owned |
| 0c | `7f1c0af` | Every number a joker's text shows comes from `RunConfig` (saved run v8) |
| 0d | `ee87851` | Sprint 5's table at 10,000 runs |
| 1 | `eef6354` | Fog cells, Speed renamed Tide, saved run v9, profile v6, world-rule hooks |
| 2 | `4d5c7a4` | Fog, with Lantern and Ember |
| 3 | `d1ac425` | Tide, with Sprinter and Momentum |
| 4 | `6f1188b` | Mirror, with Symmetry and Prism |
| 5 | `09d2067` | Boss cards (profile v7), the map's end, a whole campaign tested end to end |
| Review 1 | `c665255` | A line the tide completes clears at once, for nothing |
| Review 2 | `0a6c773` | The tray a revive deals never makes the tide rise |
| Review 3 | `9f02694` | Why `onRoundSetup` and `onBoardSetup` stay two hooks |
| Device bug | `f0a96f5` | A world earned before it had rules opens (Fog for players who beat Gravity early) |
| 6 | `e396e02` | The balance bot stops flooding Tide's boss on purpose |
| 6 | `a205abf` | The five worlds tuned against the bot, ★3 thresholds |
| 6 | `cf0c63e` | Version 1.1.0 (3) |

After every commit: `melos run analyze` and every package's tests pass, and generated files are
current. The engine's suite also passes in Chrome on the final commit.

## Decisions worth knowing

- **Tide departs from the sprint twice, at the review's request:** a rise that completes a line
  clears it for nothing (the sprint left it for the next move to score), and a revive's tray
  never rises (the sprint said it does).
- **The balance bot changed in Tide's boss only:** it scans from the bottom row and never prefers
  a flood on a tie. Before, its tie-break flooded on purpose and every build lost Tide's boss.
  Other worlds play exactly as before.
- **Worlds open from the rules, not a migration:** any playable world after a beaten boss is
  open, so a world given rules in a later release opens for players already past its gate.
- **Bosses get lower targets, not higher, along the map:** the harder rule does the work; the
  target only keeps each boss in range.
- **The bot's pick policy** stayed Sprint 5's (any offer, seeded), not the sprint's "first offer".

## Balance, in one table (2,000 runs)

| `random` | Rubble | Gravity | Fog | Tide | Mirror |
|---|---|---|---|---|---|
| boss target | 4,250 | 4,000 | 4,250 | 3,000 | 4,250 |
| boss win | 23% | 22% | 21% | 20% | 19% |
| boss win once round 4 is cleared | 59% | 55% | 55% | 52% | 50% |
| ★3 | 10,500 | 10,500 | 10,500 | 9,500 | 10,500 |

Round 3: `random` 66%, strong pairs 70–74%, planning pairs within 8 points. Pairs with their pair
done beat the boss 25–40% of the time, except the planning pairs, Pockets/Saver and Lantern/Ember
(below, explained in the report) and Patience/Twin and Precision/Tiny a point or three over.
**Not confirmed at 10,000 runs** (stopped at iteration 5 at your call); each figure carries about
±2–4 points.

## Left for you

- **Push:** `! git push origin main`.
- **Builds:** the version is bumped, but I didn't run `melos run build-ios` / `build-android`:
  both upload Dart symbols to Crashlytics, and `app/android/key.properties` is missing, so the
  Android build would be signed with the debug key, which Play refuses.
- **On a device:** a full run from Rubble to Mirror, and the map at 60 fps in profile mode on a
  mid-range Android phone.
- **Task 7:** the tester week.
- **Worth a design look:** Lantern/Ember can't act before the boss (nothing to clear), so it is
  the weakest pair in every world; Prism alone is strong in Mirror (44% with it owned).
