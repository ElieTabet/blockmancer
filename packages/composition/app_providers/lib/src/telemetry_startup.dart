import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:telemetry/telemetry.dart' as telemetry;

/// The one telemetry step startup has to take, exposed here so the app shell
/// can take it without importing the package behind it.
Future<void> initializeTelemetry(ProviderContainer container) =>
    container.read(telemetry.initializeTelemetryProvider)();
