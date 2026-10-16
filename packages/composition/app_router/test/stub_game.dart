import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:game_presentation/game_presentation.dart' as game_ui;

/// The game tab's title, which is how these tests know it is on screen.
const gameTitle = 'Blockmancer';

/// Fills the slot the game tab reads, so a composition test mounts the real tab
/// with the real rules.
List<Override> stubGame() => [
  ...game_ui.bindProviders(gameRules: (ref) => const BlockmancerEngine()),
];
