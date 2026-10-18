import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

void main() {
  const rules = BlockmancerEngine();

  test('each joker is sorted by what it does to a score', () {
    expect(rules.kindOf(.combo), JokerKind.additiveMult);
    expect(rules.kindOf(.twin), JokerKind.multiplicativeMult);
    expect(rules.kindOf(.prism), JokerKind.chips);
    expect(rules.kindOf(.sweep), JokerKind.flatBonus);
    expect(rules.kindOf(.quarry), JokerKind.boardEffect);
    expect(rules.kindOf(.tiny), JokerKind.drawWeight);
  });

  test('every kind has its jokers, and every joker one kind', () {
    final byKind = <JokerKind, int>{};

    for (final id in JokerId.values) {
      byKind.update(rules.kindOf(id), (count) => count + 1, ifAbsent: () => 1);
    }

    expect(byKind, {
      JokerKind.additiveMult: 10,
      JokerKind.boardEffect: 3,
      JokerKind.chips: 3,
      JokerKind.drawWeight: 2,
      JokerKind.flatBonus: 3,
      JokerKind.multiplicativeMult: 5,
    });
  });

  test("the rules' mastery tiers are 1, 5 and 15 wins", () {
    expect(
      rules.defaultConfig.mastery,
      const MasteryThresholds(bronze: 1, gold: 15, silver: 5),
    );
  });
}
