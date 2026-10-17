import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/entities/world_node_status.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/painting/map_geometry.dart';
import 'package:home_presentation/src/painting/star_burst_painter.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/here_marker.dart';
import 'package:home_presentation/src/widgets/map_celebration_director.dart';
import 'package:home_presentation/src/widgets/world_name.dart';
import 'package:home_presentation/src/widgets/world_sheet.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// One world on the map: its number, its name and its stars, with "you are
/// here" over it once the player has reached it. A tap opens its sheet,
/// whatever its state, and the sheet's play button opens its run; a world
/// not open yet shakes lightly first, unless motion is reduced.
final class WorldNode extends ConsumerStatefulWidget {
  const WorldNode({required this.world, super.key});

  final WorldId world;

  @override
  ConsumerState<WorldNode> createState() => _WorldNodeState();
}

final class _WorldNodeState extends ConsumerState<WorldNode>
    with SingleTickerProviderStateMixin {
  static const _amplitude = 6.0;
  late final _controller = AnimationController(vsync: this, duration: _shake);
  static const _shake = Duration(milliseconds: 320);
  static const _swings = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final world = widget.world;
    final status = ref.watch(
      worldNodeProvider(world).select((node) => node.status),
    );

    return DSPressable(
      // The sheet is the widget's to show; only where its choice leads goes
      // through the notifier, as every other choice does.
      onTap: () async {
        if (status == .locked || status == .comingSoon) _shakeUnlessStill();

        final play = await showWorldSheet(context, world: world);

        if (play && context.mounted) {
          ref.read(homeProvider.notifier).openWorld(context, world);
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.translate(
          offset: Offset(
            sin(_controller.value * _swings * 2 * pi) *
                _amplitude *
                (1 - _controller.value),
            0,
          ),
          child: child,
        ),
        child: _NodeBody(status: status, world: world),
      ),
    );
  }

  void _shakeUnlessStill() {
    final still =
        MediaQuery.disableAnimationsOf(context) ||
        ref.read(reduceMotionSettingProvider);

    if (!still) _controller.forward(from: 0);
  }
}

final class _NodeBody extends StatelessWidget {
  const _NodeBody({required this.status, required this.world});

  final WorldNodeStatus status;
  final WorldId world;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        SizedBox(
          height: MapGeometry.markerHeight,
          child: HereMarker(world: world),
        ),
        WorldBadge(world: world),
        const SizedBox(height: DSSpace.xxsmall),
        Text(
          worldName(context, world),
          maxLines: 1,
          overflow: .ellipsis,
          style: DSFont.display(
            TextStyle(
              color: switch (status) {
                .current || .done => DSColor.white,
                .locked => DSColor.textMuted,
                .comingSoon => _greyed,
              },
              fontSize: 17,
              fontWeight: .w600,
            ),
          ),
        ),
        if (status == .comingSoon)
          Text(
            context.t.home.map.comingSoon,
            style: TextStyle(color: _greyed, fontSize: 12, fontWeight: .w700),
          )
        else
          WorldStarsRow(world: world),
      ],
    );
  }
}

/// A world's number on a round badge, coloured by where the world stands,
/// with a lock while it waits on the boss before it and a tick once its own
/// boss is beaten.
final class WorldBadge extends ConsumerWidget {
  const WorldBadge({required this.world, super.key});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (number, status) = ref.watch(
      worldNodeProvider(world).select((node) => (node.number, node.status)),
    );
    final scope = MapCelebrationScope.maybeOf(context);
    final pop = scope?.celebration?.unlockedWorld == world
        ? scope?.plan?.pop
        : null;

    if (pop == null) return _BadgeFace(number: number, status: status);

    // Locked until its moment, then popping open.
    return AnimatedBuilder(
      animation: scope!.timeline,
      builder: (context, _) {
        final progress = pop.transform(scope.timeline.value);

        return progress == 0
            ? _BadgeFace(number: number, status: .locked)
            : Transform.scale(
                scale: _popScale.transform(progress),
                child: _BadgeFace(number: number, status: status),
              );
      },
    );
  }
}

final _popScale = TweenSequence([
  TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.15), weight: 60),
  TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 40),
]);

final class _BadgeFace extends StatelessWidget {
  const _BadgeFace({required this.number, required this.status});

  final int number;
  final WorldNodeStatus status;

  @override
  Widget build(BuildContext context) {
    final map = context.t.home.map;
    final (fill, edge, ink) = switch (status) {
      .comingSoon => (DSColor.primaryLight, DSColor.cardBorder, _greyed),
      .current => (DSColor.accent, DSColor.white, DSColor.primary),
      .done => (DSColor.sheet, DSColor.accent, DSColor.white),
      .locked => (DSColor.card, DSColor.cardBorder, DSColor.textMuted),
    };

    return SizedBox.square(
      dimension: MapGeometry.badgeSize,
      child: Stack(
        clipBehavior: .none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                shape: .circle,
                border: .all(color: edge, width: 3),
                // A hard ledge under the badge, like the game's keys.
                boxShadow: const [
                  BoxShadow(color: DSColor.primaryDark, offset: Offset(0, 4)),
                ],
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: DSFont.display(
                    TextStyle(color: ink, fontSize: 26, fontWeight: .w700),
                  ),
                ),
              ),
            ),
          ),
          if (status == .locked)
            Positioned(
              right: -DSSpace.xxsmall,
              bottom: -DSSpace.xxsmall,
              child: _Corner(
                color: DSColor.cardBorder,
                icon: Icons.lock_rounded,
                semanticLabel: map.locked,
              ),
            )
          else if (status == .done)
            Positioned(
              right: -DSSpace.xxsmall,
              bottom: -DSSpace.xxsmall,
              child: _Corner(
                color: DSColor.positive,
                icon: Icons.check_rounded,
                semanticLabel: map.done,
              ),
            ),
        ],
      ),
    );
  }
}

/// The three stars a world awards, filled once earned.
final class WorldStarsRow extends ConsumerWidget {
  const WorldStarsRow({required this.world, super.key});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = ref.watch(
      worldNodeProvider(world).select((node) => node.stars),
    );
    final earned = [stars.bossBeaten, stars.noRevive, stars.scoreThreshold];
    final scope = MapCelebrationScope.maybeOf(context);

    return Semantics(
      label: context.t.home.map.stars(
        count: earned.where((star) => star).length,
      ),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: .min,
          children: [
            for (final (index, star) in earned.indexed)
              switch (scope?.plan?.stars[(star: index, world: world)]) {
                final filling? => _FillingStar(
                  filling: filling,
                  timeline: scope!.timeline,
                ),
                null => _Star(earned: star),
              },
          ],
        ),
      ),
    );
  }
}

final class _Star extends StatelessWidget {
  const _Star({required this.earned});

  final bool earned;

  @override
  Widget build(BuildContext context) => Icon(
    earned ? Icons.star_rounded : Icons.star_outline_rounded,
    color: earned ? DSColor.accent : DSColor.textMuted,
    size: _starSize,
  );
}

/// A star just earned: empty until its turn, then filling with a burst.
final class _FillingStar extends StatelessWidget {
  const _FillingStar({required this.filling, required this.timeline});

  final Curve filling;
  final Animation<double> timeline;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: timeline,
    builder: (context, _) {
      final progress = filling.transform(timeline.value);

      return progress == 0
          ? const _Star(earned: false)
          : CustomPaint(
              painter: StarBurstPainter(progress: progress),
              child: Transform.scale(
                scale: _fillScale.transform(progress),
                child: const _Star(earned: true),
              ),
            );
    },
  );
}

final _fillScale = TweenSequence([
  TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.35), weight: 55),
  TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 45),
]);

const _starSize = 20.0;

/// What isn't in the game yet.
final _greyed = DSColor.textMuted.withValues(alpha: 0.5);

final class _Corner extends StatelessWidget {
  const _Corner({
    required this.color,
    required this.icon,
    required this.semanticLabel,
  });

  final Color color;
  final IconData icon;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Container(
    padding: const .all(DSSpace.xxxsmall),
    decoration: BoxDecoration(
      color: color,
      shape: .circle,
      border: .all(color: DSColor.primary, width: 2),
    ),
    child: Icon(
      icon,
      color: DSColor.primary,
      size: 16,
      semanticLabel: semanticLabel,
    ),
  );
}
