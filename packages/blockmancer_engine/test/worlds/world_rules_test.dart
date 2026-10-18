import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/worlds/gravity_rule.dart';
import 'package:blockmancer_engine/src/worlds/plain_rule.dart';
import 'package:blockmancer_engine/src/worlds/rubble_rule.dart';
import 'package:blockmancer_engine/src/worlds/world_rules.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';

void main() {
  const boss = RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 2000);
  const round = RoundSpec(isBoss: false, pieces: 14, stones: 0, target: 250);

  test('a Rubble run plays its boss by the Rubble rule', () {
    expect(ruleOfRound(defaultConfig, boss), isA<RubbleRule>());
  });

  test('a Gravity run plays its boss by the Gravity rule', () {
    expect(ruleOfRound(gravityConfig, boss), isA<GravityRule>());
  });

  test('the rounds before the boss play by the plain rules in any world', () {
    expect(ruleOfRound(defaultConfig, round), isA<PlainRule>());
    expect(ruleOfRound(gravityConfig, round), isA<PlainRule>());
  });

  for (final world in const [WorldId.fog, WorldId.mirror, WorldId.tide]) {
    test('a run in ${world.name}, coming soon, is refused', () {
      expect(
        () => ruleOfRound(defaultConfig.copyWith(world: world), boss),
        throwsArgumentError,
      );
    });
  }

  test('the Rubble boss starts with the stones its round asks for', () {
    // Given
    const setup = RoundSetup(pieces: 22, stones: 2);

    // When
    final result = const RubbleRule().onRoundSetup(setup, boss);

    // Then
    expect(result.stones, 2 + 6);
    expect(result.pieces, 22);
  });

  test('the Gravity boss starts with no stones of its own', () {
    // Given
    const setup = RoundSetup(pieces: 22, stones: 0);

    // When
    final result = const GravityRule().onRoundSetup(setup, boss);

    // Then
    expect(result.stones, 0);
  });

  test('the plain rules place a piece exactly where it is dropped', () {
    // Given
    final board = boardFrom(['........', '#.......']);

    // When
    final landing = const PlainRule().transformAnchor(
      anchor: const Cell(col: 1, row: 0),
      board: board,
      shape: shapeCatalog[0],
    );

    // Then
    expect(landing, const Cell(col: 1, row: 0));
  });

  test('the plain rules refuse a piece over a filled cell', () {
    // Given
    final board = boardFrom(['#.......']);

    // When
    final landing = const PlainRule().transformAnchor(
      anchor: const Cell(col: 0, row: 0),
      board: board,
      shape: shapeCatalog[0],
    );

    // Then
    expect(landing, isNull);
  });
}
