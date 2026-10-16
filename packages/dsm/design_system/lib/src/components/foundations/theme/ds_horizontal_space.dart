import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:flutter/widgets.dart';

/// Ready-made horizontal gaps built from the [DSSpace] tokens, for terse spacing
/// between row children — e.g. `DSHorizontalSpace.xxlarge` instead of
/// `SizedBox(width: DSSpace.xxlarge)`. Each is a `const` widget, so call sites
/// stay const.
abstract final class DSHorizontalSpace {
  static const SizedBox large = SizedBox(width: DSSpace.large);

  static const SizedBox medium = SizedBox(width: DSSpace.medium);

  static const SizedBox small = SizedBox(width: DSSpace.small);

  static const SizedBox xlarge = SizedBox(width: DSSpace.xlarge);

  static const SizedBox xsmall = SizedBox(width: DSSpace.xsmall);

  static const SizedBox xxlarge = SizedBox(width: DSSpace.xxlarge);

  static const SizedBox xxsmall = SizedBox(width: DSSpace.xxsmall);

  static const SizedBox xxxlarge = SizedBox(width: DSSpace.xxxlarge);

  static const SizedBox xxxsmall = SizedBox(width: DSSpace.xxxsmall);
}
