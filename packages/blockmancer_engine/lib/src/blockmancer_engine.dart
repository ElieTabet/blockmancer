import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:blockmancer_engine/src/random/daily_seed.dart' as seeds;
import 'package:blockmancer_engine/src/run/default_config.dart' as config;
import 'package:blockmancer_engine/src/run/engine.dart' as engine;
import 'package:blockmancer_engine/src/run/replay.dart' as replays;
import 'package:blockmancer_engine/src/run/tutorial.dart' as tutorial;
import 'package:blockmancer_engine/src/worlds/world_map.dart' as map;
import 'package:shared_domain/shared_domain.dart';

/// Blockmancer's rules behind the [GameRules] contract. Composition binds it;
/// no feature imports it.
final class BlockmancerEngine implements GameRules {
  const BlockmancerEngine();

  @override
  RunConfig get defaultConfig => config.defaultConfig;

  @override
  List<JokerId> get startingJokers => map.startingJokers;

  @override
  List<WorldId> get worldOrder => map.worldOrder;

  @override
  bool canPlace(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) => engine.canPlace(state, anchor: anchor, trayIndex: trayIndex);

  @override
  bool canRevive(RunState state) => engine.canRevive(state);

  @override
  RunConfig configFor(WorldId world, {required List<JokerId> jokerPool}) =>
      map.configFor(world, jokerPool: jokerPool);

  @override
  int dailySeed({required int day, required int month, required int year}) =>
      seeds.dailySeed(day: day, month: month, year: year);

  @override
  Transition endRun(RunState state) => engine.endRun(state);

  @override
  bool fitsSomewhere(RunState state, {required int trayIndex}) =>
      engine.fitsSomewhere(state, trayIndex: trayIndex);

  @override
  bool isPlayable(WorldId world) => map.isPlayable(world);

  @override
  int liveRunTotal(RunState state) => engine.liveRunTotal(state);

  @override
  WorldId? nextWorld(WorldId world) => map.nextWorld(world);

  @override
  JokerId partnerOf(JokerId id) => jokerEffect(id).partner;

  @override
  Transition pickJoker(RunState state, {required JokerId id}) =>
      engine.pickJoker(state, id: id);

  @override
  Transition place(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) => engine.place(state, anchor: anchor, trayIndex: trayIndex);

  @override
  PlacementPreview preview(
    RunState state, {
    required Cell anchor,
    required int trayIndex,
  }) => engine.preview(state, anchor: anchor, trayIndex: trayIndex);

  @override
  RunState replay({
    required RunConfig config,
    required List<RunMove> moves,
    required int seed,
  }) => replays.replay(config: config, moves: moves, seed: seed);

  @override
  Transition revive(RunState state) => engine.revive(state);

  @override
  Shape shape(int id) => shapeCatalog[id];

  @override
  RunState startRun({required RunConfig config, required int seed}) =>
      engine.startRun(config: config, seed: seed);

  @override
  RunState tutorialRun({required RunConfig config}) =>
      tutorial.tutorialRun(config: config);

  @override
  List<JokerId> unlocksOf(WorldId world) => map.unlocksOf(world);
}
