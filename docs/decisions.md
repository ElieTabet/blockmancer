# Decisions

Every rule of `.claude/doc/SPRINTS_6_7.md` (and its Sprint 5 cleanup) that needed reading, with the
reading chosen and why. Newest task last.

## Task 0: Sprint 5 cleanup

### 0a. Offer bias and the Deep Pockets fix

- **Rule:** confirm the engine's offer bias is unchanged (0.75 partner offer) and that the Deep
  Pockets fix was in the bot only.
- **Finding:** `lib/src/run/offers.dart` last changed in Sprint 4 (`e4ac916`), and
  `defaultConfig.partnerBias` is 0.75; a test now pins both on the shipped config
  (`run_test.dart`, "the shipped run keeps the brief's partner bias of 3 in 4"). The fix
  (`8c18e7b`) touched only `lib/src/bot/` and added `RngStream.botPicks`, a stream no rule draws
  from. Deep Pockets going from 4 to 8 pieces was a tuning (`cd90589`), not part of the fix.
- **`random` now:** takes one of the offers, each as likely, drawn from the bot-only stream of the
  run's seed, never "the first offer", which the partner bias fills three times in four.

### 0a. The bot's pick policy for Sprint 7

- **Rule:** SPRINTS_6_7 Task 6 says "build joker when offered, otherwise first offer".
- **Reading:** keep the bot as fixed in Sprint 5, whose fallback is any offer, seeded.
- **Why:** the same file says "use the bot exactly as fixed in Sprint 5"; the first slot is the
  partner of an owned joker three times in four, so "first offer" would chase pairs and inflate
  `random`, which is the bug Sprint 5 fixed.

### 0b. Collector

- **Rule:** Collector becomes "+1 mult per other joker owned"; if combo,collector's "boss win |
  pair done" is still above 45%, "+1 mult per 2 jokers owned" instead.
- **Result:** per other joker gave 59% in Rubble and 48% in Gravity (2,000 runs), above 45% in
  both, so Collector now adds `collectorMultPerJoker` for every two jokers owned, itself included
  (`jokerCount ~/ 2`): 28% in Rubble and 21% in Gravity. Owned alone it adds nothing and doesn't
  fire.
- **Reading:** "above 45%" was checked per world, and one world above was enough.
- **Side effect:** `random` beats the boss less (Rubble 24% to 16%, 56% to 41% once round 4 is
  cleared), since its picks include Collector; Task 0d measures it at 10,000 runs.
- **Saved runs:** a run saved before this build plays the new rule once resumed. Rules aren't
  versioned in the save (only their numbers are), and a mid-run save is rare enough not to warrant
  it.

### 0c. Joker texts read their numbers from RunConfig

- **Finding:** every description already read `JokerTuning`, but four numbers sat in the strings:
  Hat Trick's "3 pieces", Avalanche's "2 rows", Full House's "+1 mult" and the "1–" lower bound of
  Precision and Tiny Tools.
- **Reading:** a number the player reads must be one `RunConfig` holds. Hat Trick's is
  `RunConfig.traySize`, passed to `jokerDescription` (home gets it through
  `JokerCollection.traySize`); Avalanche's and Full House's were engine constants, now
  `JokerTuning.avalancheRows` (2) and `JokerTuning.fullHouseMultPerBlock` (1), read by the effects.
  The "1" of "1–2 cells" is the smallest piece, not a tunable, so the two strings now say "a piece
  of up to $size cells". The plural forms' "1" (Stonemason, Deep Pockets) became the parameter too.
- **Why:** "all numbers go in `RunConfig`" (SPRINTS_6_7, rules common to every task); a test
  checks every number in every description is one of the config's.
- **Save:** the two new fields make the saved run version 8; older saves get 2 and 1, the values
  their builds played.

### 0d. The 10,000-run confirmation

- **Rule:** re-run the final Sprint 5 table at 10,000 runs; change no values unless a target moves
  by more than 3 points, and then stop.
- **Reading:** compared against the 2,000-run final table; "a target" is any metric the Sprint 5
  targets name (round 3, boss win, boss win once round 4 is cleared, boss win with the pair done).
- **Result:** the boss metrics moved by 4 to 17 points for every build, all from Collector's
  change in 0b (the 2,000-run check with the new Collector already showed them). Values unchanged;
  stopped to ask.
- **Decision (user):** fold the boss re-tuning into Sprint 7's Task 6, which re-tunes every
  world's boss against the same targets; Rubble and Gravity play harder bosses until then.

## Task 1: shared engine changes

- **Save versions.** The sprint's "save v4" is our saved run's version 9 (it was 7 after Sprint 5,
  8 after Task 0c). Every field Sprints 6–7 add to a saved run goes in at once here, so Tasks 2–4
  bump nothing: fog cells (codes -2, and -3 hiding a stone), `RoundSpec.fog` / `fogStones` /
  `tideGaps`, `RunState.momentumStreak` and `trayDealt`, and the numbers of Ember, Sprinter,
  Momentum, Symmetry and Prism (2, 5, 2, 4, 15). A save from before reads them as 0 and its tray as
  dealt as it stands; it can't hold fog or those jokers, which it never offers.
- **Speed becomes Tide.** `WorldId.speed` is renamed `tide` (the implementation plan dropped Speed
  for Tide). Every profile stored a locked `speed` entry, since the starting progression lists
  every world, and reading the unknown name would throw the profile away: profile version 6
  renames the entry.
- **A stone under fog in a cleared line.** It goes with the line, as "whatever it hid is gone too"
  says, and isn't counted in `stonesCleared` (Stonemason's chips): the player never saw it.
- **`transformPlacement`.** It maps the piece's cells to the landing cells, or null when it can't
  land; `PiecePlaced.anchor` is the landing cells' top-left. `transformAnchor` stays as that
  top-left, derived from `transformPlacement`, so the Gravity tests run unchanged.
- **`onTrayDealt`.** It receives and returns the run with its events (a `Transition`), runs before
  the tray is dealt, and may lose the round: then no tray is dealt and the round stays lost
  (`_settle` no longer overrides a loss, so a revive now sets the round back to playing before it
  deals).
- **Testing a hook no world uses.** The engine looks rules up through `worldRuleLookup`, which only
  tests replace with a fake rule; the game never does.
- **Momentum's streak** starts each round at 0, as the clear streak does.
