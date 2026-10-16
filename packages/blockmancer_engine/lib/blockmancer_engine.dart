// blockmancer_engine — the game rules, in pure Dart: the implementation of
// shared_domain's GameRules. No Flutter, no clock, no I/O and no dart:math
// Random: a run is a function of its seed and the moves played, so the same
// seed replays identically on every platform.
//
// Composition binds BlockmancerEngine into the features' GameRules slots; no
// feature imports this package. Everything else stays under src/.
export 'src/blockmancer_engine.dart';
