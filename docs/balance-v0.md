# Balance bot v0: first table

`melos run balance-bot`, which runs `dart run tool/balance_bot.dart` in
`packages/blockmancer_engine` with its default of 2,000 runs. Seeds 1 to 2,000 for each build, on the default config (targets
250 / 500 / 900 / 1,400 / boss 2,000). The run took 26 s for all five builds on an 11-core M3 Pro.

| build | round 1 | round 2 | round 3 | round 4 | round 5 | median total | boss win |
|---|---|---|---|---|---|---|---|
| none | 99% | 87% | 67% | 59% | 53% | 5823 | 53% |
| patience,twin | 99% | 89% | 80% | 77% | 74% | 6681 | 74% |
| combo,collector | 99% | 90% | 80% | 76% | 72% | 6335 | 72% |
| heavy,bigbox | 99% | 90% | 71% | 58% | 47% | 5356 | 47% |
| stonemason,quarry | 99% | 81% | 52% | 41% | 36% | 2560 | 36% |

"round N" is the share of runs that cleared round N; round 5 is the boss, so it equals the boss win
rate.

## How the bot plays

- **Placement:** every tray piece at every legal anchor, keeping the move that adds the most to
  the run total right away. Ties go to the move that leaves the fewest occupied cells.
- **Jokers:** the first joker of the build on offer, otherwise the first offer. `none` always
  takes the first offer.
- **Losing a round:** it revives once when allowed, then ends the run.

It never plans ahead. It doesn't keep space open for large pieces, and it doesn't play for a
combo streak. A human will clear more than it does on some builds and less on others.

## Against the brief's aim

The brief aims for about 70% of runs clearing round 3, and about 25% beating the boss with a
matching pair.

- **Round 3 is about right.** With no build preference, 67% of runs clear it; with a pair, 71–80%,
  except stonemason + quarry at 52%.
- **The boss is far too easy for the scoring pairs.** Patience + twin beats it 74% of the time and
  combo + collector 72%, about three times the aim. Rounds 4 and 5 barely thin the field: almost
  every run that clears round 3 goes on to win.
- **Stonemason + quarry is the weak pair.** Its stones crowd the board, and it scores less
  (median 2,560).

These numbers come from a greedy bot, not from players; read them as relative rather than
absolute. Raising the round 4 and boss targets, or the boss's stones, are the obvious levers to try
first. Re-run the bot after each change.
