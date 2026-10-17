import 'package:blockmancer_engine/src/worlds/world_map.dart';
import 'package:shared_domain/shared_domain.dart';

/// What the balance bot is asked to play: one table row per build, [runs]
/// seeds each, in [world].
typedef BotArgs = ({List<String> builds, int runs, WorldId world});

/// No joker build, then every pair.
const referenceBuilds = [
  'none',
  'patience,twin',
  'combo,collector',
  'heavy,bigbox',
  'precision,tiny',
  'column,sweep',
  'pockets,saver',
  'stonemason,quarry',
  'anchor,avalanche',
  'fullhouse,brink',
  'finisher,hattrick',
];

/// Reads `--runs N`, `--world <world>` and any number of `--build a,b`;
/// anything else, or a world that can't be played, is a [FormatException].
BotArgs parseBotArgs(List<String> args) {
  final builds = <String>[];
  var runs = 2000;
  var world = WorldId.rubble;

  for (var index = 0; index < args.length; index++) {
    final value = index + 1 < args.length ? args[index + 1] : null;

    switch (args[index]) {
      case '--build' when value != null:
        builds.add(value);
        index++;
      case '--runs' when value != null:
        runs = int.parse(value);
        index++;
      case '--world' when value != null:
        world = _playableWorld(value);
        index++;
      case final arg:
        throw FormatException('Unexpected argument', arg);
    }
  }

  return (
    builds: builds.isEmpty ? referenceBuilds : builds,
    runs: runs,
    world: world,
  );
}

WorldId _playableWorld(String name) {
  final world = WorldId.values.asNameMap()[name];

  if (world == null || !isPlayable(world)) {
    throw FormatException('Not a playable world', name);
  }

  return world;
}
