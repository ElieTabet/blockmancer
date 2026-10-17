import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/entities/world_node_status.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_internal.br.g.dart';

/// One world as its node on the map shows it: whether the player is there,
/// its place in the map's order, where it stands and the stars it awarded.
typedef WorldNodeShown = ({
  bool here,
  int number,
  WorldNodeStatus status,
  WorldStars stars,
});

const _noStars = WorldStars(
  bossBeaten: false,
  noRevive: false,
  scoreThreshold: false,
);

/// The furthest playable world open to the player, where the map says "you
/// are here"; null until the progression is read.
@riverpod
WorldId? hereWorld(Ref ref) {
  final progression = ref.watch(
    progressionProvider.select((progression) => progression.value),
  );

  if (progression == null) return null;

  return ref
      .watch(worldsProvider)
      .where(
        (world) =>
            world.playable && (progression.worlds[world.id]?.unlocked ?? false),
      )
      .lastOrNull
      ?.id;
}

/// Whether runs may offer [joker] already; false until the progression is
/// read.
@riverpod
bool jokerOwned(Ref ref, JokerId joker) => ref.watch(
  progressionProvider.select(
    (progression) => progression.value?.unlockedJokers.contains(joker) ?? false,
  ),
);

/// The legs of the trail between the worlds the player has walked: every one
/// up to [hereWorldProvider].
@riverpod
int trailWalked(Ref ref) {
  final here = ref.watch(hereWorldProvider);

  return here == null
      ? 0
      : ref.watch(worldsProvider).indexWhere((world) => world.id == here);
}

/// [world]'s node. Until the progression is read, a playable world shows as
/// locked.
@riverpod
WorldNodeShown worldNode(Ref ref, WorldId world) {
  final worlds = ref.watch(worldsProvider);
  final index = worlds.indexWhere((summary) => summary.id == world);
  final progress = ref.watch(
    progressionProvider.select(
      (progression) => progression.value?.worlds[world],
    ),
  );

  return (
    here: ref.watch(hereWorldProvider) == world,
    number: index + 1,
    status: switch (progress) {
      _ when !worlds[index].playable => .comingSoon,
      WorldProgress(bossBeaten: true) => .done,
      WorldProgress(unlocked: true) => .current,
      _ => .locked,
    },
    stars: progress?.stars ?? _noStars,
  );
}

@riverpod
WorldSummary worldSummary(Ref ref, WorldId world) =>
    ref.watch(worldsProvider).firstWhere((summary) => summary.id == world);

/// The numbers the jokers play with, to describe them: the rules' defaults,
/// which every world's summary carries.
@riverpod
JokerTuning jokerTuning(Ref ref) =>
    ref.watch(worldsProvider.select((worlds) => worlds.first.jokerTuning));
