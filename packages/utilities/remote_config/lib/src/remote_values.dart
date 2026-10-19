/// Values published remotely, each read as the text it was published as: the
/// package that owns a key parses it and decides what a bad value means.
abstract interface class RemoteValues {
  /// Fires once new values may be what [valueOf] reads: after every fetch that
  /// didn't fail, and after every live update.
  Stream<void> get changes;

  /// Fetches what is published and makes it what [valueOf] reads; never
  /// throws, so a launch with no network keeps the last values it had.
  Future<void> fetchAndActivate();

  /// Takes each value published from now on as soon as it is, for the app's
  /// life; a second call does nothing.
  void listenForUpdates();

  /// The value published for [key], or null when none was.
  String? valueOf(String key);
}

/// No value published for any key: everything plays with its defaults.
final class NoRemoteValues implements RemoteValues {
  const NoRemoteValues();

  @override
  Stream<void> get changes => const Stream.empty();

  @override
  Future<void> fetchAndActivate() async {}

  @override
  void listenForUpdates() {}

  @override
  String? valueOf(String key) => null;
}
