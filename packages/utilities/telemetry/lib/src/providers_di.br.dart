import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telemetry/src/telemetry.dart';

part 'providers_di.br.g.dart';

// telemetry — inbound dependency-injection slots. Each throws until the
// composition layer (app_providers) overrides it.

/// Whether this build sends usage statistics and crash reports at all. The
/// app decides; this package only obeys.
@riverpod
bool collectsTelemetry(Ref ref) => throw UnimplementedError(
  'collectsTelemetryProvider must be overridden by the composition layer (app_providers)',
);

@Riverpod(keepAlive: true)
Telemetry telemetry(Ref ref) => throw UnimplementedError(
  'telemetryProvider must be overridden by the composition layer (app_providers)',
);
