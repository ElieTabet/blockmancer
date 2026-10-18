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

## Task 2: Fog, Lantern and Ember

- **Where the fog goes.** "8 fog cells on empty cells, positions from the stones stream" draws
  each from the same cells a stone may land on (`stoneCells`): empty cells that wouldn't complete a
  line, since fog counts as occupied and a line full of fog at the boss's start would be credited
  to whatever move came next. The first 3 laid hide a stone.
- **Which fog lifts.** Fog sharing a side with any cell of the placed piece lifts, even where that
  cell was cleared on the same move: it was placed there. Fog inside the cleared lines went with
  them before the reveal (place, score and clear, Lantern, reveal).
- **Lantern and stones under fog.** Lantern takes a fog cell whatever it hid; the hidden stone goes
  with it, never revealed.
- **What Lantern's removals count for.** For Ember, as the sprint says, and for Full House's
  "occupied as the piece lands" (they were occupied); not for Stonemason, whose chips are per
  stone cleared in a line, since Lantern's removals add no chips.
- **Ember's count.** Stones and fog cells (whatever they hid) in the cleared lines, plus Lantern's
  removals; one or more doubles the mult once.
- **Two more world-rule hooks.** Fog needs to change the board at the boss's start and after each
  move, which neither of Task 1's hooks does: `onBoardSetup` and `afterPlacement`.
- **The bot and hidden stones.** The greedy bot scores a move by placing it, which reveals fog; its
  tie-break (fewest occupied cells) would see a revealed stone. It counts a fog cell that turned to
  stone as empty, so a reveal's outcome never steers it, as the sprint requires.
- **Provisional numbers.** Fog's boss target (5,500) and ★3 threshold (12,000) are a step above
  Gravity's until Task 6 sets them from the bot.
- **The pick sheet's boss line** said "with stones" for every world, Gravity's included; it now
  names each world's twist.
- **The "every joker" seeded golden** now plays the 20 jokers before Fog, like the other frozen
  goldens, so each new joker doesn't re-pin it.

## Task 3: Tide, Sprinter and Momentum

- **The order of a rise.** The tide rises, then the flood is judged, then the tray is dealt. A
  flood still shows the risen board (what left the top is gone), loses the round and deals no
  tray. A revive deals one without a rise (review fix 2).
- **Gap columns.** Two distinct columns drawn one after the other from the stones stream (the
  first among 8, the second among the 7 left). A rise never completes a row; it can complete a
  column (7 cells under a stone), which clears at once for nothing (review fix 1).
- **"Tide in N".** N is the pieces left in the tray in hand, shown only during Tide's boss.
- **A fresh tray's first piece** (Sprinter, Momentum) is the move made while every piece the tray
  was dealt is still in it; `RunState.trayDealt` records how many that was, so a short final tray
  counts too.
- **Momentum's streak** is set as each tray's first piece is played: one more if it clears, 0 if
  not (0 for the rest of that tray), and it starts each round at 0. It adds on every clearing move
  of the tray, the first included.
- **The slide.** The board already shows a move's result when its playback starts; with a rise, it
  draws its cells a row lower until the rising beat (the move's last) lifts them, so the piece and
  the burst land where they stood before the rise.
- **Seeded tests and new jokers.** The replay tests now play the 20 jokers before Fog
  (`briefConfigBeforeFog`), so appending jokers doesn't take their builds off offer.
- **Provisional numbers.** Tide's boss target (5,750) and ★3 threshold (12,500) are a step above
  Fog's until Task 6. The greedy bot rarely survives the boss (it ignores the coming rise, as the
  sprint expects); Task 6 reports it.

## Task 4: Mirror, Symmetry and Prism

- **The preview of a mirrored drop that doesn't fit** shows the mirrored cells, red where they
  collide, rather than the cells under the finger: "`canPlace` and `preview` work on the landing
  cells". A third hook, `previewPlacement`, says where a piece is shown going whether it fits or
  not; by default that is where it lands, else where it was dropped, which keeps Gravity's preview
  as it was.
- **Prism's count.** Every filled cell or stone whose mirror cell is one too counts, so a matched
  pair counts twice (once per cell), as "per occupied cell" reads. With 8 columns no cell is its
  own mirror.
- **Symmetry and Prism read the board after the clear and Lantern**, before Quarry drops its stone
  (Quarry acts after the move is scored).
- **The finger's outline** shows only in Mirror's boss; Gravity's drag still shows the landing
  alone, as before.
- **Provisional numbers.** Mirror's boss target (6,000) and ★3 threshold (13,000) are a step above
  Tide's until Task 6.

## Task 5: map, detail sheets, boss cards, Spellbook

- **Data, not screens.** The map, the world sheets and the Spellbook already read the rules'
  `worldOrder`, `isPlayable`, `unlocksOf` and the joker collection: with every world playable no
  node says "Coming soon" (the status stays for a world added later) and the Spellbook shows 13
  pairs, with no screen change.
- **Which worlds have a first-time card.** Every world but the map's first: the sprint lists
  Gravity, Fog, Tide and Mirror, and the rule is "not the first world" rather than a list, so a
  world added later gets its card with its strings. Rubble's card exists too, for the sheet's
  replay, but never interrupts a new player's first boss.
- **When it shows.** The first time a world run's boss round starts in that world, once the move
  that started it has played back; not in daily or practice runs, which play the first world, and
  not when a saved run is resumed already inside the boss.
- **Where "seen" lives.** In `Progression.bossCardsSeen` (profile version 7), so Reset progress
  shows the cards again with everything else. Older profiles count every world whose boss they
  have beaten as seen: the player has met that rule.
- **One card for game and home.** The card lives in `game_presentation`; the world sheet replays it
  through `HomeRouting.onBossCardRequested`, which `app_router` answers with `showBossCard`, so
  neither feature imports the other.
- **"A world complete moment".** Read as the whole map complete: a sheet once the last world's
  boss first falls ("Every world complete", the stars held out of 15), shown over the map once its
  celebration has settled, with every node already lit (done) behind it. Reduce motion shows it
  too, without the celebration before it.
- **Star unlocks** stay at 4★ and 6★, out of 15 now.
- **Device checks left to the user:** a full run from Rubble to Mirror on a phone, and the map at
  60 fps in profile mode on a mid-range Android phone with every node open.

## Review fixes (after Task 5)

Three changes from the review of this file, each its own commit.

### 1. A line the tide completes

- **Rule:** any line completed by a rise clears immediately, scoring nothing and leaving the clear
  streak unchanged (`LinesCleared` with a tide source).
- **Reading:** `TideRule` resolves clears on the risen board straight after `TideRose`, before the
  flood is judged (what left the top is gone either way) and before the tray is dealt.
  `LinesCleared` gains `source` (`ClearSource.move` by default, `.tide` here). No chips, no mult,
  no joker hook, no streak, Momentum's included; Ember and Stonemason never see it.
- **Why:** as for fog at the boss's start (Task 2), no move gets credit for a line it didn't
  complete. Until now such a column waited for the next placement, which scored it.
- **The game:** the move's own clear is the one with the move's source; the tide's bursts after
  the board has risen, its cells drawn standing until then (`PlaybackState.tideAhead`), each as it
  stood (the piece's colour where it landed, the stone row at the bottom).

### 2. The tray a revive deals

- **Rule:** the tray dealt by a revive never triggers a rise (like the boss's first tray), so a
  revive can't flood again at once.
- **Reading:** this replaces the sprint's "a tray dealt after a revive also triggers a rise". The
  world rule's hook is now told `afterMove` (a move played the last tray out) instead of
  `firstOfRound`; only those trays rise. A revive from "no room" with pieces still in the tray
  deals nothing, as before.
- **Why:** a flood means the board reached the top, and the revive empties only the fullest
  rows, which needn't include the top one; rising again before the first piece could flood the
  revived round at once, and the revive would buy nothing.

### 3. `onRoundSetup` and `onBoardSetup`

- **Kept apart:** `onRoundSetup` sets the round's counts (pieces, Rubble's stones) before the
  jokers add theirs (Deep Pockets' pieces, Stonemason's stones) and the engine lays every stone in
  one draw, while `onBoardSetup` edits the board once those stones are down (Fog's fog, which must
  avoid them); merging them would take Rubble's stones out of that shared count and draw.

### 4. Worlds earned before they had rules (found on device)

- **Problem:** a player who beat Gravity's boss before Fog was playable found Fog locked ("beat
  the previous boss to unlock"): the win opened no world then, and Task 2 made Fog playable
  without opening it for them, which CLAUDE.md had said the release must do.
- **Reading:** rather than a one-off profile migration, `game_domain` reads every progression
  through `EarnedWorldsStore`, which opens each playable world after a beaten boss; the next write
  keeps it. It is worked out from the rules, so it covers any world made playable later, and the
  data layer, which doesn't know the rules, stays out of it. The map opens it without a
  celebration (a cold start settles on what it reads); its jokers still come from beating its
  own boss.

## Task 6: balance pass

### The bot in Tide's boss

- **Problem:** every bot build lost Tide's boss to a flood, even with 12 pieces or 4 gaps. Two
  details of its tie-break, not the boss, did it. It takes the first placement scanned, from the
  top row, so a piece that scores no more anywhere was stacked in the rows the next rise pushes
  off. And "fewest occupied cells after the move" preferred a flood, which leaves fewer cells (the
  ones it pushed off).
- **Reading:** in Tide's boss the scan runs from the bottom row up, and a flooding move ranks last
  among moves that score as much. The bot still never looks ahead to the rise, as the sprint
  says; it stops walking into it. Every other world and round plays exactly as before, so their
  tables are unchanged.
- **Why:** the sprint expects the bot to do worse than players in Tide, not to lose every run; at
  0% no target can be set from it.

### Setting the bosses

- **Rule:** "boss win | r4 cleared" 50–65% and each world's boss slightly harder than the last for
  `random`, with separate boss targets.
- **Reading:** "harder" is read on `random`'s overall boss win (23 / 22 / 21 / 20 / 19%), with the
  rate once round 4 is cleared falling too (59 / 55 / 55 / 52 / 50%). A harder rule needs a lower
  target to stay in range, so the targets don't rise along the map (4,250 / 4,000 / 4,250 / 3,000 /
  4,250); the boss does.
- **How:** the bot never reads the boss's target, so a pass with the target out of reach gives
  every candidate target's win rate at once (a temporary tool, not committed); the full tables
  then checked the picks.

### Where the pass stopped

- **Rule:** iterate at 2,000 runs (at most 12), confirm at 10,000.
- **Decision (user):** stop after iteration 5, without the 10,000-run confirmation. The values are
  iteration 4's; iteration 5 (Precision +5) overcorrected and was reverted. The report gives the
  2,000-run margin with every figure.
- **★3:** the P80 of each world's best pair over its pair-done runs, rounded down to 250, from
  those 2,000-run tables; Patience/Twin is the best pair in every world.
- **Outliers kept:** the planning pairs and Lantern/Ember (the bot can't use them, and Lantern and
  Ember have nothing to act on before the boss), Pockets/Saver in Tide, and Patience/Twin and
  Precision/Tiny a point or three over 40% (inside the margin). Each is explained in
  docs/balance/2026-10-18-sprint7.md.

## After Task 6

### Ember on every clear

- **Rule (user):** Ember gives +3 mult on every clear, so Lantern + Ember isn't dead for four
  rounds.
- **Reading:** added to what Ember did: +`emberMult` (3) in the additive pass on every clearing
  move, then its ×`emberFactor` (4) when the move takes a stone or fog. A new `JokerTuning` field
  makes the saved run version 10; older saves resume with 0, the rule they were played with.
- **Measured (2,000 runs, not re-tuned):** with the base mult at 1, +3 makes every clear score 4×.
  Lantern/Ember beats the boss in 65–89% of pair-done runs (target 25–40%), and `random`, which
  picks Ember, clears round 3 in 71% and beats the boss in 28–32% (targets ≈ 65% and 15–25%).
  At +1: `random` 70% / 27% in Rubble, Lantern/Ember 48% in Rubble and 23% in Gravity. Left at +3
  as asked; the figures are in docs/balance/2026-10-18-sprint7.md for the next tuning.

## Sprint 8, Task 0

### a. Ember adds or multiplies, never both

- **Rule (SPRINT_8 prompt):** "+3 mult on every clearing move; ×2 mult instead when the move
  removes at least one stone or fog cell".
- **Reading:** a clearing move that takes no stone and no fog adds `emberMult` (3); one that takes
  any, in its lines or beside them through Lantern, multiplies by `emberFactor` (2) and adds
  nothing. "Instead" rules out both on one move, which Ember did for a day (+3 and ×4).
  `emberFactor` goes back from 4 to 2; both numbers stay in `JokerTuning`, so the save (version
  10) doesn't change.

### b. `random` at 10,000 runs, and the order of the bosses

- **Rule:** re-run `random` at 10,000 runs in each world; change a value only if its boss win
  stops falling Rubble > Gravity > Fog > Tide > Mirror.
- **Finding:** 27.3 / 27.4 / 26.6 / 23.1 / 26.7% — Gravity above Rubble, Mirror above Tide.
- **Change:** three boss targets, the smallest moves that restore the order from the exact curve
  on the same seeds: Gravity 4,125, Fog 4,375, Mirror 4,750 (27.3 / 26.3 / 25.8 / 23.1 / 22.4%).
  Round 3 at 72%, the overall boss win above 25% and Mirror's 47% once round 4 is cleared stay
  as they are: the rule allowed only the order to be fixed. They are in
  docs/balance/2026-10-18-sprint7.md for the next tuning.

### c. Version

- Already 1.0.0 (build 3) since the version fix; nothing changed. The build number goes up at
  release.

## Sprint 8, Task 1: Firebase core

- **Remote Config reaches the next run, not the screen's.** The tuned config is applied where a
  run starts, and where the map and Spellbook read their numbers, through a `remoteValue` slot;
  the rules binding never changes, because `GameNotifier` watches it and a new instance would
  restart the run in play. A run saved mid-way resumes with the config it began with.
- **What counts as a bad value.** Anything that isn't a number (an int for int keys), or falls
  outside its key's range, is ignored and that key keeps the default; the other keys still apply.
  The ranges keep a run playable (a factor never below 1, at most 3 offers, 1 to 7 tide gaps).
- **One key per number, not a JSON blob:** the sprint asks for a table of every key; 68 keys, each
  editable on its own in the console.
- **The daily run** is tuned like any other: Remote Config is the same for everyone, so everyone
  still plays the same run, except a player whose fetch is older by up to 12 hours.
- **Minimum fetch interval:** 12 hours in release builds (two fetches a day, well inside Remote
  Config's limits), 5 minutes in test builds so a published value reaches a tester quickly.
- **Force and optional updates.** "Malformed" covers the published versions and the app's own:
  either asks nothing, so a typo can't lock players out. The splash waits at most 2 seconds for
  the launch's fetch, so raising `min_version_*` stops a broken version from its next launch
  without holding a slow network's splash. The update screen has no way out (back included); the
  banner sits at the top of the map and closes per version.
- **`TEST_TOOLS` in a debug run** is off unless passed: a debug run is a developer's, not a
  tester's. "Local stats data deleted once": a release build deletes the key at every launch;
  nothing writes it there, so that deletes it once.
- **The test crash** is a Settings row in test builds only ("Crashlytics receives a test crash from
  a test build"), calling Crashlytics' own `crash()`.
- **Placeholders in one file.** `app/env/prod.json` holds every store and AdMob ID, read by the
  Dart code with `String.fromEnvironment` and by the release scripts, which fail while a
  `PLACEHOLDER_` is left (a test build only warns). The AdMob IDs are already the real ones; the
  App Store id is the one placeholder so far.

## Sprint 8, Task 2: consent

- **ATT through UMP.** AdMob's IDFA explainer shows Apple's tracking alert itself once the player
  continues (AdMob's help: "If users click Continue, the iOS ATT alert screen is displayed"), so no
  ATT package was added; the app supplies the alert's text.
- **When the form shows:** every launch, once the first frame is up, never blocking the game; only
  ads wait for it (the ad SDK starts once ads may be requested). The splash isn't held for it.
- **Analytics consent mode from UMP:** granted when ads may be requested, denied otherwise, for
  all four consent types at once. A player who declines in the EEA still gets "may request ads"
  (limited ads), so the finer detail is the TCF string UMP writes, which the Google SDKs read;
  to check on a device with the EEA debug geography.
- **Who decides:** `settings_domain` owns consent (it owns the Privacy choices row); `ads` only
  talks to UMP and `telemetry` only sets the mode. Composition wires the three.
- **Native app ids in the native files.** AdMob's app id is read by native code at launch, so it
  sits in `Info.plist` and the manifest (the real ids: Google's guidance is to test with test ad
  units, not a test app id); `app/env/prod.json` keeps what Dart reads. The placeholder check
  scans both.
- **The privacy links** are the studio's site: `/privacy` and `/support`, as the sprint says.
- **French for the tracking alert:** the alert's text is English only for now; a French
  `InfoPlist.strings` needs the Xcode project's localizations, left for the store pass (Task 8).

## Sprint 8, Task 3: ads

- **"Between runs only"** is read as: when the player moves on from a finished run — Play again, or
  leaving its screen — never as the run ends (its end screen and celebration come first), never
  mid-run, never in the tutorial.
- **"The player's first session"** is the device's first launch, counted at boot from the
  engagement record: nothing interrupts it, however many runs it holds.
- **The caps.** "Not before the 3rd completed run": the run that just ended counts, so the third run
  end can show one. "At most every 2nd run end": a count of run ends since the last interstitial,
  reset when one shows. "At least 90 s apart": from the last one shown. A completed run is any run
  played to its end (daily, practice or world), never the tutorial.
- **An interstitial that fails to show** counts as nothing: the next run end may try again.
- **"Never a dead tap":** the revive button reads "No ad to revive with right now" and is disabled
  while no rewarded ad is loaded; it comes back by itself once one loads.
- **A rewarded ad closed early** revives nothing: only a reward earned does.
- **Preloading:** both ads load at launch (after consent), again after each show, and each run's
  start asks again in case a load failed: the run's end never waits on the network.
- **Ad events** go to Firebase only; the testers' on-device log counts play, not ads.

## Sprint 8, Task 4: Remove ads

- **Where it lives:** a small `shop` feature (domain and data, no screens) owns the entitlement;
  the game reads it through a slot and Settings shows its rows through slots, so neither knows the
  other or the plugin.
- **Product id:** `remove_ads` on both stores (a store-specific id would only add a mapping).
- **"Re-checked from the store on launch":** a restore at launch, quiet (not counted as the
  player's restore). It only ever adds the entitlement: a store that reports nothing (offline, a
  slow restore) never takes it away; refunds are the stores' to handle.
- **A restore the player asks for** waits up to 3 seconds for the store's report, then says
  "Purchases restored" or "Nothing to restore".
- **purchase_failed's code:** `canceled` when the player backs out of the store's sheet,
  `unavailable` when the store couldn't open it, otherwise the store's own error code.
- **A pending purchase** (parental approval) changes nothing until the store completes it.
- **The info popup:** the design system had only error and confirm popups; `DSPopup.showInfo`
  (a check) says a restore worked.

## Sprint 8, Task 5: rating prompt

- **"After the celebration finishes":** the run-end sheet's entrance (300 ms) plus its new stars'
  pop (900 ms, none under reduce motion). An unlock sheet comes first and isn't the moment: the
  run end, where Play again is, is. Leaving before then asks nothing.
- **"2 different days since install":** the app opened on at least 2 different local days, the
  install day included (`Engagement.daysOpened`).
- **"No crash in this session":** no uncaught error reached Flutter's or the platform's handlers
  since launch (a crash ends the session anyway; an error survived is the signal).
- **A daily or practice run's boss win** counts as a boss win; their runs earn no stars.
- **Once per version, then the cooldown:** both hold; a new version may ask again only once the
  cooldown since the last ask has passed.
- **Recorded before asking:** the ask is kept before the OS is called, so a crash inside the OS's
  sheet can't make the app ask twice.

## Sprint 8: real ids

- **Every id in one file**, as asked: `app/env/prod.json` now holds the AdMob app ids too (Gradle
  reads them into the manifest; an Xcode build phase writes the iOS one into the built
  Info.plist, failing the build if it is missing), alongside the ad units, the product id and the
  leaderboard ids. This replaces Task 2's app ids written in the native files.
- **Ids every build needs vs release-only:** the app ids are read in every build (the ad SDK stops
  without one); the ad units, product and leaderboard ids come from the file's dart-defines, which
  the build scripts pass; a debug run passes it itself (`flutter run
  --dart-define-from-file=env/prod.json`) to buy or reach the leaderboards.
- **Play's purchase option id** (`buy`) needs no code: `in_app_purchase` buys the product's default
  option.
- **Test devices** come from `ADMOB_TEST_DEVICE_IDS` (empty until the ids are sent), set before the
  ad SDK starts; AdMob's own test-device list covers the rest.
- **SKAdNetwork:** the 50 identifiers on AdMob's "SKAdNetwork" page (developers.google.com/admob/
  ios/privacy/strategies), read from the page itself on 18 October.
