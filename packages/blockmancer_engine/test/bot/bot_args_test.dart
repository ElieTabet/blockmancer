import 'package:blockmancer_engine/src/bot/bot_args.dart';
import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

void main() {
  test('with no arguments, the reference builds play 2,000 runs in Rubble', () {
    // Given / When
    final args = parseBotArgs(const []);

    // Then
    expect([for (final build in args.builds) build.name], referenceBuilds);
    expect(args.runs, 2000);
    expect(args.world, WorldId.rubble);
  });

  test('the reference builds are both baselines, then each pair '
      'once', () {
    // Given / When
    final pairs = [
      for (final build in referenceBuilds.skip(2))
        [for (final name in build.split(',')) JokerId.values.byName(name)],
    ];

    // Then
    expect(referenceBuilds.take(2), ['random', 'empty']);
    expect(pairs, hasLength(jokerCatalog.length ~/ 2));
    for (final [first, second] in pairs) {
      expect(jokerEffect(first).partner, second);
    }
    expect(pairs.expand((pair) => pair).toSet(), JokerId.values.toSet());
  });

  test(
    '--solo plays every joker alone, in catalog order, after any --build',
    () {
      // Given / When
      final args = parseBotArgs(const ['--solo', '--build', 'random']);

      // Then
      expect(
        [for (final build in args.builds) build.name],
        ['random', for (final joker in jokerCatalog) joker.id.name],
      );
    },
  );

  test('--world fog plays Fog', () {
    expect(parseBotArgs(const ['--world', 'fog']).world, WorldId.fog);
  });

  test('--world tide plays Tide', () {
    expect(parseBotArgs(const ['--world', 'tide']).world, WorldId.tide);
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
      'random',
    ]);

    // Then
    expect(
      [for (final build in args.builds) build.name],
      ['patience,twin', 'random'],
    );
    expect(args.runs, 50);
    expect(args.world, WorldId.rubble);
  });

  group('a build', () {
    test('a pair takes its two jokers, both picking', () {
      // Given / When
      final build = BotBuild.parse('patience,twin');

      // Then
      expect(build.jokers, [JokerId.patience, JokerId.twin]);
      expect(build.picks, isTrue);
    });

    test('a single joker is a solo build, completed by owning it', () {
      // Given / When
      final build = BotBuild.parse('pockets');

      // Then
      expect(build.jokers, [JokerId.pockets]);
      expect(build.completedBy(const [.combo, .pockets]), isTrue);
      expect(build.completedBy(const [.combo]), isFalse);
    });

    test('random picks with no joker of its own, empty never picks', () {
      // Given / When
      final random = BotBuild.parse('random');
      final empty = BotBuild.parse('empty');

      // Then
      expect(random.jokers, isEmpty);
      expect(random.picks, isTrue);
      expect(empty.jokers, isEmpty);
      expect(empty.picks, isFalse);
    });

    test('a pair is completed only by a run holding both its jokers', () {
      // Given
      final build = BotBuild.parse('patience,twin');

      // When / Then
      expect(build.completedBy(const [.combo, .patience, .twin]), isTrue);
      expect(build.completedBy(const [.combo, .patience]), isFalse);
      expect(BotBuild.parse('random').completedBy(const [.combo]), isNull);
    });
  });

  for (final args in const [
    ['--build', 'none'],
    ['--build', 'patience,combo'],
    ['--build', 'patience,wizard'],
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
