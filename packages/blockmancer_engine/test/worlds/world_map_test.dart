import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

void main() {
  const rules = BlockmancerEngine();
  const pool = [JokerId.patience, JokerId.twin, JokerId.saver];

  test('a Rubble run is the default run, offering only its pool', () {
    // Given / When
    final config = rules.configFor(.rubble, jokerPool: pool);

    // Then
    expect(config, defaultConfig.copyWith(jokerPool: pool));
    expect(config.world, WorldId.rubble);
  });

  test('a Gravity run is the Gravity run, offering only its pool', () {
    // Given / When
    final config = rules.configFor(.gravity, jokerPool: pool);

    // Then
    expect(config, gravityConfig.copyWith(jokerPool: pool));
    expect(config.world, WorldId.gravity);
  });

  test('each world names the run total that earns its third star', () {
    expect(rules.configFor(.rubble, jokerPool: pool).starThreshold, 10500);
    expect(rules.configFor(.gravity, jokerPool: pool).starThreshold, 10500);
    expect(rules.configFor(.fog, jokerPool: pool).starThreshold, 10500);
    expect(rules.configFor(.tide, jokerPool: pool).starThreshold, 9500);
    expect(rules.configFor(.mirror, jokerPool: pool).starThreshold, 10500);
  });

  test('every world is playable, each with a run of its own', () {
    for (final world in WorldId.values) {
      expect(rules.isPlayable(world), isTrue, reason: world.name);
      expect(rules.configFor(world, jokerPool: pool).world, world);
    }
  });

  test('Tide\'s boss rises with 2 gaps and starts with no stones', () {
    // Given / When
    final boss = rules.configFor(.tide, jokerPool: pool).rounds.last;

    // Then
    expect(boss.tideGaps, 2);
    expect(boss.stones, 0);
  });

  test('Fog\'s boss lays 8 fog cells, 3 hiding a stone, and no stones', () {
    // Given / When
    final boss = rules.configFor(.fog, jokerPool: pool).rounds.last;

    // Then
    expect(boss.fog, 8);
    expect(boss.fogStones, 3);
    expect(boss.stones, 0);
  });

  test('the map runs Rubble, Gravity, Fog, Tide, then Mirror', () {
    // Given / When
    final order = rules.worldOrder;

    // Then
    expect(order, const [
      WorldId.rubble,
      WorldId.gravity,
      WorldId.fog,
      WorldId.tide,
      WorldId.mirror,
    ]);
    expect(order.toSet(), WorldId.values.toSet());
  });

  test('each world leads to the next on the map, and the last to none', () {
    expect(rules.nextWorld(.rubble), WorldId.gravity);
    expect(rules.nextWorld(.gravity), WorldId.fog);
    expect(rules.nextWorld(.fog), WorldId.tide);
    expect(rules.nextWorld(.tide), WorldId.mirror);
    expect(rules.nextWorld(.mirror), isNull);
  });

  test('beating Rubble unlocks Stonemason and Quarry, Gravity Anchor and '
      'Avalanche, Fog Lantern and Ember, Tide Sprinter and Momentum, and Mirror '
      'Symmetry and Prism', () {
    expect(rules.unlocksOf(.rubble), const [
      JokerId.stonemason,
      JokerId.quarry,
    ]);
    expect(rules.unlocksOf(.gravity), const [
      JokerId.anchor,
      JokerId.avalanche,
    ]);
    expect(rules.unlocksOf(.fog), const [JokerId.lantern, JokerId.ember]);
    expect(rules.unlocksOf(.tide), const [JokerId.sprinter, JokerId.momentum]);
    expect(rules.unlocksOf(.mirror), const [JokerId.symmetry, JokerId.prism]);
  });

  test(
    'a new player starts with the 12 jokers neither a world nor the stars unlock',
    () {
      // Given / When
      final starting = rules.startingJokers;

      // Then
      expect(starting, hasLength(12));
      expect(
        starting.toSet(),
        JokerId.values.toSet().difference(const {
          JokerId.anchor,
          JokerId.avalanche,
          JokerId.brink,
          JokerId.ember,
          JokerId.finisher,
          JokerId.fullhouse,
          JokerId.hattrick,
          JokerId.lantern,
          JokerId.momentum,
          JokerId.prism,
          JokerId.quarry,
          JokerId.sprinter,
          JokerId.stonemason,
          JokerId.symmetry,
        }),
      );
    },
  );

  test(
    '4 stars unlock Full House and On the Brink, 6 Finisher and Hat Trick',
    () {
      expect(rules.defaultConfig.starUnlocks, const [
        StarUnlock(jokers: [.fullhouse, .brink], stars: 4),
        StarUnlock(jokers: [.finisher, .hattrick], stars: 6),
      ]);
    },
  );
}
