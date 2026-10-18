import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fakes.dart';

const _rules = TwoWorldRules();

/// Rubble's run with four rounds before its boss, as the engine plays it.
RunConfig _rubble() {
  final config = _rules.configFor(.rubble, jokerPool: const []);
  final boss = config.rounds.single;

  return config.copyWith(
    rounds: [
      for (var round = 1; round <= 4; round++)
        RoundSpec(
          isBoss: false,
          pieces: 12 + round,
          stones: 0,
          target: 100 * round,
        ),
      boss,
    ],
  );
}

RemoteValueFun _published(Map<String, String> values) =>
    (key) => values[key];

void main() {
  test('Given nothing published, When a run is tuned, Then it plays the '
      "rules' own numbers", () {
    expect(tuned(_rubble(), _published({})), _rubble());
  });

  test('Given a round target, a boss target and a joker number published, '
      'When a run is tuned, Then it plays them', () {
    // Given
    final values = _published({
      'boss_target_rubble': '4100',
      'joker_ember_mult': '2',
      'round_3_target': ' 950 ',
    });

    // When
    final run = tuned(_rubble(), values);

    // Then
    expect(run.rounds[2].target, 950);
    expect(run.rounds.last.target, 4100);
    expect(run.jokers.emberMult, 2);
    expect(run.rounds[1], _rubble().rounds[1]);
  });

  test("Given another world's boss target published, When a Rubble run is "
      'tuned, Then its boss keeps its own', () {
    // Given / When
    final run = tuned(_rubble(), _published({'boss_target_gravity': '9999'}));

    // Then
    expect(run.rounds.last.target, _rubble().rounds.last.target);
  });

  test('Given values that are not numbers or out of their range, When a run '
      'is tuned, Then each keeps its default', () {
    // Given
    final values = _published({
      'joker_twin_factor': '0',
      'offer_count': '7',
      'partner_bias': '1.5',
      'round_1_target': 'abc',
      'round_2_pieces': '12.5',
    });

    // When / Then
    expect(tuned(_rubble(), values), _rubble());
  });

  test('Given a decimal published for the partner bias, When a run is tuned, '
      'Then it plays it', () {
    expect(
      tuned(_rubble(), _published({'partner_bias': '0.5'})).partnerBias,
      0.5,
    );
  });

  test("Given the rules, When the keys are listed, Then each key's default is "
      "the number the rules' run plays with", () {
    // Given / When
    final keys = {for (final key in runTuningKeys(_rules)) key.name: key};

    // Then: the fake's run has no round before its boss to tune
    expect(keys['round_3_target'], isNull);
    expect(
      keys['boss_target_rubble']?.defaultValue,
      '${_rubble().rounds.last.target}',
    );
    expect(keys['partner_bias']?.defaultValue, '${_rubble().partnerBias}');
    expect(keys['joker_ember_mult']?.kind, RemoteKeyKind.number);
    expect(
      runTuningKeys(_rules).map((key) => key.name).toSet(),
      hasLength(runTuningKeys(_rules).length),
    );
  });
}
