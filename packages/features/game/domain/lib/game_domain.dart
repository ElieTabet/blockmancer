// game_domain — what a run means beyond its rules: which mode it is, the seed
// and jokers it is played with, the best it is measured against, what it earns
// on the map, and the run saved to resume. No storage and no clock of its own:
// each comes in through a slot.
export 'src/contracts/best_scores.dart';
export 'src/contracts/clock.dart';
export 'src/contracts/engagement_store.dart';
export 'src/contracts/progression_store.dart';
export 'src/contracts/run_store.dart';
export 'src/entities/game_launch.dart';
export 'src/entities/engagement.br.dart';
export 'src/entities/game_mode.br.dart';
export 'src/entities/interstitial_caps.dart' show interstitialKeys;
export 'src/entities/progression_change.br.dart';
export 'src/entities/run_end.dart';
export 'src/entities/run_end_record.br.dart';
export 'src/entities/run_start.dart' show RunStart;
export 'src/entities/run_tuning.dart' show RemoteValueFun, runTuningKeys, tuned;
export 'src/entities/saved_run.br.dart';
export 'src/entities/starting_progression.dart';
export 'src/providers.br.dart';
export 'src/providers_di.br.dart';
