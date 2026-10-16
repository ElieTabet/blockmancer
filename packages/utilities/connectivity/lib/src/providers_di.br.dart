import 'package:connectivity/src/connectivity_monitor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// connectivity — inbound dependency-injection slot. Throws until the
// composition layer (app_providers) supplies a concrete implementation.

@Riverpod(keepAlive: true)
ConnectivityMonitor connectivityMonitor(Ref ref) => throw UnimplementedError(
  'connectivityMonitorProvider must be overridden by the composition layer (app_providers)',
);
