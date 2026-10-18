import 'package:shared_domain/shared_domain.dart';

/// A joker's mastery, from the runs won with it owned.
enum MasteryTier { none, bronze, silver, gold }

MasteryTier masteryTierOf(int runsWon, MasteryThresholds thresholds) =>
    switch (runsWon) {
      _ when runsWon >= thresholds.gold => .gold,
      _ when runsWon >= thresholds.silver => .silver,
      _ when runsWon >= thresholds.bronze => .bronze,
      _ => .none,
    };

/// The tier after [tier], and the wins it takes; null once gold.
({MasteryTier tier, int wins})? nextMasteryTier(
  MasteryTier tier,
  MasteryThresholds thresholds,
) => switch (tier) {
  .none => (tier: .bronze, wins: thresholds.bronze),
  .bronze => (tier: .silver, wins: thresholds.silver),
  .silver => (tier: .gold, wins: thresholds.gold),
  .gold => null,
};
