import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/effects/anchor.dart';
import 'package:blockmancer_engine/src/jokers/effects/avalanche.dart';
import 'package:blockmancer_engine/src/jokers/effects/big_box.dart';
import 'package:blockmancer_engine/src/jokers/effects/brink.dart';
import 'package:blockmancer_engine/src/jokers/effects/clean_sweep.dart';
import 'package:blockmancer_engine/src/jokers/effects/collector.dart';
import 'package:blockmancer_engine/src/jokers/effects/column_hunter.dart';
import 'package:blockmancer_engine/src/jokers/effects/combo_king.dart';
import 'package:blockmancer_engine/src/jokers/effects/deep_pockets.dart';
import 'package:blockmancer_engine/src/jokers/effects/ember.dart';
import 'package:blockmancer_engine/src/jokers/effects/finisher.dart';
import 'package:blockmancer_engine/src/jokers/effects/full_house.dart';
import 'package:blockmancer_engine/src/jokers/effects/hat_trick.dart';
import 'package:blockmancer_engine/src/jokers/effects/heavyweight.dart';
import 'package:blockmancer_engine/src/jokers/effects/lantern.dart';
import 'package:blockmancer_engine/src/jokers/effects/momentum.dart';
import 'package:blockmancer_engine/src/jokers/effects/patience.dart';
import 'package:blockmancer_engine/src/jokers/effects/precision.dart';
import 'package:blockmancer_engine/src/jokers/effects/quarry.dart';
import 'package:blockmancer_engine/src/jokers/effects/saver.dart';
import 'package:blockmancer_engine/src/jokers/effects/sprinter.dart';
import 'package:blockmancer_engine/src/jokers/effects/stonemason.dart';
import 'package:blockmancer_engine/src/jokers/effects/tiny_tools.dart';
import 'package:blockmancer_engine/src/jokers/effects/twin_lines.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/pieces/shape_catalog.dart';

/// Every joker, in the order their hooks run: the brief's table order, which
/// puts the additive effects before the multiplicative ones and Clean Sweep's
/// empty-board check before Quarry drops a stone, then later jokers appended.
/// Offers also draw in this order, so reordering it changes seeded runs, while
/// appending leaves a pool without the newcomers drawing as before.
const List<JokerEffect> jokerCatalog = [
  Stonemason(),
  ComboKing(),
  Patience(),
  Precision(),
  Collector(),
  TwinLines(),
  ColumnHunter(),
  Heavyweight(),
  CleanSweep(),
  Quarry(),
  BigBox(),
  TinyTools(),
  DeepPockets(),
  Saver(),
  Anchor(),
  Avalanche(),
  FullHouse(),
  Brink(),
  Finisher(),
  HatTrick(),
  Lantern(),
  Ember(),
  Sprinter(),
  Momentum(),
];

JokerEffect jokerEffect(JokerId id) =>
    jokerCatalog.firstWhere((joker) => joker.id == id);

/// The effects of [owned], in hook order rather than the order they were picked.
List<JokerEffect> effectsOf(Iterable<JokerId> owned) => [
  for (final joker in jokerCatalog)
    if (owned.contains(joker.id)) joker,
];

/// The draw weight of every shape in [shapeCatalog] under [jokers].
List<int> pieceWeights(List<JokerEffect> jokers, JokerTuning tuning) => [
  for (final shape in shapeCatalog)
    jokers.fold(1, (weight, joker) => joker.pieceWeight(shape, tuning, weight)),
];

RoundSetup roundSetup(
  RoundSetup base,
  List<JokerEffect> jokers,
  JokerTuning tuning,
) => jokers.fold(base, (setup, joker) => joker.onRoundSetup(setup, tuning));

RoundBonus roundBonus(List<JokerEffect> jokers, RoundWonContext round) => jokers
    .fold(const RoundBonus(), (bonus, joker) => joker.onRoundWon(bonus, round));
