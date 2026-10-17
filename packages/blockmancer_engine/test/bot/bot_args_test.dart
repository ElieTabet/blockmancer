import 'package:blockmancer_engine/src/bot/bot_args.dart';
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
