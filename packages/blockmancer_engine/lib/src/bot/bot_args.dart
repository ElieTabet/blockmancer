import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/worlds/world_map.dart';
import 'package:shared_domain/shared_domain.dart';

/// What the balance bot is asked to play: one table row per build, [runs]
/// seeds each, in [world].
typedef BotArgs = ({List<BotBuild> builds, int runs, WorldId world});

/// How the bot picks, every joker on offer whatever a player has unlocked. A
/// pair takes one of its two jokers whenever one is offered (the first named
/// when both are), otherwise the first offer; `random` always takes the first
/// offer, which the offers' own draw makes random; `empty` skips every pick
/// and plays the run with no joker.
final class BotBuild {
  const BotBuild._({
    required this.jokers,
    required this.name,
    this.picks = true,
  });

  /// A pair of partners, `a,b`, or `random` or `empty`; anything else is a
  /// [FormatException].
  factory BotBuild.parse(String name) {
    if (name == 'random') return const ._(jokers: [], name: 'random');

    if (name == 'empty') {
      return const ._(jokers: [], name: 'empty', picks: false);
    }

    final jokers = [
      for (final id in name.split(','))
        JokerId.values.asNameMap()[id.trim()] ??
            (throw FormatException('Not a joker', id)),
    ];

    if (jokers case [
      final first,
      final second,
    ] when jokerEffect(first).partner == second) {
      return BotBuild._(jokers: jokers, name: name);
    }

    throw FormatException('Not a pair of partners', name);
  }

  /// The jokers the bot takes when offered; none for a baseline.
  final List<JokerId> jokers;
  final String name;

  /// False for `empty`, which owns no joker.
  final bool picks;

  /// Whether a run that ended owning [owned] had both of this pair's jokers;
  /// null for a baseline, which has no pair.
  bool? completedBy(List<JokerId> owned) =>
      jokers.isEmpty ? null : jokers.every(owned.contains);
}

/// The two baselines, then every pair.
const referenceBuilds = [
  'random',
  'empty',
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
/// anything else, a build that is neither a baseline nor a pair, or a world
/// that can't be played, is a [FormatException].
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
    builds: [
      for (final name in builds.isEmpty ? referenceBuilds : builds)
        BotBuild.parse(name),
    ],
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
