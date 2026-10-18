import 'dart:math' as math;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/widgets/game_button.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/world_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// Shows [world]'s boss card over the screen, as the world's sheet replays it.
Future<void> showBossCard(BuildContext context, {required WorldId world}) =>
    showDialog<void>(
      barrierColor: DSColor.scrim,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: DSColor.sheet,
        child: Padding(
          padding: const .all(DSSpace.large),
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            spacing: DSSpace.medium,
            children: [
              BossCard(world: world),
              GameButton(
                label: context.t.game.bossCard.ok,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );

/// The card the first boss of a world opens with, in the run's sheet.
final class BossCardSheet extends ConsumerWidget {
  const BossCardSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(gameProvider.select((state) => state.bossCard));

    if (world == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.medium,
      children: [
        BossCard(world: world),
        GameButton(
          label: context.t.game.bossCard.ok,
          onPressed: ref.read(gameProvider.notifier).closeBossCard,
        ),
      ],
    );
  }
}

/// What [world]'s boss does to the board: its name, a small loop of the rule
/// at work, and the rule in a sentence.
final class BossCard extends StatelessWidget {
  const BossCard({required this.world, super.key});

  final WorldId world;

  @override
  Widget build(BuildContext context) {
    final card = context.t.game.bossCard;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [
        SheetTitle(card.title(world: worldName(context, world))),
        Center(child: BossRuleLoop(world: world)),
        Text(switch (world) {
          .fog => card.fog,
          .gravity => card.gravity,
          .mirror => card.mirror,
          .rubble => card.rubble,
          .tide => card.tide,
        }, style: const TextStyle(color: DSColor.white, fontSize: 15)),
      ],
    );
  }
}

/// A small board showing [world]'s rule at work, over and over; still, at
/// its most telling moment, under reduce motion.
final class BossRuleLoop extends ConsumerStatefulWidget {
  const BossRuleLoop({required this.world, super.key});

  final WorldId world;

  @override
  ConsumerState<BossRuleLoop> createState() => _BossRuleLoopState();
}

class _BossRuleLoopState extends ConsumerState<BossRuleLoop>
    with SingleTickerProviderStateMixin {
  late final _loop = AnimationController(
    duration: const Duration(milliseconds: 1800),
    vsync: this,
  );

  static const _side = 120.0;

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still =
        MediaQuery.disableAnimationsOf(context) ||
        ref.watch(reduceMotionSettingProvider);

    if (still) {
      _loop
        ..stop()
        ..value = 0.75;
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }

    return SizedBox.square(
      dimension: _side,
      child: CustomPaint(
        painter: BossRulePainter(world: widget.world, loop: _loop),
      ),
    );
  }
}

/// A 4×4 board and [world]'s rule at work on it, [loop] of the way through.
final class BossRulePainter extends CustomPainter {
  BossRulePainter({required this.loop, required this.world})
    : super(repaint: loop);

  static const _cells = 4;
  final _paint = Paint();
  final Animation<double> loop;
  final WorldId world;

  @override
  void paint(Canvas canvas, Size size) {
    final pitch = size.width / _cells;
    final t = loop.value;

    final frame = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(10),
    );

    _paint.color = DSGameColor.boardBackground;
    canvas
      ..drawRRect(frame, _paint)
      ..clipRRect(frame);

    for (var row = 0; row < _cells; row++) {
      for (var col = 0; col < _cells; col++) {
        _cell(canvas, pitch, col, row.toDouble(), DSGameColor.emptyCell);
      }
    }

    final piece = DSGameColor.pieces[1];
    final eased = Curves.easeInOut.transform(math.min(1, t * 1.6));

    switch (world) {
      case .gravity:
        _cell(canvas, pitch, 1, eased * 3, piece);
      case .fog:
        _cell(canvas, pitch, 2, 2, DSGameColor.stone);
        _paint.color = DSGameColor.fog.withValues(alpha: 1 - eased);
        canvas.drawCircle(
          Offset(2.5 * pitch, 2.5 * pitch),
          pitch * (0.45 + 0.3 * eased),
          _paint,
        );
        _cell(canvas, pitch, 1, 2, piece);
      case .mirror:
        _cell(canvas, pitch, 0, 1, piece);
        _cell(canvas, pitch, 3, 1, piece.withValues(alpha: eased));
        _paint
          ..color = DSColor.white.withValues(alpha: 0.5)
          ..strokeWidth = 1.5;
        canvas.drawLine(
          Offset(size.width / 2, 4),
          Offset(size.width / 2, size.height - 4),
          _paint,
        );
      case .rubble:
        for (final (index, (col, row)) in const [
          (0, 3),
          (2, 1),
          (3, 2),
        ].indexed) {
          if (eased > index / 3) {
            _cell(canvas, pitch, col, row.toDouble(), DSGameColor.stone);
          }
        }
      case .tide:
        for (var col = 0; col < _cells; col++) {
          if (col != 1) {
            _cell(canvas, pitch, col, 4 - eased, DSGameColor.stone);
          }
        }
        _cell(canvas, pitch, 2, 3 - eased, piece);
    }
  }

  @override
  bool shouldRepaint(BossRulePainter oldDelegate) =>
      oldDelegate.world != world || oldDelegate.loop != loop;

  void _cell(Canvas canvas, double pitch, int col, double row, Color color) {
    _paint.color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col * pitch + 2, row * pitch + 2, pitch - 4, pitch - 4),
        const Radius.circular(4),
      ),
      _paint,
    );
  }
}
