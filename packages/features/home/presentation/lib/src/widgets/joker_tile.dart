import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/joker_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// A joker as the game's cards show it: its name and what it does, edged in
/// green and tagged once the player has it.
final class JokerTile extends ConsumerWidget {
  const JokerTile({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:traySize, :tuning) = ref.watch(jokerTuningProvider);
    final owned = ref.watch(jokerOwnedProvider(joker));

    return Container(
      padding: const .all(DSSpace.small),
      decoration: ShapeDecoration(
        color: DSColor.jokerSurface,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(DSCornerRadius.large),
          side: BorderSide(
            color: owned ? DSColor.positive : DSColor.joker,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: DSSpace.xxxsmall,
        children: [
          Row(
            spacing: DSSpace.xsmall,
            children: [
              Expanded(
                child: Text(
                  jokerName(context, joker),
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.jokerInk,
                      fontSize: 17,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ),
              if (owned)
                Text(
                  context.t.game.unlocks.label,
                  style: const TextStyle(
                    color: DSColor.positive,
                    fontSize: 12,
                    fontWeight: .w700,
                  ),
                ),
            ],
          ),
          Text(
            jokerDescription(context, joker, tuning, traySize: traySize),
            style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
