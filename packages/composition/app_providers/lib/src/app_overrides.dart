import 'package:app_providers/src/feature_bindings.dart';
import 'package:app_router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Every provider override the app's root [ProviderContainer] needs: the
/// routing slots from app_router, and everything else from this package.
List<Override> appOverrides({
  required bool collectsTelemetry,
  required AppRouter router,
}) => [
  ...routingOverrides(),
  ...featureBindingOverrides(
    collectsTelemetry: collectsTelemetry,
    router: router,
  ),
];
