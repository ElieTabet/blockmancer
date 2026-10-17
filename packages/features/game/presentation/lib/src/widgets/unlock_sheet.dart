import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/game_button.dart';
import 'package:game_presentation/src/widgets/joker_card.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/world_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// What beating a world's boss for the first time unlocked: the next world,
/// and the jokers runs may offer from now on. Shown before the run's end,
/// which it hands over to.
final class UnlockSheet extends ConsumerWidget {
  const UnlockSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokers = ref.watch(
      gameProvider.select(
        (state) => state.progress?.unlockedJokers ?? const <JokerId>[],
      ),
    );
    final unlocks = context.t.game.unlocks;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [
        const _UnlockHeading(),
        if (jokers.isNotEmpty)
          Text(
            unlocks.jokersNote,
            style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
          ),
        for (final id in jokers) JokerCard(id: id),
        GameButton(
          label: unlocks.next,
          onPressed: ref.read(gameProvider.notifier).closeUnlocks,
        ),
      ],
    );
  }
}

final class _UnlockHeading extends ConsumerWidget {
  const _UnlockHeading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(
      gameProvider.select((state) => state.progress?.unlockedWorld),
    );
    final unlocks = context.t.game.unlocks;

    return Column(
      crossAxisAlignment: .start,
      spacing: DSSpace.xxsmall,
      children: [
        Text(
          unlocks.label.toUpperCase(),
          style: const TextStyle(
            color: DSColor.info,
            fontSize: 12,
            fontWeight: .w700,
            letterSpacing: 1.6,
          ),
        ),
        SheetTitle(
          world == null
              ? unlocks.newJokers
              : unlocks.newWorld(world: worldName(context, world)),
        ),
      ],
    );
  }
}
