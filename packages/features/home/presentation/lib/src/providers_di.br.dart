import 'package:home_presentation/src/routing/home_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// home_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// Today's daily best on this device, or null before today's first run.
@riverpod
Future<int?> dailyBest(Ref ref) => throw UnimplementedError(
  'dailyBestProvider must be overridden by the composition layer',
);

@riverpod
HomeRouting homeRouting(Ref ref) => throw UnimplementedError(
  'homeRoutingProvider must be overridden by the composition layer (app_router)',
);

/// The practice best on this device, or null before a first practice run.
@riverpod
Future<int?> practiceBest(Ref ref) => throw UnimplementedError(
  'practiceBestProvider must be overridden by the composition layer',
);
