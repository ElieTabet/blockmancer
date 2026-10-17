import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/compact_screen.dart';
import 'package:game_presentation/src/widgets/points_text.dart';
import 'package:game_presentation/src/widgets/world_text.dart';
import 'package:l10n_application/l10n_application.dart';

final class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // Room for the leave button, which GameWidget lays over the sheets, and
      // a gap so the title doesn't sit against it.
      const SizedBox(
        height: kMinInteractiveDimension,
        width: kMinInteractiveDimension + DSSpace.xsmall,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              context.t.game.title,
              style: DSFont.display(
                const TextStyle(
                  color: DSColor.white,
                  fontSize: 26,
                  fontWeight: .w600,
                ),
              ),
            ),
            if (!isCompactScreen(context)) const ModeLine(),
          ],
        ),
      ),
      const RunTotalChip(),
    ],
  );
}

/// Back to the menu. The run is left as it stands.
final class LeaveButton extends ConsumerWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSGameBackButton(
    onTap: () => ref.read(gameProvider.notifier).leave(context),
    semanticLabel: context.t.game.leave,
  );
}

/// Which run this is: today's daily, practice, or a world's.
final class ModeLine extends ConsumerWidget {
  const ModeLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(gameProvider.select((state) => state.mode));
    final game = context.t.game;

    final label = switch (mode) {
      DailyMode() => game.subtitle,
      PracticeMode() => game.practiceSubtitle,
      WorldMode(:final world) => game.worldSubtitle(
        world: worldName(context, world),
      ),
    };

    return Text(
      label,
      style: const TextStyle(color: DSColor.textMuted, fontSize: 12),
    );
  }
}

/// The run total, the round in play included, once a move's points have
/// landed.
final class RunTotalChip extends ConsumerWidget {
  const RunTotalChip({super.key});

  static const _height = 34.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(gameRulesProvider);
    final total = ref.watch(
      shownRunProvider.select((run) => rules.liveRunTotal(run)),
    );

    return Container(
      height: _height,
      padding: const .symmetric(horizontal: DSSpace.small),
      alignment: .center,
      decoration: BoxDecoration(
        color: DSColor.sheet,
        borderRadius: .circular(_height / 2),
      ),
      child: Text(
        context.t.game.runTotal(total: pointsText(context, total)),
        style: const TextStyle(
          color: DSColor.white,
          fontSize: 13,
          fontWeight: .w700,
        ),
      ),
    );
  }
}
