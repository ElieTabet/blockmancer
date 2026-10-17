// The balance bot: plays many seeded runs with a greedy policy and a fixed
// joker build, and prints how far they get, for tuning the round targets.
//
//   dart run tool/balance_bot.dart --runs 2000 --build patience,twin
//
// `--build` may be given several times, one table row each; `none` takes the
// first offer every time. With no `--build`, the five reference builds run.
// Seeds are 1 to --runs, so a table is reproducible.
import 'dart:io';
import 'dart:isolate';

import 'package:blockmancer_engine/src/bot/bot_run.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:shared_domain/shared_domain.dart';

const _referenceBuilds = [
  'none',
  'patience,twin',
  'combo,collector',
  'heavy,bigbox',
  'stonemason,quarry',
];

Future<void> main(List<String> args) async {
  final (:builds, :runs) = _parse(args);
  final roundCount = defaultConfig.rounds.length;
  final watch = Stopwatch()..start();

  stdout
    ..writeln(
      '| build | ${[for (var round = 1; round <= roundCount; round++) 'round $round'].join(' | ')} | median total | boss win |',
    )
    ..writeln('|---|${'---|' * roundCount}---|---|');

  for (final name in builds) {
    final summary = summarize(
      await _playAll(_buildOf(name), runs: runs),
      roundCount: roundCount,
    );

    stdout.writeln(
      '| $name | ${summary.roundClearRates.map(_percent).join(' | ')} '
      '| ${summary.medianTotal} | ${_percent(summary.bossWinRate)} |',
    );
  }

  stdout.writeln(
    '\n$runs runs per build, seeds 1–$runs, in ${(watch.elapsedMilliseconds / 1000).toStringAsFixed(1)} s.',
  );
}

/// Seeds 1 to [runs], shared out over one isolate per core.
Future<List<BotRun>> _playAll(List<JokerId> build, {required int runs}) async {
  final workers = Platform.numberOfProcessors;
  final chunks = await Future.wait([
    for (var worker = 0; worker < workers; worker++)
      Isolate.run(
        () => [
          for (var seed = 1 + worker; seed <= runs; seed += workers)
            playBotRun(seed, build: build),
        ],
      ),
  ]);

  return [for (final chunk in chunks) ...chunk];
}

List<JokerId> _buildOf(String name) => name == 'none'
    ? const []
    : [for (final id in name.split(',')) JokerId.values.byName(id.trim())];

String _percent(double share) => '${(share * 100).round()}%';

({List<String> builds, int runs}) _parse(List<String> args) {
  final builds = <String>[];
  var runs = 2000;

  for (var index = 0; index < args.length; index++) {
    final value = index + 1 < args.length ? args[index + 1] : null;

    switch (args[index]) {
      case '--runs' when value != null:
        runs = int.parse(value);
        index++;
      case '--build' when value != null:
        builds.add(value);
        index++;
      default:
        stderr.writeln(
          'Usage: dart run tool/balance_bot.dart [--runs N] [--build a,b]...',
        );
        exit(64);
    }
  }

  return (builds: builds.isEmpty ? _referenceBuilds : builds, runs: runs);
}
