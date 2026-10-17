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
    expect(rules.configFor(.rubble, jokerPool: pool).starThreshold, 8000);
    expect(rules.configFor(.gravity, jokerPool: pool).starThreshold, 8250);
  });

  for (final world in const [WorldId.fog, WorldId.mirror, WorldId.speed]) {
    test('${world.name}, coming soon, is not playable and has no run', () {
      expect(rules.isPlayable(world), isFalse);
      expect(
        () => rules.configFor(world, jokerPool: pool),
        throwsArgumentError,
      );
    });
  }

  test('Rubble and Gravity are playable', () {
    expect(rules.isPlayable(.rubble), isTrue);
    expect(rules.isPlayable(.gravity), isTrue);
  });

  test('the map runs Rubble, Gravity, Fog, Speed, then Mirror', () {
    // Given / When
    final order = rules.worldOrder;

    // Then
    expect(order, const [
      WorldId.rubble,
      WorldId.gravity,
      WorldId.fog,
      WorldId.speed,
      WorldId.mirror,
    ]);
    expect(order.toSet(), WorldId.values.toSet());
  });

  test('each world leads to the next on the map, and the last to none', () {
    expect(rules.nextWorld(.rubble), WorldId.gravity);
    expect(rules.nextWorld(.gravity), WorldId.fog);
    expect(rules.nextWorld(.fog), WorldId.speed);
    expect(rules.nextWorld(.speed), WorldId.mirror);
    expect(rules.nextWorld(.mirror), isNull);
  });

  test('beating Rubble unlocks Stonemason and Quarry, Gravity Anchor and '
      'Avalanche, and the worlds to come nothing yet', () {
    expect(rules.unlocksOf(.rubble), const [
      JokerId.stonemason,
      JokerId.quarry,
    ]);
    expect(rules.unlocksOf(.gravity), const [
      JokerId.anchor,
      JokerId.avalanche,
    ]);
    expect(rules.unlocksOf(.fog), isEmpty);
    expect(rules.unlocksOf(.speed), isEmpty);
    expect(rules.unlocksOf(.mirror), isEmpty);
  });

  test('a new player starts with the 12 jokers no world unlocks', () {
    // Given / When
    final starting = rules.startingJokers;

    // Then
    expect(starting, hasLength(12));
    expect(
      starting.toSet(),
      JokerId.values.toSet().difference(const {
        JokerId.anchor,
        JokerId.avalanche,
        JokerId.quarry,
        JokerId.stonemason,
      }),
    );
  });
}
