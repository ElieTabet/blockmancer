import 'package:connectivity/src/connectivity_monitor.dart';
import 'package:connectivity/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// connectivity — public providers exposed by this package.

/// Binds the monitor slot to a concrete implementation supplied by the
/// composition layer, so nothing below composition depends on the plugin.
List<Override> bindProviders({
  required ConnectivityMonitor Function(Ref ref) connectivityMonitor,
}) => [di.connectivityMonitorProvider.overrideWith(connectivityMonitor)];
