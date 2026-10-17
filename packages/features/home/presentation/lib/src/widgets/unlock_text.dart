import 'package:flutter/widgets.dart';
import 'package:home_presentation/src/widgets/world_name.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// How to unlock a joker, as the player is told it.
String unlockText(BuildContext context, JokerUnlock unlock) {
  final spellbook = context.t.home.spellbook;

  return switch (unlock) {
    BossUnlock(:final world) => spellbook.unlockBoss(
      world: worldName(context, world),
    ),
    StarsUnlock(:final count) => spellbook.unlockStars(count: count),
    // A new player has it, so it is never shown locked.
    StartingUnlock() => spellbook.locked,
  };
}
