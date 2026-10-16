import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:flutter/widgets.dart';

/// Ready-made vertical gaps built from the [DSSpace] tokens, for terse spacing
/// between column children — e.g. `DSVerticalSpace.xxlarge` instead of
/// `SizedBox(height: DSSpace.xxlarge)`. Each is a `const` widget, so call sites
/// stay const.
abstract final class DSVerticalSpace {
  static const SizedBox large = SizedBox(height: DSSpace.large);

  static const SizedBox medium = SizedBox(height: DSSpace.medium);

  static const SizedBox small = SizedBox(height: DSSpace.small);

  static const SizedBox xlarge = SizedBox(height: DSSpace.xlarge);

  static const SizedBox xsmall = SizedBox(height: DSSpace.xsmall);

  static const SizedBox xxlarge = SizedBox(height: DSSpace.xxlarge);

  static const SizedBox xxsmall = SizedBox(height: DSSpace.xxsmall);

  static const SizedBox xxxlarge = SizedBox(height: DSSpace.xxxlarge);

  static const SizedBox xxxsmall = SizedBox(height: DSSpace.xxxsmall);
}
