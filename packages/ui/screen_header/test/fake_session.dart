import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_header/screen_header.dart';
import 'package:screen_header/src/providers_di.br.dart' as di;
import 'package:shared_domain/shared_domain.dart';

final class FakeScreenHeaderRouting implements ScreenHeaderRouting {
  int signInRequests = 0;

  @override
  void onSignInRequested(BuildContext context) => signInRequests++;
}

/// Scripted sign-out. [gate], when set, holds the call open so a test can
/// observe the control mid-flight.
final class FakeLogout {
  final AuthError? failure;
  final Completer<void>? gate;
  int calls = 0;

  FakeLogout({this.failure, this.gate});

  AsyncUnitResult<AuthError> call() async {
    calls++;

    if (gate != null) await gate!.future;

    return failure != null ? Failure(failure!) : const Success(unit);
  }
}

/// The slots the header reads, which composition normally fills from `auth`
/// and `app_settings`. [signedIn] null leaves the answer outstanding — the
/// state the app is in for the first frame after a cold start.
List<Override> fakeSession({
  bool? signedIn = false,
  FakeLogout? logout,
  String? organization,
  FakeScreenHeaderRouting? routing,
}) => [
  di.isAuthenticatedProvider.overrideWith(
    (ref) =>
        signedIn == null ? Completer<bool>().future : Future.value(signedIn),
  ),
  di.logoutProvider.overrideWith((ref) => (logout ?? FakeLogout()).call),
  di.organizationNameProvider.overrideWith((ref) => organization),
  di.screenHeaderRoutingProvider.overrideWith(
    (ref) => routing ?? FakeScreenHeaderRouting(),
  ),
];
