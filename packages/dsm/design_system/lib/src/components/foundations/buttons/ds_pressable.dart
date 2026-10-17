import 'package:flutter/material.dart';

/// Makes [child] tappable, shrinking it under the finger instead of drawing an
/// ink ripple. A null [onTap] disables it.
final class DSPressable extends StatefulWidget {
  const DSPressable({
    required this.child,
    required this.onTap,
    this.pressedScale = 0.95,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

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

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onTap;

    return Semantics(
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: .opaque,
        onTap: onTap,
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
