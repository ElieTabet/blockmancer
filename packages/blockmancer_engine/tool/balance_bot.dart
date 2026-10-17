// The balance bot: plays many seeded runs with a greedy policy and a fixed
// joker build, and prints how far they get, for tuning the round targets.
//
//   dart run tool/balance_bot.dart --runs 2000 --build patience,twin --world gravity
//
// `--build` may be given several times, one table row each; `none` takes the
// first offer every time. With no `--build`, `none` and every pair run.
// `--world` is rubble (the default) or gravity, whose rule holds in the boss.
// Offers draw from every joker, so any build can be offered whatever the
// player has unlocked. Seeds are 1 to --runs, so a table is reproducible.
import 'dart:io';
import 'dart:isolate';

import 'package:blockmancer_engine/src/bot/bot_args.dart';
import 'package:blockmancer_engine/src/bot/bot_run.dart';
import 'package:blockmancer_engine/src/worlds/world_map.dart';
import 'package:shared_domain/shared_domain.dart';

Future<void> main(List<String> args) async {
  final BotArgs(:builds, :runs, :world) = _parse(args);
  final config = configFor(world, jokerPool: JokerId.values);
  final roundCount = config.rounds.length;
  final watch = Stopwatch()..start();

  stdout
    ..writeln(
      '| build | ${[for (var round = 1; round <= roundCount; round++) 'round $round'].join(' | ')} | P50 total | P80 total | boss win |',
    )
    ..writeln('|---|${'---|' * roundCount}---|---|---|');

  for (final name in builds) {
    final summary = summarize(
      await _playAll(_buildOf(name), config: config, runs: runs),
      roundCount: roundCount,
    );

    stdout.writeln(
      '| $name | ${summary.roundClearRates.map(_percent).join(' | ')} '
      '| ${summary.p50Total} | ${summary.p80Total} '
      '| ${_percent(summary.bossWinRate)} |',
    );
  }

  stdout.writeln(
    '\n${world.name}: $runs runs per build, seeds 1–$runs, in '
    '${(watch.elapsedMilliseconds / 1000).toStringAsFixed(1)} s on '
    '${Platform.numberOfProcessors} cores.',
  );
}

/// Seeds 1 to [runs], shared out over one isolate per core.
Future<List<BotRun>> _playAll(
  List<JokerId> build, {
  required RunConfig config,
  required int runs,
}) async {
  final workers = Platform.numberOfProcessors;
  final chunks = await Future.wait([
    for (var worker = 0; worker < workers; worker++)
      Isolate.run(
        () => [
          for (var seed = 1 + worker; seed <= runs; seed += workers)
            playBotRun(seed, build: build, config: config),
        ],
      ),
  ]);

  return [for (final chunk in chunks) ...chunk];
}

List<JokerId> _buildOf(String name) => name == 'none'
    ? const []
    : [for (final id in name.split(',')) JokerId.values.byName(id.trim())];

String _percent(double share) => '${(share * 100).round()}%';

BotArgs _parse(List<String> args) {
  try {
    return parseBotArgs(args);
  } on FormatException catch (error) {
    stderr
      ..writeln('${error.message}: ${error.source}')
      ..writeln(
        'Usage: dart run tool/balance_bot.dart [--runs N] '
        '[--world rubble|gravity] [--build a,b]...',
      );
    exit(64);
  }
}
