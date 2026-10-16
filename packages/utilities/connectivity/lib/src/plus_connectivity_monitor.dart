import 'package:connectivity/src/connectivity_monitor.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// connectivity_plus behind [ConnectivityMonitor].
final class PlusConnectivityMonitor implements ConnectivityMonitor {
  final Connectivity _connectivity;

  /// [connectivity] is for tests; the composition layer writes
  /// `PlusConnectivityMonitor()` and stays free of the plugin.
  PlusConnectivityMonitor({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> isOnline() async =>
      _isOnline(await _connectivity.checkConnectivity());

  @override
  Stream<bool> onlineChanges() => _changes().distinct();

  Stream<bool> _changes() async* {
    yield await isOnline();
    yield* _connectivity.onConnectivityChanged.map(_isOnline);
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((result) => result != .none);
}
