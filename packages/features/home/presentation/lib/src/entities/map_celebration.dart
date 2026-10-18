import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_domain/shared_domain.dart';

/// One star of one world: 0 the boss beaten, 1 no revive, 2 the run total.
typedef WorldStar = ({int star, WorldId world});

/// What the map has to celebrate since it last settled: the stars earned, the
/// world opened, in the map's order, and whether the last boss standing fell.
@immutable
final class MapCelebration {
  const MapCelebration({
    required this.newStars,
    this.completedGame = false,
    this.unlockedWorld,
  });

  /// Every world's boss beaten now, and not when the map last settled.
  final bool completedGame;
  final List<WorldStar> newStars;
  final WorldId? unlockedWorld;

  bool get isEmpty =>
      newStars.isEmpty && unlockedWorld == null && !completedGame;

  @override
  bool operator ==(Object other) =>
      other is MapCelebration &&
      listEquals(other.newStars, newStars) &&
      other.completedGame == completedGame &&
      other.unlockedWorld == unlockedWorld;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(newStars), completedGame, unlockedWorld);
}

/// What [now] holds that [shown] didn't, walking [order], the map's worlds.
MapCelebration celebrationBetween(
  Progression now,
  List<WorldId> order, {
  required Progression shown,
}) => MapCelebration(
  completedGame: _allBeaten(now, order) && !_allBeaten(shown, order),
  newStars: [
    for (final world in order)
      for (final (star, earned) in _starsOf(now.worlds[world]).indexed)
        if (earned && !_starsOf(shown.worlds[world])[star])
          (star: star, world: world),
  ],
  unlockedWorld: order
      .where(
        (world) =>
            (now.worlds[world]?.unlocked ?? false) &&
            !(shown.worlds[world]?.unlocked ?? false),
      )
      .firstOrNull,
);

bool _allBeaten(Progression progression, List<WorldId> order) =>
    order.isNotEmpty &&
    order.every((world) => progression.worlds[world]?.bossBeaten ?? false);

List<bool> _starsOf(WorldProgress? progress) {
  final stars = progress?.stars;

  return [
    stars?.bossBeaten ?? false,
    stars?.noRevive ?? false,
    stars?.scoreThreshold ?? false,
  ];
}

/// When each part of a [MapCelebration] plays on its one timeline: the stars
/// one after another, then the trail drawing into the opened world, then
/// that world popping from locked to open.
@immutable
final class CelebrationPlan {
  factory CelebrationPlan.of(MapCelebration celebration) {
    final starAt = <WorldStar, (int, int)>{};
    var at = 0;

    for (final star in celebration.newStars) {
      starAt[star] = (at, at + _starLength);
      at += _starStep;
    }

    if (celebration.newStars.isNotEmpty) at += _starLength - _starStep;

    final unlocks = celebration.unlockedWorld != null;
    final trail = unlocks ? (at, at + _trailLength) : null;
    final pop = unlocks
        ? (at + _trailLength, at + _trailLength + _popLength)
        : null;
    final total = pop?.$2 ?? at;

    Interval interval((int, int) span) =>
        Interval(span.$1 / total, span.$2 / total, curve: Curves.easeOut);

    return CelebrationPlan._(
      duration: Duration(milliseconds: total),
      pop: pop == null ? null : interval(pop),
      stars: {
        for (final MapEntry(key: star, value: span) in starAt.entries)
          star: interval(span),
      },
      trail: trail == null ? null : interval(trail),
    );
  }

  const CelebrationPlan._({
    required this.duration,
    required this.stars,
    this.pop,
    this.trail,
  });

  static const _popLength = 280;
  static const _starLength = 420;
  static const _starStep = 260;
  static const _trailLength = 360;

  final Duration duration;

  /// The opened world's badge, from locked to open.
  final Interval? pop;
  final Map<WorldStar, Interval> stars;

  /// The leg into the opened world.
  final Interval? trail;
}
