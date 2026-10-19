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

  test('Given keys a later version reads published beside one this version '
      'knows, When a run is tuned, Then the unknown ones are never read, '
      'nothing throws, and the known one plays', () {
    // Given: a later world's boss, a later joker's number, a fifth round
    final asked = <String>[];
    final values = {
      'boss_target_volcano': '5000',
      'joker_phoenix_mult': '4',
      'round_5_target': '3000',
      'chips_per_cell': '12',
    };

    // When
    final run = tuned(_rubble(), (key) {
      asked.add(key);

      return values[key];
    });

    // Then
    expect(run, _rubble().copyWith(chipsPerCell: 12));
    expect(
      asked,
      isNot(
        anyOf(
          contains('boss_target_volcano'),
          contains('joker_phoenix_mult'),
          contains('round_5_target'),
        ),
      ),
    );
  });

  test('Given one malformed value, one missing and the rest valid, When a run '
      'is tuned, Then only the malformed and missing ones keep their '
      'defaults', () {
    // Given: round 2's target malformed, round 4's pieces not published
    final values = _published({
      'boss_target_rubble': '4100',
      'joker_ember_mult': '2',
      'round_1_target': '300',
      'round_2_target': '12k',
      'round_3_pieces': '19',
    });

    // When
    final run = tuned(_rubble(), values);

    // Then
    expect(run.rounds[0].target, 300);
    expect(run.rounds[1].target, _rubble().rounds[1].target);
    expect(run.rounds[2].pieces, 19);
    expect(run.rounds[3].pieces, _rubble().rounds[3].pieces);
    expect(run.rounds.last.target, 4100);
    expect(run.jokers.emberMult, 2);
    expect(run.offerCount, _rubble().offerCount);
  });

  test('Given a release that gives Fog its rules, When the keys are listed and '
      "a Fog run is tuned, Then Fog's keys appear with Fog's own defaults and "
      'tune its run alone', () {
    // Given: Fog coming soon, then playable
    const before = TwoWorldRules();
    const after = TwoWorldRules(fogPlayable: true);
    Set<String> names(GameRules rules) => {
      for (final key in runTuningKeys(rules)) key.name,
    };

    // When
    final added = names(after).difference(names(before));
    final fogKeys = {
      for (final key in runTuningKeys(after))
        if (added.contains(key.name)) key.name: key.defaultValue,
    };
    final fog = after.configFor(.fog, jokerPool: const []);
    final published = _published({'boss_target_fog': '3900'});

    // Then: its keys, nothing else, defaulting to what its run plays: the
    // boss target and third star every world gets, and its rule's numbers
    expect(fogKeys, {
      'boss_target_fog': '${fog.rounds.last.target}',
      'fog_boss_cells': '${fog.rounds.last.fog}',
      'fog_boss_hidden_stones': '${fog.rounds.last.fogStones}',
      'star3_fog': '${fog.starThreshold}',
    });
    expect(tuned(fog, published).rounds.last.target, 3900);
    expect(tuned(_rubble(), published), _rubble());
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
