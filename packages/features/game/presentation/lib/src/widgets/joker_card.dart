import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:shared_domain/shared_domain.dart';

/// A joker's card: its name, and what it does with the run's own numbers.
final class JokerCard extends ConsumerWidget {
  const JokerCard({
    required this.id,
    this.borderColor = DSColor.joker,
    this.footer,
    this.trailing,
    super.key,
  });

  final Color borderColor;
  final Widget? footer;
  final JokerId id;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuning = ref.watch(
      gameProvider.select((state) => state.run.config.jokers),
    );
    final footer = this.footer;
    final trailing = this.trailing;

    return Container(
      padding: const .all(DSSpace.small),
      decoration: ShapeDecoration(
        color: DSColor.jokerSurface,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(DSCornerRadius.large),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
      child: Row(
        spacing: DSSpace.small,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: DSSpace.xxxsmall,
              children: [
                Text(
                  jokerName(context, id),
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.jokerInk,
                      fontSize: 17,
                      fontWeight: .w600,
                    ),
                  ),
                ),
                Text(
                  jokerDescription(context, id, tuning),
                  style: const TextStyle(
                    color: DSColor.textMuted,
                    fontSize: 13,
                  ),
                ),
                ?footer,
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
