// blockmancer_engine — the game rules, in pure Dart. No Flutter, no clock, no
// I/O and no dart:math Random: a run is a function of its seed and the moves
// played, so the same seed replays identically on every platform.
export 'src/board/board.br.dart';
export 'src/board/cell.br.dart';
export 'src/board/cell_state.br.dart';
export 'src/board/placement.br.dart';
export 'src/events/game_event.br.dart';
export 'src/jokers/joker_catalog.dart';
export 'src/jokers/joker_delta.br.dart';
export 'src/jokers/joker_effect.dart';
export 'src/jokers/joker_hooks.dart';
export 'src/jokers/joker_id.dart';
export 'src/pieces/shape.dart';
export 'src/pieces/shape_catalog.dart';
export 'src/random/daily_seed.dart';
export 'src/random/mulberry32.dart';
export 'src/random/rng_stream.dart';
export 'src/random/weighted_draw.dart';
export 'src/run/engine.dart';
export 'src/run/loss_reason.dart';
export 'src/run/offers.dart';
export 'src/run/placement_preview.br.dart';
export 'src/run/run_config.br.dart';
export 'src/run/run_phase.br.dart';
export 'src/run/run_state.br.dart';
export 'src/scoring/score_move.dart';
