import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/painting/map_geometry.dart';
import 'package:home_presentation/src/painting/trail_painter.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/map_celebration_director.dart';
import 'package:home_presentation/src/widgets/world_node.dart';
import 'package:l10n_application/l10n_application.dart';

/// The worlds in the map's order down a winding trail, the first at the top.
final class WorldMap extends ConsumerWidget {
  const WorldMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The rules' worlds, which never change while the app runs: the map
    // builds once, and each node watches its own world.
    final worlds = ref.watch(worldsProvider);

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: MapGeometry.heightOf(worlds.length),
        child: MapCelebrationDirector(
          child: Stack(
            children: [
              Positioned.fill(child: WorldTrail(count: worlds.length)),
              for (final (index, world) in worlds.indexed)
                Positioned(
                  left:
                      MapGeometry.badgeCenterOf(
                        index,
                        width: constraints.maxWidth,
                      ).dx -
                      MapGeometry.nodeWidth / 2,
                  top: MapGeometry.rowHeight * index,
                  width: MapGeometry.nodeWidth,
                  child: WorldNode(world: world.id),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

final class WorldMapHeading extends StatelessWidget {
  const WorldMapHeading({super.key});

  @override
  Widget build(BuildContext context) => Text(
    context.t.home.map.title,
    style: DSFont.display(
      const TextStyle(
        color: DSColor.textMuted,
        fontSize: 18,
        fontWeight: .w600,
      ),
    ),
  );
}

/// The trail between [count] worlds, repainted only when the player walks
/// further along it, and every frame of the leg into a world just opened.
final class WorldTrail extends ConsumerWidget {
  const WorldTrail({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walked = ref.watch(trailWalkedProvider);
    final scope = MapCelebrationScope.maybeOf(context);
    final drawing = scope?.plan?.trail;

    return RepaintBoundary(
      child: drawing == null
          ? CustomPaint(
              painter: TrailPainter(count: count, walked: walked),
            )
          : AnimatedBuilder(
              animation: scope!.timeline,
              builder: (context, _) => CustomPaint(
                painter: TrailPainter(
                  count: count,
                  drawn: drawing.transform(scope.timeline.value),
                  walked: walked,
                ),
              ),
            ),
    );
  }
}
