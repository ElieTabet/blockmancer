/// The latest version whose update banner the player closed, kept on the
/// device so it shows once per version.
abstract interface class UpdateDismissals {
  Future<void> dismiss(String version);

  /// Null until a banner has been closed.
  Future<String?> dismissedVersion();
}
