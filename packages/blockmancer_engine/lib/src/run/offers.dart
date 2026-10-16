import 'package:blockmancer_engine/src/jokers/joker_catalog.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';
import 'package:blockmancer_engine/src/random/rng_stream.dart';
import 'package:blockmancer_engine/src/run/run_config.br.dart';

/// The jokers offered at pick [pickIndex]. Owned jokers are never offered and,
/// with probability [RunConfig.partnerBias], one slot is the partner of a joker
/// already owned.
List<JokerId> offersFor({
  required RunConfig config,
  required List<JokerId> owned,
  required int pickIndex,
  required int seed,
}) {
  var rng = streamFor(seed, .offers, pickIndex);
  final pool = [
    for (final joker in jokerCatalog)
      if (!owned.contains(joker.id)) joker.id,
  ];
  final partners = [
    for (final id in owned)
      if (pool.contains(jokerEffect(id).partner)) jokerEffect(id).partner,
  ];
  final offers = <JokerId>[];

  if (partners.isNotEmpty) {
    final (roll, afterRoll) = rng.next();
    rng = afterRoll;

    if (roll < config.partnerBias) {
      final (index, afterPick) = rng.nextInt(partners.length);
      rng = afterPick;
      offers.add(partners[index]);
      pool.remove(partners[index]);
    }
  }

  while (offers.length < config.offerCount && pool.isNotEmpty) {
    final (index, next) = rng.nextInt(pool.length);
    rng = next;
    offers.add(pool.removeAt(index));
  }

  return offers;
}
