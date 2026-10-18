import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/entities/world_node_status.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:flutter/services.dart';
import 'package:home_presentation/src/entities/joker_mastery.dart';
import 'package:home_presentation/src/package_name.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

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

/// The numbers and the tray the jokers play with, to describe them.
@riverpod
({int traySize, JokerTuning tuning}) jokerTuning(Ref ref) => ref.watch(
  jokerCollectionProvider.select(
    (collection) => (traySize: collection.traySize, tuning: collection.tuning),
  ),
);

/// How the player's runs went with [joker]; nothing before its first pick.
@riverpod
JokerStats jokerStats(Ref ref, JokerId joker) =>
    ref.watch(
      progressionProvider.select(
        (progression) => progression.value?.jokerStats[joker],
      ),
    ) ??
    .none;

/// The joker [joker] pairs with.
@riverpod
JokerId jokerPartner(Ref ref, JokerId joker) {
  final pair = ref
      .watch(jokerCollectionProvider)
      .pairs
      .firstWhere((pair) => pair.first == joker || pair.second == joker);

  return pair.first == joker ? pair.second : pair.first;
}

/// What it takes to unlock [joker].
@riverpod
JokerUnlock jokerUnlock(Ref ref, JokerId joker) => ref
    .watch(jokerCollectionProvider)
    .pairs
    .firstWhere((pair) => pair.first == joker || pair.second == joker)
    .unlock;

/// What [joker] does to a score, which colours its frame.
@riverpod
JokerKind jokerKind(Ref ref, JokerId joker) => ref.watch(
  jokerCollectionProvider.select((collection) => collection.kinds[joker]!),
);

/// [joker]'s mastery tier, from the runs won with it; none until read.
@riverpod
MasteryTier jokerTier(Ref ref, JokerId joker) => masteryTierOf(
  ref.watch(jokerStatsProvider(joker)).runsWon,
  ref.watch(masteryThresholdsProvider),
);

/// The runs won with a joker that earn each tier.
@riverpod
MasteryThresholds masteryThresholds(Ref ref) => ref.watch(
  jokerCollectionProvider.select((collection) => collection.mastery),
);

/// Whether both of pair [index]'s jokers are gold.
@riverpod
bool pairMastered(Ref ref, int index) {
  final pair = ref.watch(
    jokerCollectionProvider.select((collection) => collection.pairs[index]),
  );

  return ref.watch(jokerTierProvider(pair.first)) == .gold &&
      ref.watch(jokerTierProvider(pair.second)) == .gold;
}

/// How much of the collection the player holds: the jokers unlocked, the
/// pairs mastered, and of how many.
@riverpod
({int collected, int jokers, int mastered, int pairs}) spellbookProgress(
  Ref ref,
) {
  final pairs = ref.watch(
    jokerCollectionProvider.select((collection) => collection.pairs.length),
  );
  final collected = ref.watch(
    progressionProvider.select(
      (progression) => progression.value?.unlockedJokers.length ?? 0,
    ),
  );
  var mastered = 0;

  for (var index = 0; index < pairs; index++) {
    if (ref.watch(pairMasteredProvider(index))) mastered++;
  }

  return (
    collected: collected,
    jokers: pairs * 2,
    mastered: mastered,
    pairs: pairs,
  );
}

/// The jokers whose art is bundled (`assets/jokers/<id>.png`); the others
/// show their drawn glyph. Read once from the asset manifest.
@Riverpod(keepAlive: true)
Future<Set<JokerId>> jokerArt(Ref ref) async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final assets = manifest.listAssets().toSet();

  return {
    for (final joker in JokerId.values)
      if (assets.contains(jokerArtPath(joker))) joker,
  };
}

/// Where [joker]'s art would be bundled.
String jokerArtPath(JokerId joker) =>
    'packages/assets/assets/jokers/${joker.name}.png';

/// The jokers unlocked since the Spellbook was last opened, as this visit
/// found them: their NEW badges stay up until it is left, though the visit
/// counts them as seen at once.
@riverpod
class SpellbookNew extends _$SpellbookNew {
  @override
  Future<Set<JokerId>> build() async {
    // Read, not watched: marking them seen refreshes the progression, which
    // must not take the badges down mid-visit.
    final progression = await ref.read(progressionProvider.future);
    final fresh = progression.unlockedJokers.difference(
      progression.spellbookSeen,
    );

    if (fresh.isEmpty) return fresh;

    try {
      await ref.read(markSpellbookSeenProvider)();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Marking the Spellbook seen failed; NEW shows again',
        exception: error,
        stackTrace: stackTrace,
      );
    }

    return fresh;
  }
}
