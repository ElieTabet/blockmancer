import 'package:blockmancer_engine/src/worlds/world_rule.dart';

/// The rules with no twist, for the rounds a world's rule skips.
final class PlainRule extends WorldRule {
  const PlainRule();

  @override
  bool get bossOnly => false;
}
