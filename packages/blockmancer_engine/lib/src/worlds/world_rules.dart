import 'package:blockmancer_engine/src/worlds/fog_rule.dart';
import 'package:blockmancer_engine/src/worlds/gravity_rule.dart';
import 'package:blockmancer_engine/src/worlds/mirror_rule.dart';
import 'package:blockmancer_engine/src/worlds/plain_rule.dart';
import 'package:blockmancer_engine/src/worlds/rubble_rule.dart';
import 'package:blockmancer_engine/src/worlds/tide_rule.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:shared_domain/shared_domain.dart';

/// [world]'s rule.
WorldRule worldRule(WorldId world) => switch (world) {
  .fog => const FogRule(),
  .gravity => const GravityRule(),
  .mirror => const MirrorRule(),
  .rubble => const RubbleRule(),
  .tide => const TideRule(),
};

/// Where the engine looks up a world's rule. Only tests replace it, to
/// exercise a hook with a fake rule before any world uses it.
WorldRule Function(WorldId world) worldRuleLookup = worldRule;

/// The rule [round] plays by in a run of [config].
WorldRule ruleOfRound(RunConfig config, RoundSpec round) {
  final rule = worldRuleLookup(config.world);

  return !rule.bossOnly || round.isBoss ? rule : const PlainRule();
}
