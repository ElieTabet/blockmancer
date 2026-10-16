/// Whether the phone is attached to a network, behind a contract that names no
/// plugin.
///
/// A hint, not a promise: a captive portal or a dead access point still reads
/// as online. Callers use it to decide when to *try*, and still handle the
/// request failing.
abstract interface class ConnectivityMonitor {
  Future<bool> isOnline();

  /// The current answer first, then every change — never the same value twice
  /// in a row, so a Wi-Fi to cellular hand-over is not a reconnection.
  Stream<bool> onlineChanges();
}
