import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/widgets/joker_text.dart';
import 'package:shared_domain/shared_domain.dart';

/// The jokers owned, in pick order, on one line that scrolls sideways: the
/// board takes the height a second line would cost. Tapping one shows what it
/// does; a star marks one whose partner is owned too.
final class JokerChips extends ConsumerWidget {
  const JokerChips({super.key});

  static const _height = 26.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokers = ref.watch(gameProvider.select((state) => state.run.jokers));
    final rules = ref.watch(gameRulesProvider);

    return SizedBox(
      height: _height,
      child: ListView(
        scrollDirection: .horizontal,
        children: [
          for (final (index, id) in jokers.indexed)
            Padding(
              padding: .only(left: index == 0 ? 0 : DSSpace.xsmall),
              child: JokerChip(
                id: id,
                paired: jokers.contains(rules.partnerOf(id)),
              ),
            ),
        ],
      ),
    );
  }
}

/// One owned joker, as wide as its name.
final class JokerChip extends StatelessWidget {
  const JokerChip({required this.id, required this.paired, super.key});

  static const _height = 26.0;

  final JokerId id;
  final bool paired;

  @override
  Widget build(BuildContext context) {
    final text = jokerText(context, id);

    return Tooltip(
      message: text.description,
      triggerMode: .tap,
      child: Container(
        height: _height,
        padding: const .symmetric(horizontal: DSSpace.small),
        decoration: BoxDecoration(
          color: DSColor.jokerSurface,
          borderRadius: .circular(DSCornerRadius.medium),
          border: .all(
            color: paired ? DSColor.accent : DSColor.joker,
            width: 1.5,
          ),
        ),
        child: Center(
          widthFactor: 1,
          child: Text(
            paired ? '★ ${text.name}' : text.name,
            style: const TextStyle(
              color: DSColor.jokerInk,
              fontSize: 12,
              fontWeight: .w700,
            ),
          ),
        ),
      ),
    );
  }
}
