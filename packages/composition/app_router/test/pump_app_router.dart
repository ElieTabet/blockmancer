import 'package:app_router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';

import 'stub_deep_route.dart';
import 'stub_game.dart';
import 'stub_launch.dart';
import 'stub_screen_header.dart';

/// Mounts the real route tree at [deepLink], which is what these tests are
/// about: every one of them turns on where a route actually lands in the stack,
/// so a recording double would assert nothing.
Future<AppRouter> pumpAppRouter(
  WidgetTester tester, {
  required List<PageRouteInfo<dynamic>> deepLink,
}) async {
  tester.view.physicalSize = const Size(1170, 2532); // iPhone 13 Pro
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  final router = AppRouter(extraRoutes: [deepRouteConfig]);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...routingOverrides(),
        ...stubGame(),
        ...stubLaunch(),
        ...stubScreenHeader(),
      ],
      child: TranslationProvider(
        child: MaterialApp.router(
          theme: DSTheme.instance.lightTheme,
          routerConfig: router.config(
            deepLinkBuilder: (_) => DeepLink(deepLink),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return router;
}

/// The route names on the root stack, which is what the login helpers read and
/// therefore what has to be asserted.
///
/// `find.text` cannot stand in for this: it skips offstage widgets by default,
/// so a tab sitting under an opaque modal and a tab that was torn down look
/// exactly alike to it.
List<String> rootStackNames(AppRouter router) =>
    router.stackData.map((route) => route.name).toList();
