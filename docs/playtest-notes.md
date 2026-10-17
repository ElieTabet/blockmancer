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

---

# Hallway test — Sprint 3 (the phase 2 gate)

Run this once Sprint 3's tasks 1–7 are done, on a build installed from TestFlight or Play internal
testing (not a debug build), with sound on and the phone's language set to the tester's.

## Protocol

1. Find 5 to 10 people who have not seen the game.
2. Hand them the phone on the home screen and say only: **"It's a puzzle game, try it."**
3. Watch for 10 minutes **without helping**. Don't answer questions; note them instead.
4. Note where they hesitate, what they say out loud, and whether they read the jokers (the pick
   sheet and the chips at the top).
5. **The key signal:** after their first run ends, do they start a second one on their own?
   Prompting, hinting or handing the phone back with "again?" counts as no.

## Gate

6 of 10 (or the same share of fewer: 3 of 5, 4 of 6 or 7, 5 of 8 or 9) start a second run
unprompted → phase 2 (world map, worlds, more jokers). Below that → fix the top confusion points
below and test again before adding features.

## Sessions

Record each session as soon as it ends, using first names only.

| # | Who | Platform | First run length (min) | Reached round | Second run unprompted? | Read the jokers? |
|---|---|---|---|---|---|---|
| 1 | | | | | | |
| 2 | | | | | | |
| 3 | | | | | | |
| 4 | | | | | | |
| 5 | | | | | | |
| 6 | | | | | | |
| 7 | | | | | | |
| 8 | | | | | | |
| 9 | | | | | | |
| 10 | | | | | | |

**Second runs started unprompted:** _ of _ → gate **passed / not passed**

## Quotes

Word for word, with the session number.

-

## Confusion points

One line per moment someone hesitated or got it wrong, with the session numbers where it happened.
Sort by how many sessions hit it once the test is done; the top ones are what to fix first.

| Confusion point | Sessions | Count |
|---|---|---|
| | | |
