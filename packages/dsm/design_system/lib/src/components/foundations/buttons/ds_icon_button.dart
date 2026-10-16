import 'dart:io';

import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A platform-adaptive icon button: the iOS press effect (opacity fade) via
/// [CupertinoButton] on iOS, and the Material [IconButton] (ripple) on Android
/// and other platforms — mirroring [DSButton]. Pass a null [onPressed] to
/// disable it.
///
/// [padding] defaults to a native-sized inset (`DSSpace.small` all round → a
/// ~48px tap target); pass `EdgeInsets.zero` to shrink-wrap to the icon for
/// dense inline controls.
///
/// There is no tooltip; [semanticsLabel] is what names the button to a screen
/// reader.
final class DSIconButton extends StatelessWidget {
  final Color? _color;
  final IconData _icon;
  final VoidCallback? _onPressed;
  final EdgeInsetsGeometry _padding;
  final String? _semanticsLabel;
  final double _size;

  const DSIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
    EdgeInsetsGeometry padding = const EdgeInsets.all(DSSpace.small),
    String? semanticsLabel,
    double size = 24.0,
    super.key,
  }) : _icon = icon,
       _onPressed = onPressed,
       _padding = padding,
       _semanticsLabel = semanticsLabel,
       _size = size,
       _color = color;

  @override
  Widget build(BuildContext context) {
    // Cupertino never greys a disabled child, and the explicit icon color
    // overrides Material's disabled tint — so resolve the disabled style here.
    // Dim the icon's own color rather than Theme.disabledColor, which is tuned
    // for light surfaces and disappears on a dark (charcoal) background.
    final resolved = _color ?? IconTheme.of(context).color;
    final color = _onPressed == null
        ? resolved?.withValues(alpha: 0.38)
        : resolved;

    return Semantics(
      label: _semanticsLabel,
      child: Platform.isIOS ? _buildCupertino(color) : _buildMaterial(color),
    );
  }

  Widget _buildCupertino(Color? color) => CupertinoButton(
    onPressed: _onPressed,
    padding: _padding,
    minimumSize: Size.zero,
    child: Icon(_icon, size: _size, color: color),
  );

  Widget _buildMaterial(Color? color) => IconButton(
    onPressed: _onPressed,
    padding: _padding,
    visualDensity: VisualDensity.compact,
    constraints: const BoxConstraints(),
    icon: Icon(_icon, size: _size, color: color),
  );
}
