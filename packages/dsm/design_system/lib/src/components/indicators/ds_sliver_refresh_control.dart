import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Pull-to-refresh, the same on every screen that offers it.
///
/// The iOS control's *behaviour* — the spinner opens a gap in the overscroll
/// and the content follows the finger — drawn with the app's own circular
/// indicator rather than the tick-spinner Cupertino defaults to, so one app has
/// one spinner.
///
/// A sliver: it goes in a `CustomScrollView`'s `slivers`, above the content,
/// and the scroll view must take [physics] — without a bouncing overscroll
/// there is no gap for the spinner to appear in, and on Android the gesture
/// would never start at all.
///
/// ```dart
/// CustomScrollView(
///   physics: DSSliverRefreshControl.physics,
///   slivers: [
///     DSSliverRefreshControl(onRefresh: notifier.refresh),
///     // …content
///   ],
/// )
/// ```
final class DSSliverRefreshControl extends StatelessWidget {
  const DSSliverRefreshControl({
    required Future<void> Function() onRefresh,
    super.key,
  }) : _onRefresh = onRefresh;

  final Future<void> Function() _onRefresh;

  static const ScrollPhysics physics = _LeadingEdgeBouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  @override
  Widget build(BuildContext context) => CupertinoSliverRefreshControl(
    onRefresh: _onRefresh,
    builder: (context, mode, pulledExtent, triggerDistance, indicatorExtent) =>
        _Spinner(
          mode: mode,
          pulledExtent: pulledExtent,
          triggerDistance: triggerDistance,
        ),
  );
}

/// Fills as the pull approaches the point of no return, then turns once it is
/// past it — which is what tells someone how far is far enough.
final class _Spinner extends StatelessWidget {
  const _Spinner({
    required this.mode,
    required this.pulledExtent,
    required this.triggerDistance,
  });

  static const _size = 20.0;
  static const _stroke = 2.0;

  final RefreshIndicatorMode mode;
  final double pulledExtent;
  final double triggerDistance;

  @override
  Widget build(BuildContext context) {
    final progress = (pulledExtent / triggerDistance).clamp(0.0, 1.0);

    return Center(
      // Fades in with the pull rather than appearing at full strength on the
      // first pixel of an overscroll nobody meant.
      child: Opacity(
        opacity: progress,
        child: SizedBox(
          height: _size,
          width: _size,
          child: CircularProgressIndicator(
            strokeWidth: _stroke,
            // Determinate while it is still the reader's gesture, turning once
            // the work is ours.
            value: mode == RefreshIndicatorMode.drag ? progress : null,
          ),
        ),
      ),
    );
  }
}

/// Bouncing, but only where the bounce means something.
///
/// Flutter ships no physics that overscroll at one end: [BouncingScrollPhysics]
/// gives both, [ClampingScrollPhysics] neither. Pull-to-refresh needs the
/// leading edge to open, and nothing needs the trailing one — so this takes the
/// two boundary clauses clamping physics use for the bottom and leaves the top
/// to bouncing.
final class _LeadingEdgeBouncingScrollPhysics extends BouncingScrollPhysics {
  const _LeadingEdgeBouncingScrollPhysics({super.parent});

  @override
  _LeadingEdgeBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _LeadingEdgeBouncingScrollPhysics(parent: buildParent(ancestor));

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // Already past the bottom and still going: refuse all of it.
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }

    // This frame would cross the bottom: allow it as far as the edge.
    if (value > position.maxScrollExtent &&
        position.maxScrollExtent > position.pixels) {
      return value - position.maxScrollExtent;
    }

    // Everything else, the leading edge included, is bouncing's to answer —
    // which it does by permitting it.
    return super.applyBoundaryConditions(position, value);
  }
}
