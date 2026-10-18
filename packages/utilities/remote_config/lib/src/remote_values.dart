/// Values published remotely, each read as the text it was published as: the
/// package that owns a key parses it and decides what a bad value means.
abstract interface class RemoteValues {
  /// Fetches what is published and makes it what [valueOf] reads; never
  /// throws, so a launch with no network keeps the last values it had.
  Future<void> fetchAndActivate();

  /// The value published for [key], or null when none was.
  String? valueOf(String key);
}

/// No value published for any key: everything plays with its defaults.
final class NoRemoteValues implements RemoteValues {
  const NoRemoteValues();

  @override
  Future<void> fetchAndActivate() async {}

  @override
  String? valueOf(String key) => null;
}
