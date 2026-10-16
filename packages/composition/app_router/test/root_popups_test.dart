import 'dart:async';

import 'package:app_router/app_router.dart';
import 'package:app_router/src/routing/root_popups.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splash_presentation/splash_presentation.dart' show SplashRoute;

import 'pump_app_router.dart';

// Popups raised on the app's own initiative take turns rather than stack, and
// never rise over a screen that would sweep them away.
void main() {
  testWidgets('a popup waits for the splash to hand off', (tester) async {
    final router = await pumpAppRouter(tester, deepLink: [const SplashRoute()]);
    final presented = <BuildContext>[];

    RootPopups.of(
      router,
    ).present((context) async => presented.add(context)).ignore();
    await tester.pump();

    expect(presented, isEmpty);

    await router.replaceAll([const TabShellRoute()]);
    await tester.pumpAndSettle();

    expect(presented, hasLength(1));

    // The splash's own minimum, left running when it was replaced.
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('a popup that fails does not hold up the next one', (
    tester,
  ) async {
    final router = await pumpAppRouter(
      tester,
      deepLink: [const TabShellRoute()],
    );
    final presented = <String>[];
    final popups = RootPopups.of(router);

    Object? failure;
    popups
        .present((context) async => throw StateError('broken'))
        .catchError((Object error) => failure = error)
        .ignore();
    popups.present((context) async => presented.add('next')).ignore();
    await tester.pump();
    await tester.pump();

    expect(failure, isStateError);
    expect(presented, ['next']);
  });
}
