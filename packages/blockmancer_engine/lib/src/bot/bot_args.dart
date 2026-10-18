import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/worlds/world_map.dart';
import 'package:shared_domain/shared_domain.dart';

/// What the balance bot is asked to play: one table row per build, [runs]
/// seeds each, in [world].
typedef BotArgs = ({List<BotBuild> builds, int runs, WorldId world});

/// How the bot picks, every joker on offer whatever a player has unlocked. A
/// pair takes one of its two jokers whenever one is offered (the first named
/// when both are), otherwise any offer, each as likely and drawn from the
/// run's seed; a solo build, one joker, does the same alone; `random` always
/// takes any offer; `empty` skips every pick and plays the run with no joker.
final class BotBuild {
  const BotBuild._({
    required this.jokers,
    required this.name,
    this.picks = true,
  });

  /// A pair of partners, `a,b`, a single joker, or `random` or `empty`;
  /// anything else is a [FormatException].
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

    final valid = switch (jokers) {
      [_] => true,
      [final first, final second] => jokerEffect(first).partner == second,
      _ => false,
    };

    if (!valid) {
      throw FormatException('Not a joker or a pair of partners', name);
    }

    return BotBuild._(jokers: jokers, name: name);
  }

  /// The jokers the bot takes when offered; none for a baseline.
  final List<JokerId> jokers;
  final String name;

  /// False for `empty`, which owns no joker.
  final bool picks;

  /// Whether a run that ended owning [owned] had all of this build's jokers,
  /// both of a pair or a solo's one; null for a baseline, which has none.
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
  'lantern,ember',
  'sprinter,momentum',
  'symmetry,prism',
];

/// Every joker as a solo build, in catalog order.
final List<String> soloBuilds = [
  for (final joker in jokerCatalog) joker.id.name,
];

/// Reads `--runs N`, `--world <world>`, `--solo` (every joker solo, after any
/// `--build`) and any number of `--build a,b`; anything else, a build that is
/// neither a baseline, a joker nor a pair, or a world that can't be played,
/// is a [FormatException].
BotArgs parseBotArgs(List<String> args) {
  final builds = <String>[];
  var solo = false;
  var runs = 2000;
  var world = WorldId.rubble;

  for (var index = 0; index < args.length; index++) {
    final value = index + 1 < args.length ? args[index + 1] : null;

    switch (args[index]) {
      case '--build' when value != null:
        builds.add(value);
        index++;
      case '--solo':
        solo = true;
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
      for (final name in [
        ...builds.isEmpty && !solo ? referenceBuilds : builds,
        if (solo) ...soloBuilds,
      ])
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
