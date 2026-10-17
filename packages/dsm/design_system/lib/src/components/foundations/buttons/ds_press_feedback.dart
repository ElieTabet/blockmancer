import 'package:flutter/widgets.dart';

/// What every [DSPressable] under it does on a tap besides its own action —
/// the app's tap sound. Read on the tap rather than in build, so a new
/// [onPress] rebuilds no button.
final class DSPressFeedback extends InheritedWidget {
  const DSPressFeedback({required super.child, this.onPress, super.key});

  final VoidCallback? onPress;

  static VoidCallback? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DSPressFeedback>()?.onPress;

  @override
  bool updateShouldNotify(DSPressFeedback oldWidget) => false;
}
