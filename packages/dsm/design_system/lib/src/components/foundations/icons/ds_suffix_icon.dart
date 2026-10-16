import 'package:flutter/material.dart';

final class DSSuffixIcon extends StatelessWidget {
  final Widget _icon;
  final Function() _onPressed;

  const DSSuffixIcon({
    super.key,
    required Widget icon,
    required Function() onPressed,
  }) : _icon = icon,
       _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      color: Theme.of(context).colorScheme.outline,
      icon: _icon,
      onPressed: _onPressed,
    );
  }
}
