import 'package:design_system/src/components/containers/ds_keayboard_dismissible_container.dart';
import 'package:design_system/src/components/foundations/theme/ds_color.dart';
import 'package:design_system/src/components/foundations/theme/ds_theme.dart';
import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:flutter/material.dart';

final class DSBgContainer extends StatelessWidget {
  /// Private Properties
  final Widget _child;
  final bool _isKeyboardDismissible;
  final EdgeInsetsGeometry _padding;

  /// Constructor
  const DSBgContainer({
    required Widget child,
    bool isKeyboardDismissible = false,
    EdgeInsetsGeometry padding = const EdgeInsets.all(DSSpace.medium),
    super.key,
  }) : _child = child,
       _isKeyboardDismissible = isKeyboardDismissible,
       _padding = padding;

  /// Layout
  @override
  Widget build(BuildContext context) {
    return _isKeyboardDismissible
        ? DsKeyboardDismissibleContainer(child: _buildContent())
        : _buildContent();
  }

  Widget _buildContent() {
    // The gradient below is charcoal in every theme, so the subtree has to
    // resolve against the dark scheme even when the app is in light mode —
    // otherwise components pick light-surface roles (onSurface = charcoal,
    // primary = the dark brand colour) and render invisibly on it.
    return Theme(
      data: DSTheme.instance.darkTheme,
      child: Scaffold(
        body: Stack(
          children: [
            _buildLinearGradient(),
            _buildFirstRadialGradient(),
            _buildSecondRadialGradient(),
            Center(
              child: Padding(padding: _padding, child: _child),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinearGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [DSColor.charcoal, DSColor.charcoalLight],
        ),
      ),
    );
  }

  Widget _buildFirstRadialGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 2.0,
          center: const Alignment(0, -0.4),
          // The brand's own glow, so a new palette carries through.
          colors: [
            DSColor.primaryLight.withValues(alpha: 0.4),
            DSColor.primaryLight.withValues(alpha: 0.15),
            Colors.transparent,
          ],
          stops: [0.0, 0.3, 0.6],
        ),
      ),
    );
  }

  Widget _buildSecondRadialGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 2.0,
          center: Alignment(1.5, -0.2),
          colors: [
            Color.fromRGBO(207, 216, 220, 0.25),
            Color.fromRGBO(207, 216, 220, 0.1),
            Colors.transparent,
          ],
          stops: [0.0, 0.3, 0.6],
        ),
      ),
    );
  }
}
