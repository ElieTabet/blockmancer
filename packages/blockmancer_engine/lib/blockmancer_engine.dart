// blockmancer_engine — the game rules, in pure Dart. No Flutter, no clock, no
// I/O and no dart:math Random: a run is a function of its seed and the moves
// played, so the same seed replays identically on every platform.
export 'src/board/board.br.dart';
export 'src/board/cell.br.dart';
export 'src/board/cell_state.br.dart';
export 'src/board/placement.br.dart';
export 'src/pieces/shape.dart';
export 'src/pieces/shape_catalog.dart';
