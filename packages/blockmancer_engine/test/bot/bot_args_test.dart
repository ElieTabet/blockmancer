import 'package:blockmancer_engine/src/bot/bot_args.dart';
import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

void main() {
  test('with no arguments, the reference builds play 2,000 runs in Rubble', () {
    // Given / When
    final args = parseBotArgs(const []);

    // Then
    expect(args.builds, referenceBuilds);
    expect(args.runs, 2000);
    expect(args.world, WorldId.rubble);
  });

  test('the reference builds are none, then each of the 10 pairs once', () {
    // Given / When
    final pairs = [
      for (final build in referenceBuilds.skip(1))
        [for (final name in build.split(',')) JokerId.values.byName(name)],
    ];

    // Then
    expect(referenceBuilds.first, 'none');
    expect(pairs, hasLength(10));
    for (final [first, second] in pairs) {
      expect(jokerEffect(first).partner, second);
    }
    expect(pairs.expand((pair) => pair).toSet(), JokerId.values.toSet());
  });

  test('--world gravity plays Gravity', () {
    expect(parseBotArgs(const ['--world', 'gravity']).world, WorldId.gravity);
  });

  test('each --build is one row, alongside --runs and --world', () {
    // Given / When
    final args = parseBotArgs(const [
      '--build',
      'patience,twin',
      '--world',
      'rubble',
      '--runs',
      '50',
      '--build',
      'none',
    ]);

    // Then
    expect(args.builds, ['patience,twin', 'none']);
    expect(args.runs, 50);
    expect(args.world, WorldId.rubble);
  });

  for (final args in const [
    ['--world', 'fog'],
    ['--world', 'atlantis'],
    ['--world'],
    ['--runs', 'many'],
    ['--seed', '1'],
  ]) {
    test('${args.join(' ')} is refused', () {
      expect(() => parseBotArgs(args), throwsFormatException);
    });
  }
}
