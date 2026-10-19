import 'package:app_update_presentation/src/routing/app_update_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// app_update_presentation — inbound dependency-injection slots. Each throws
// until the composition layer overrides it.

/// Opens [url] outside the app, and answers whether it opened.
typedef OpenUrlFun = Future<bool> Function(String url);

/// Completes once nothing on screen is midway through something it must
/// finish first: the game's last move, played back and written.
typedef WhenSettledFun = Future<void> Function();

@Riverpod(keepAlive: true)
AppUpdateRouting appUpdateRouting(Ref ref) => throw UnimplementedError(
  'appUpdateRoutingProvider must be overridden by the composition layer (app_router)',
);

@riverpod
OpenUrlFun openUrl(Ref ref) => throw UnimplementedError(
  'openUrlProvider must be overridden by the composition layer',
);

@Riverpod(keepAlive: true)
WhenSettledFun whenGameSettled(Ref ref) => throw UnimplementedError(
  'whenGameSettledProvider must be overridden by the composition layer',
);
