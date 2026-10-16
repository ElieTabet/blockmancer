# Playtest notes — Sprint 1

Task 8 of the brief: play 5 runs on iOS and 5 on Android, and write down what feels off. Run a
profile build on a real phone (`cd app && flutter run --profile`) so the drag runs at real speed.

Every run on a given UTC day uses that day's seed, so "the same run" means the same day. The run
total chip and the end sheet give you the numbers to copy.

## Runs

| # | Platform / device | Date (UTC) | Result (round reached / won) | Run total | Build (jokers) | Revived? |
|---|---|---|---|---|---|---|
| 1 | | | | | | |
| 2 | | | | | | |
| 3 | | | | | | |
| 4 | | | | | | |
| 5 | | | | | | |

## What felt off

Note the run and the moment where you can.

- **Drag and drop** (lift height, snapping, the shadow, dropping near an edge):
- **Frame rate** (any stutter while dragging, in profile mode):
- **Scoring readability** (the banner, the round card, the run total):
- **Difficulty** (targets too easy or too hard, piece count per round, the boss):
- **Jokers** (any that felt useless, too strong, or confusing):
- **Sheets** (picks, losing, the end of the run):
- **Anything else:**

## Known before playtesting

- A bot that clears as many lines as it can won 10 of the first 20 seeds (engine `full_run_test`),
  which suggests the targets may be lenient for a human. Worth watching.
- No animations yet: cleared lines and the tray refill simply change.
