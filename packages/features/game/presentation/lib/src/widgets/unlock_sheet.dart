import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:game_presentation/src/widgets/game_button.dart';
import 'package:game_presentation/src/widgets/joker_card.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/world_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// What a world run unlocked: the next world and its boss's jokers on a first
/// win, and the jokers the stars held across worlds unlock. Shown before the
/// run's end, which it hands over to. The cards flip in one after another,
/// once the sheet is up; reduce motion shows them at once, and a tap on them
/// skips to the end.
final class UnlockSheet extends ConsumerStatefulWidget {
  const UnlockSheet({super.key});

  @override
  ConsumerState<UnlockSheet> createState() => _UnlockSheetState();
}

final class _UnlockSheetState extends ConsumerState<UnlockSheet>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  static const _flip = 420;
  late final List<JokerId> _jokers = ref.read(
    gameProvider.select(
      (state) => state.progress?.unlockedJokers ?? const <JokerId>[],
    ),
  );

  /// The sheet's own entrance, which the first card waits out.
  static const _sheetEntrance = 300;
  static const _stagger = 160;

  @override
  void initState() {
    super.initState();

    final total =
        _sheetEntrance + _flip + _stagger * max<int>(0, _jokers.length - 1);

    _controller.duration = Duration(milliseconds: total);

    if (ref.read(reduceMotionProvider)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unlocks = context.t.game.unlocks;
    final total = _controller.duration!.inMilliseconds;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [
        const _UnlockHeading(),
        if (_jokers.isNotEmpty)
          Text(
            unlocks.jokersNote,
            style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
          ),
        GestureDetector(
          behavior: .opaque,
          onTap: () => _controller.value = 1,
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: DSSpace.small,
            children: [
              for (final (index, id) in _jokers.indexed)
                FlipIn(
                  flip: Interval(
                    (_sheetEntrance + _stagger * index) / total,
                    (_sheetEntrance + _stagger * index + _flip) / total,
                    curve: Curves.easeOutBack,
                  ),
                  timeline: _controller,
                  child: JokerCard(id: id),
                ),
            ],
          ),
        ),
        GameButton(
          label: unlocks.next,
          onPressed: ref.read(gameProvider.notifier).closeUnlocks,
        ),
      ],
    );
  }
}

/// [child] turning face up about its vertical axis over [flip] of
/// [timeline]: edge on, and so unseen, until its turn.
final class FlipIn extends StatelessWidget {
  const FlipIn({
    required this.child,
    required this.flip,
    required this.timeline,
    super.key,
  });

  final Widget child;
  final Curve flip;
  final Animation<double> timeline;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: timeline,
    builder: (context, child) {
      final progress = flip.transform(timeline.value);

      return Transform(
        alignment: .center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY((1 - progress) * pi / 2),
        child: child,
      );
    },
    child: child,
  );
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
