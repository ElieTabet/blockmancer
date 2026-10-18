import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/joker_emblem.dart';
import 'package:home_presentation/src/widgets/joker_sheet.dart';
import 'package:home_presentation/src/widgets/joker_text.dart';
import 'package:home_presentation/src/widgets/unlock_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// One joker of the collection as a card: its emblem, short name and mastery
/// once unlocked; a silhouette until then. NEW when unlocked since the last
/// visit. A tap opens it in full.
final class SpellbookCard extends ConsumerWidget {
  const SpellbookCard({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(jokerOwnedProvider(joker));
    final isNew = ref.watch(
      spellbookNewProvider.select(
        (fresh) => fresh.value?.contains(joker) ?? false,
      ),
    );

    return DSPressable(
      onTap: () => showJokerSheet(context, joker: joker),
      pressedScale: 0.97,
      semanticLabel: _labelOf(context, ref, unlocked: unlocked, isNew: isNew),
      child: ExcludeSemantics(
        child: Stack(
          clipBehavior: .none,
          children: [
            if (unlocked)
              JokerCardFace(joker: joker)
            else
              const LockedCardFace(),
            if (isNew) const Positioned(top: -6, right: -6, child: NewBadge()),
          ],
        ),
      ),
    );
  }

  String _labelOf(
    BuildContext context,
    WidgetRef ref, {
    required bool isNew,
    required bool unlocked,
  }) {
    final spellbook = context.t.home.spellbook;

    if (!unlocked) {
      return spellbook.lockedLabel(
        unlock: unlockText(context, ref.watch(jokerUnlockProvider(joker))),
      );
    }

    final label = spellbook.cardLabel(
      kind: jokerKindName(context, ref.watch(jokerKindProvider(joker))),
      name: jokerName(context, joker),
      tier: masteryTierName(context, ref.watch(jokerTierProvider(joker))),
    );

    return isNew ? '$label. ${spellbook.newLabel}' : label;
  }
}

/// An unlocked joker's face, [width] wide: framed in its kind's colour, gold
/// ones shining.
final class JokerCardFace extends ConsumerWidget {
  const JokerCardFace({required this.joker, this.width, super.key});

  static const _aspect = 0.78;

  /// Below this width the name has no room; whatever shows a card that small
  /// names it beside it.
  static const _namedFrom = 90.0;

  final JokerId joker;

  /// Null to take the width it is given.
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frame = jokerFrameOf(ref.watch(jokerKindProvider(joker)));
    final gold = ref.watch(jokerTierProvider(joker)) == .gold;

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: _aspect,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Container(
              decoration: ShapeDecoration(
                color: frame.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(width * 0.1),
                  side: BorderSide(
                    color: gold ? DSMasteryColor.gold : frame.edge,
                    width: width < 90 ? 1.5 : 2.5,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: .all(width * 0.08),
                    child: Column(
                      spacing: width * 0.04,
                      children: [
                        Expanded(
                          child: Center(
                            child: JokerEmblem(
                              joker: joker,
                              size: width * 0.46,
                            ),
                          ),
                        ),
                        if (width >= _namedFrom)
                          Text(
                            jokerShortName(context, joker),
                            maxLines: 2,
                            textAlign: .center,
                            style: DSFont.display(
                              TextStyle(
                                color: DSColor.white,
                                fontSize: (width * 0.11).clamp(10, 22),
                                fontWeight: .w600,
                                height: 1.1,
                              ),
                            ),
                          ),
                        MasteryDots(joker: joker, size: width * 0.07),
                      ],
                    ),
                  ),
                  if (gold)
                    Positioned.fill(child: GoldShine(radius: width * 0.1)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A locked joker: a dark silhouette, "?" for a name, and a lock.
final class LockedCardFace extends StatelessWidget {
  const LockedCardFace({this.width, super.key});

  static const _aspect = 0.78;

  /// Null to take the width it is given.
  final double? width;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: AspectRatio(
      aspectRatio: _aspect,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Container(
            padding: .all(width * 0.08),
            decoration: ShapeDecoration(
              color: DSColor.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: .circular(width * 0.1),
                side: const BorderSide(color: DSColor.cardBorder, width: 2),
              ),
            ),
            child: Column(
              spacing: width * 0.04,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      context.t.home.spellbook.unknownName,
                      style: DSFont.display(
                        TextStyle(
                          color: DSColor.cardBorder,
                          fontSize: width * 0.4,
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.lock_rounded,
                  color: DSColor.textMuted,
                  size: width * 0.16,
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

/// Three dots, filled up to [joker]'s tier in the tier's colour.
final class MasteryDots extends ConsumerWidget {
  const MasteryDots({required this.joker, required this.size, super.key});

  final JokerId joker;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(jokerTierProvider(joker));
    final color = switch (tier) {
      .none => DSMasteryColor.empty,
      .bronze => DSMasteryColor.bronze,
      .silver => DSMasteryColor.silver,
      .gold => DSMasteryColor.gold,
    };

    return Row(
      mainAxisAlignment: .center,
      spacing: size * 0.6,
      children: [
        for (var dot = 1; dot <= 3; dot++)
          Container(
            key: ValueKey('dot-$dot-${dot <= tier.index ? 'on' : 'off'}'),
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: dot <= tier.index ? color : DSMasteryColor.empty,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

final class NewBadge extends StatelessWidget {
  const NewBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const .symmetric(horizontal: DSSpace.xsmall, vertical: 2),
    decoration: BoxDecoration(
      color: DSColor.accent,
      borderRadius: .circular(DSCornerRadius.small),
      boxShadow: const [BoxShadow(color: DSColor.primaryDark, blurRadius: 4)],
    ),
    child: Text(
      context.t.home.spellbook.newBadge,
      style: const TextStyle(
        color: DSColor.primary,
        fontSize: 11,
        fontWeight: .w800,
      ),
    ),
  );
}

/// A gold card's shine: a soft band of light that sweeps across now and then,
/// held still across the card under reduce motion.
final class GoldShine extends ConsumerStatefulWidget {
  const GoldShine({required this.radius, super.key});

  final double radius;

  @override
  ConsumerState<GoldShine> createState() => _GoldShineState();
}

final class _GoldShineState extends ConsumerState<GoldShine>
    with SingleTickerProviderStateMixin {
  // Most of the period is rest: the band crosses in its first quarter.
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 3600),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still =
        MediaQuery.disableAnimationsOf(context) ||
        ref.watch(reduceMotionSettingProvider);

    if (still) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }

    return IgnorePointer(
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: .circular(widget.radius),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final sweep = still
                  ? 0.5
                  : (_controller.value / 0.25).clamp(0.0, 1.0);

              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(-1, -1),
                    end: const Alignment(1, 1),
                    colors: [
                      Colors.transparent,
                      DSMasteryColor.gold.withValues(
                        alpha: still ? 0.12 : 0.22,
                      ),
                      Colors.transparent,
                    ],
                    stops: [
                      (sweep - 0.25).clamp(0.0, 1.0),
                      sweep.clamp(0.0, 1.0),
                      (sweep + 0.25).clamp(0.0, 1.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
