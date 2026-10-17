import 'dart:math' as math;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
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
        // A pulsing chip swells past the line.
        clipBehavior: .none,
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

/// One owned joker, as wide as its name. It pulses as the joker fires in a
/// move's playback.
final class JokerChip extends ConsumerStatefulWidget {
  const JokerChip({required this.id, required this.paired, super.key});

  final JokerId id;
  final bool paired;

  @override
  ConsumerState<JokerChip> createState() => _JokerChipState();
}

class _JokerChipState extends ConsumerState<JokerChip>
    with SingleTickerProviderStateMixin {
  static const _glow = 10.0;
  static const _height = 26.0;
  late final _pulse = AnimationController(vsync: this, duration: _pulsing);
  static const _pulsing = Duration(milliseconds: 300);
  static const _swell = 0.2;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      playbackProvider.select(
        (playback) => switch (playback.beat) {
          JokerPulseBeat(:final joker) when joker == widget.id => playback.step,
          _ => null,
        },
      ),
      (_, step) {
        if (step != null) _pulse.forward(from: 0);
      },
    );

    final still = ref.watch(reduceMotionProvider);
    final text = jokerText(context, widget.id);

    return Tooltip(
      message: text.description,
      triggerMode: .tap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final swell = math.sin(_pulse.value * math.pi);

          return Transform.scale(
            scale: still ? 1 : 1 + _swell * swell,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: .circular(DSCornerRadius.medium),
                boxShadow: [
                  BoxShadow(
                    color: DSColor.accent.withValues(alpha: swell),
                    blurRadius: _glow * swell,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: Container(
          height: _height,
          padding: const .symmetric(horizontal: DSSpace.small),
          decoration: BoxDecoration(
            color: DSColor.jokerSurface,
            borderRadius: .circular(DSCornerRadius.medium),
            border: .all(
              color: widget.paired ? DSColor.accent : DSColor.joker,
              width: 1.5,
            ),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(
              widget.paired ? '★ ${text.name}' : text.name,
              style: const TextStyle(
                color: DSColor.jokerInk,
                fontSize: 12,
                fontWeight: .w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
