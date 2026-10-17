import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/map_celebration_director.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// "You are here": a pin over [world] once the player has reached it,
/// bobbing unless motion is reduced, and fading in as a world just opened
/// pops open.
final class HereMarker extends ConsumerWidget {
  const HereMarker({required this.world, super.key});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final here = ref.watch(
      worldNodeProvider(world).select((node) => node.here),
    );

    if (!here) return const SizedBox.shrink();

    final still =
        MediaQuery.disableAnimationsOf(context) ||
        ref.watch(reduceMotionSettingProvider);
    final pin = Align(
      alignment: .bottomCenter,
      child: Icon(
        Icons.location_on_rounded,
        color: DSColor.accent,
        size: 24,
        semanticLabel: context.t.home.map.here,
      ),
    );

    final shown = still ? pin : _Bobbing(child: pin);
    final scope = MapCelebrationScope.maybeOf(context);
    final pop = scope?.celebration?.unlockedWorld == world
        ? scope?.plan?.pop
        : null;

    return pop == null
        ? shown
        : FadeTransition(
            opacity: CurvedAnimation(parent: scope!.timeline, curve: pop),
            child: shown,
          );
  }
}

final class _Bobbing extends StatefulWidget {
  const _Bobbing({required this.child});

  final Widget child;

  @override
  State<_Bobbing> createState() => _BobbingState();
}

class _BobbingState extends State<_Bobbing>
    with SingleTickerProviderStateMixin {
  static const _bob = Duration(milliseconds: 700);
  late final _controller = AnimationController(vsync: this, duration: _bob)
    ..repeat(reverse: true);
  late final _offset = _controller
      .drive(CurveTween(curve: Curves.easeInOut))
      .drive(Tween(begin: Offset.zero, end: const Offset(0, -0.2)));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Its own layer: the pin repaints every frame, the map under it never.
  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: SlideTransition(position: _offset, child: widget.child),
  );
}
