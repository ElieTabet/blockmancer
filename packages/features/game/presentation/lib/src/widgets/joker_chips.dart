import 'package:shared_domain/shared_domain.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/painting/game_palette.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';

/// The jokers owned, in pick order. Tapping one shows what it does; a star marks
/// one whose partner is owned too.
final class JokerChips extends ConsumerWidget {
  const JokerChips({super.key});

  static const _minHeight = 26.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokers = ref.watch(gameProvider.select((state) => state.run.jokers));
    final rules = ref.watch(gameRulesProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: Wrap(
        spacing: DSSpace.xsmall,
        runSpacing: DSSpace.xsmall,
        children: [
          for (final id in jokers)
            JokerChip(id: id, paired: jokers.contains(rules.partnerOf(id))),
        ],
      ),
    );
  }
}

final class JokerChip extends StatelessWidget {
  const JokerChip({required this.id, required this.paired, super.key});

  final JokerId id;
  final bool paired;

  static const _height = 26.0;

  @override
  Widget build(BuildContext context) {
    final text = jokerText(context, id);

    return Tooltip(
      message: text.description,
      triggerMode: .tap,
      child: Container(
        height: _height,
        padding: const .symmetric(horizontal: DSSpace.small),
        alignment: .center,
        decoration: BoxDecoration(
          color: GamePalette.jokerCard,
          borderRadius: .circular(DSCornerRadius.medium),
          border: .all(
            color: paired ? DSColor.accent : DSColor.joker,
            width: 1.5,
          ),
        ),
        child: Text(
          paired ? '★ ${text.name}' : text.name,
          style: const TextStyle(
            color: GamePalette.jokerInk,
            fontSize: 12,
            fontWeight: .w700,
          ),
        ),
      ),
    );
  }
}
