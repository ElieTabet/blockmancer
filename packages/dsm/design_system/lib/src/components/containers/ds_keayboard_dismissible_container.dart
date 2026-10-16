import 'package:flutter/material.dart';

final class DsKeyboardDismissibleContainer extends StatelessWidget {
  // Private Properties
  final Widget _child;

  // Constructor
  const DsKeyboardDismissibleContainer({super.key, required Widget child})
    : _child = child;

  // Layout
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior
          .translucent, // allows the container to be tapped through to the underlying widget
      onTap: () => FocusScope.of(context).unfocus(),
      child: _child,
    );
  }
}
