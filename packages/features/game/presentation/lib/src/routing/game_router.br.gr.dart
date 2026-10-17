// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'game_router.br.dart';

/// generated route for
/// [GamePage]
class GameRoute extends PageRouteInfo<GameRouteArgs> {
  GameRoute({
    required GameLaunch launch,
    WorldId? world,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         GameRoute.name,
         args: GameRouteArgs(launch: launch, world: world, key: key),
         initialChildren: children,
       );

  static const String name = 'GameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GameRouteArgs>();
      return GamePage(launch: args.launch, world: args.world, key: args.key);
    },
  );
}

class GameRouteArgs {
  const GameRouteArgs({required this.launch, this.world, this.key});

  final GameLaunch launch;

  final WorldId? world;

  final Key? key;

  @override
  String toString() {
    return 'GameRouteArgs{launch: $launch, world: $world, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameRouteArgs) return false;
    return launch == other.launch && world == other.world && key == other.key;
  }

  @override
  int get hashCode => launch.hashCode ^ world.hashCode ^ key.hashCode;
}
