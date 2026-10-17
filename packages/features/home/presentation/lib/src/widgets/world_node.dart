import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/painting/map_geometry.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/here_marker.dart';
import 'package:home_presentation/src/widgets/world_name.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// One world on the map: its number, its name and its stars, with "you are
/// here" over it once the player has reached it. What a tap does is
/// [HomeNotifier.onWorldTapped]'s to decide.
final class WorldNode extends ConsumerWidget {
  const WorldNode({required this.world, super.key});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      worldNodeProvider(world).select((node) => node.status),
    );

    return DSPressable(
      onTap: () =>
          ref.read(homeProvider.notifier).onWorldTapped(context, world),
      child: Column(
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
      ),
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

    return Semantics(
      label: context.t.home.map.stars(
        count: earned.where((star) => star).length,
      ),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: .min,
          children: [
            for (final star in earned)
              Icon(
                star ? Icons.star_rounded : Icons.star_outline_rounded,
                color: star ? DSColor.accent : DSColor.textMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

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
