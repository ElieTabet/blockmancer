import 'package:design_system/src/components/foundations/buttons/ds_press_feedback.dart';
import 'package:flutter/material.dart';

/// Makes [child] tappable, shrinking it under the finger instead of drawing an
/// ink ripple, and gives a tap the [DSPressFeedback] above it. A null [onTap]
/// disables it.
final class DSPressable extends StatefulWidget {
  const DSPressable({
    required this.child,
    required this.onTap,
    this.pressedScale = 0.95,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  /// What a screen reader announces when [child] shows no text of its own.
  final String? semanticLabel;

  @override
  State<DSPressable> createState() => _DSPressableState();
}

final class _DSPressableState extends State<DSPressable>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: _pressDuration,
    vsync: this,
  )..addStatusListener(_onStatus);
  late final _eased = _controller.drive(CurveTween(curve: Curves.easeOut));
  var _held = false;

  static const _pressDuration = Duration(milliseconds: 100);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // A quick tap reports its down and up in the same frame, so the shrink only
  // turns back once it has fully played: otherwise it would never be seen.
  void _onStatus(AnimationStatus status) {
    if (status == .completed && !_held) _controller.reverse();
  }

  void _press() {
    _held = true;
    _controller.forward();
  }

  void _release() {
    _held = false;

    if (_controller.status != .forward) _controller.reverse();
  }

  // The feedback first: the action may take this button off the screen.
  void _tap() {
    DSPressFeedback.maybeOf(context)?.call();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onTap;

    return Semantics(
      // Its own node, as Material's buttons have: without one, a lone
      // pressable lends its label and tap to the nearest ancestor's node,
      // which can be a whole tab.
      container: true,
      button: true,
      enabled: onTap != null,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: .opaque,
        onTap: onTap == null ? null : _tap,
        onTapCancel: onTap == null ? null : _release,
        onTapDown: onTap == null ? null : (_) => _press(),
        onTapUp: onTap == null ? null : (_) => _release(),
        child: ScaleTransition(
          scale: _eased.drive(Tween(begin: 1, end: widget.pressedScale)),
          child: widget.child,
        ),
      ),
    );
  }
}
