import 'package:shared_domain/src/entities/game/cell.br.dart';
import 'package:shared_domain/src/entities/game/game_event.br.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/placement_preview.br.dart';
import 'package:shared_domain/src/entities/game/run_config.br.dart';
import 'package:shared_domain/src/entities/game/run_move.br.dart';
import 'package:shared_domain/src/entities/game/run_state.br.dart';
import 'package:shared_domain/src/entities/game/shape.dart';

/// The next state and what happened on the way, in order.
typedef Transition = (RunState, List<GameEvent>);

/// Blockmancer's rules, as a feature reaches them: injected by composition,
/// never imported. Every call is a pure function of its arguments — the same
/// state and move always give the same result — and an illegal move throws, as
/// callers check [canPlace] first.
abstract interface class GameRules {
  /// Round targets, piece counts and the other tunable numbers.
  RunConfig get defaultConfig;

  bool canPlace(RunState state, {required Cell anchor, required int trayIndex});

  /// Whether [revive] is allowed now.
  bool canRevive(RunState state);

  /// The daily run's seed. The rules have no clock: the caller says what UTC
  /// day it is.
  int dailySeed({required int day, required int month, required int year});

  /// Gives up after a lost round, banking its score.
  Transition endRun(RunState state);

  /// Whether the tray piece at [trayIndex] fits anywhere on the board.
  bool fitsSomewhere(RunState state, {required int trayIndex});

  /// The run total to show: what is banked, plus the round in play.
  int liveRunTotal(RunState state);

  /// The joker [id] pairs with.
  JokerId partnerOf(JokerId id);

  /// Takes an offered joker and starts the next round.
  Transition pickJoker(RunState state, {required JokerId id});

  /// Drops the tray piece at [trayIndex] with its top-left at [anchor].
  Transition place(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  });

  /// What [place] would do there, for the drag shadow.
  PlacementPreview preview(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  });

  /// The run [moves] play from the start of the run of [seed]. Throws on a
  /// move the run couldn't have made.
  RunState replay({
    required RunConfig config,
    required List<RunMove> moves,
    required int seed,
  });

  /// Empties the fullest rows and adds pieces to a lost round.
  Transition revive(RunState state);

  /// The shape a tray slot's id stands for.
  Shape shape(int id);

  /// A new run, waiting for its starting joker.
  RunState startRun({required RunConfig config, required int seed});

  /// The guided first run: always the same board and tray, already in play,
  /// with no joker and a round that never ends on its own. Its bottom row
  /// lacks one cell, so a single piece clears a line.
  RunState tutorialRun({required RunConfig config});
}
