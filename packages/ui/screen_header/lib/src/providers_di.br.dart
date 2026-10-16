import 'package:result/result.dart';
// riverpod exports an AsyncResult of its own; ours is the one meant here.
import 'package:riverpod_annotation/riverpod_annotation.dart' hide AsyncResult;
import 'package:screen_header/src/routing/screen_header_routing.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// screen_header — inbound dependency-injection slots. Each throws until the
// composition layer overrides it.

/// Ends the session. Answers with an [AuthError] rather than a bare bool
/// because the header has to *render* the failure — the same reason `login`
/// takes one, and the reason the type lives in `shared_domain`.
typedef LogoutFun = AsyncUnitResult<AuthError> Function();

@riverpod
ScreenHeaderRouting screenHeaderRouting(Ref ref) => throw UnimplementedError(
  'screenHeaderRoutingProvider must be overridden by the composition layer (app_router)',
);

/// Whether a member is signed in, as opposed to a guest browsing public titles.
///
/// Watched rather than read, so the control follows the session: it re-emits on
/// a sign-in, a sign-out, and a session the server ended.
@riverpod
Future<bool> isAuthenticated(Ref ref) => throw UnimplementedError(
  'isAuthenticatedProvider must be overridden by the composition layer',
);

@riverpod
LogoutFun logout(Ref ref) => throw UnimplementedError(
  'logoutProvider must be overridden by the composition layer',
);

/// The organization's name, as the server last set it. Null until one is known,
/// and the header then has no second line.
@riverpod
String? organizationName(Ref ref) => throw UnimplementedError(
  'organizationNameProvider must be overridden by the composition layer',
);
