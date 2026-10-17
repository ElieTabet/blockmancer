import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';

/// Every number in [testConfig]'s tuning, moved to one no joker starts with.
const _retuned = JokerTuning(
  anchorMult: 11,
  avalancheChipsPerCell: 12,
  bigBoxFactor: 13,
  bigBoxMinPieceSize: 14,
  brinkFactor: 33,
  brinkMinOccupied: 34,
  collectorMultPerJoker: 15,
  columnFactor: 16,
  comboMultPerStreak: 17,
  finisherFactor: 35,
  fullHouseCellsPerMult: 36,
  hatTrickBonus: 37,
  heavyFactor: 18,
  heavyMinPieceSize: 19,
  patienceStoredPerMove: 20,
  pocketsExtraPieces: 21,
  precisionBonusMult: 22,
  precisionMaxPieceSize: 23,
  quarryStonesPerClear: 24,
  saverPointsPerPiece: 25,
  stonemasonChipsPerStone: 26,
  stonemasonExtraStones: 27,
  sweepBonus: 28,
  tinyFactor: 29,
  tinyMaxPieceSize: 30,
  twinFactor: 31,
  twinMinLines: 32,
);

/// A context under the app's translations, in English.
Future<BuildContext> _pumpContext(WidgetTester tester) async {
  late BuildContext captured;

  await tester.pumpWidget(
    TranslationProvider(
      child: Builder(
        builder: (context) {
          captured = context;

          return const SizedBox.shrink();
        },
      ),
    ),
  );

  return captured;
}

void main() {
  testWidgets(
    'Given a retuned run, When each joker is described, Then each description reads the new numbers',
    (tester) async {
      // Given
      final context = await _pumpContext(tester);

      for (final id in JokerId.values) {
        // When
        final before = jokerDescription(context, id, testConfig.jokers);
        final after = jokerDescription(context, id, _retuned);

        // Then
        expect(after, isNot(before), reason: id.name);
      }
    },
  );

  testWidgets(
    'Given Twin Lines at ×5 from 3 lines, When described, Then it says so',
    (tester) async {
      // Given
      final context = await _pumpContext(tester);
      final tuning = testConfig.jokers.copyWith(twinFactor: 5, twinMinLines: 3);

      // When
      final description = jokerDescription(context, .twin, tuning);

      // Then
      expect(description, '×5 mult when you clear 3 or more lines at once.');
    },
  );

  testWidgets(
    'Given Quarry dropping one stone or two, When described, Then each reads naturally',
    (tester) async {
      // Given
      final context = await _pumpContext(tester);
      final one = testConfig.jokers.copyWith(quarryStonesPerClear: 1);
      final two = testConfig.jokers.copyWith(quarryStonesPerClear: 2);

      // When
      final described = [
        jokerDescription(context, .quarry, one),
        jokerDescription(context, .quarry, two),
      ];

      // Then
      expect(described, [
        'Every clear drops a new stone on a random empty cell.',
        'Every clear drops 2 new stones on random empty cells.',
      ]);
    },
  );
}
