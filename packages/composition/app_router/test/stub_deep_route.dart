import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// A screen deep over the shell, the way an app's detail pages sit: a sibling
/// of the shell on the root stack, covering the bar. Written out by hand — what
/// auto_route would generate for a `@RoutePage` — because the template has no
/// such page of its own yet.
final class DeepRoute extends PageRouteInfo<void> {
  const DeepRoute() : super(name);

  static const name = 'DeepRoute';

  static final page = PageInfo(
    name,
    builder: (_) => const Scaffold(body: Text('Deep screen')),
  );
}

final deepRouteConfig = AutoRoute(path: '/deep', page: DeepRoute.page);
