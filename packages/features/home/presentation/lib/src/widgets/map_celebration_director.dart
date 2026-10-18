import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/entities/map_celebration.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/world_complete_sheet.dart';
import 'package:shared_domain/shared_domain.dart';

/// Plays what the map earned since it last settled — the stars, then the
/// opened world — once, when the map is on screen again, and holds the map's
/// pieces at how they stood until it starts. Reduce motion settles at once,
/// and a tap skips to the end. When the last boss standing fell, the moment
/// every world is complete follows, once the map has settled.
///
/// What the map last settled on is this state's, which lives as long as Home
/// does: a cold start shows the map as it stands, with nothing to celebrate.
final class MapCelebrationDirector extends ConsumerStatefulWidget {
  const MapCelebrationDirector({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MapCelebrationDirector> createState() =>
      _MapCelebrationDirectorState();
}

final class _MapCelebrationDirectorState
    extends ConsumerState<MapCelebrationDirector>
    with SingleTickerProviderStateMixin {
  /// What the celebration in progress ends on.
  Progression? _celebratedTo;

  /// Whether every world's completion waits to be shown.
  var _completionDue = false;
  MapCelebration? _celebration;
  late final _controller = AnimationController(vsync: this)
    ..addStatusListener((status) {
      if (status == .completed) _settle();
    });
  Progression? _latest;
  CelebrationPlan? _plan;

  /// Long enough for the route that covered the map to finish leaving.
  static const _settleDelay = Duration(milliseconds: 350);
  Progression? _shown;
  Timer? _start;
  var _still = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      progressionProvider.select((progression) => progression.value),
      (_, progression) {
        _latest = progression;
        WidgetsBinding.instance.addPostFrameCallback((_) => _consider());
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _start?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _still =
        MediaQuery.disableAnimationsOf(context) ||
        ref.watch(reduceMotionSettingProvider);
    final visible = TickerMode.valuesOf(context).enabled;

    if (_completionDue && _celebration == null && visible) {
      _completionDue = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(showWorldCompleteSheet(context));
      });
    }

    if (_celebration != null && _still) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _skip());
    } else if (_celebration != null && visible) {
      _start ??= Timer(_settleDelay, _play);
    } else {
      _start?.cancel();
      _start = null;
    }

    return MapCelebrationScope(
      celebration: _celebration,
      plan: _plan,
      timeline: _controller,
      child: Stack(
        children: [
          widget.child,
          if (_celebration != null)
            Positioned.fill(
              child: GestureDetector(behavior: .opaque, onTap: _skip),
            ),
        ],
      ),
    );
  }

  void _consider() {
    final now = _latest;
    final shown = _shown;

    if (!mounted || now == null || now == _celebratedTo) return;

    if (shown == null) {
      _shown = now;
      return;
    }

    // A change while one plays: the first ends where it was going.
    if (_celebration != null) _settle();

    final celebration = celebrationBetween(
      now,
      ref.read(worldsProvider).map((world) => world.id).toList(),
      shown: _shown!,
    );

    if (celebration.completedGame) _completionDue = true;

    if (celebration.isEmpty || _still) {
      setState(() => _shown = now);
      return;
    }

    setState(() {
      _celebration = celebration;
      _plan = .of(celebration);
      _celebratedTo = now;
    });
  }

  void _play() {
    final plan = _plan;

    if (!mounted || plan == null) return;

    _controller
      ..duration = plan.duration
      ..forward(from: 0);
  }

  void _settle() {
    if (!mounted) return;

    _start?.cancel();
    setState(() {
      _shown = _celebratedTo ?? _shown;
      _celebration = null;
      _plan = null;
      _start = null;
    });
    _controller.value = 0;
  }

  void _skip() {
    if (_celebration != null) _settle();
  }
}

/// The celebration in progress, for the trail and the nodes that take part.
final class MapCelebrationScope extends InheritedWidget {
  const MapCelebrationScope({
    required this.celebration,
    required this.plan,
    required this.timeline,
    required super.child,
    super.key,
  });

  final MapCelebration? celebration;
  final CelebrationPlan? plan;

  /// From 0, before anything plays, to 1, the map as it now stands.
  final Animation<double> timeline;

  static MapCelebrationScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MapCelebrationScope>();

  @override
  bool updateShouldNotify(MapCelebrationScope oldWidget) =>
      oldWidget.celebration != celebration;
}
