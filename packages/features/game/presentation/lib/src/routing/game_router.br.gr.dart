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
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         GameRoute.name,
         args: GameRouteArgs(launch: launch, key: key),
         initialChildren: children,
       );

  static const String name = 'GameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GameRouteArgs>();
      return GamePage(launch: args.launch, key: args.key);
    },
  );
}

class GameRouteArgs {
  const GameRouteArgs({required this.launch, this.key});

  final GameLaunch launch;

  final Key? key;

  @override
  String toString() {
    return 'GameRouteArgs{launch: $launch, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameRouteArgs) return false;
    return launch == other.launch && key == other.key;
  }

  @override
  int get hashCode => launch.hashCode ^ key.hashCode;
}
