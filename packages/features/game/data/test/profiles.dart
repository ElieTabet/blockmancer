import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _locked = WorldProgress(
  bossBeaten: false,
  stars: noStars,
  unlocked: false,
);

const noStars = WorldStars(
  bossBeaten: false,
  noRevive: false,
  scoreThreshold: false,
);

/// Today's rules' starting progression, as game_domain builds it from them.
const starting = Progression(
  jokerStats: {},
  tutorialDone: false,
  unlockedJokers: {
    .bigbox,
    .collector,
    .column,
    .combo,
    .heavy,
    .patience,
    .pockets,
    .precision,
    .saver,
    .sweep,
    .tiny,
    .twin,
  },
  worlds: {
    .rubble: WorldProgress(bossBeaten: false, stars: noStars, unlocked: true),
    .gravity: _locked,
    .fog: _locked,
    .speed: _locked,
    .mirror: _locked,
  },
);

/// What the next launch reads: the stored values, the stores' cache gone.
Future<void> relaunch() async {
  final stored = await SharedPreferences.getInstance();

  SharedPreferences.setMockInitialValues({
    for (final key in stored.getKeys()) key: stored.get(key)!,
  });
}
