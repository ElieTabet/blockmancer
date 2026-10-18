/// What the player's consent allows, once asked where the law requires it.
typedef ConsentOutcome = ({bool canRequestAds, bool privacyOptionsRequired});

/// The consent form ads need in the EEA and the UK (Google's UMP), behind a
/// contract that names no vendor.
abstract interface class Consent {
  /// Asks the player when it is required and not yet answered, and starts the
  /// ad SDK once ads may be requested. Never throws: a failure allows no ads.
  Future<ConsentOutcome> gather();

  /// Reopens the form, so the player can change their answer. Never throws.
  Future<void> showPrivacyOptions();
}
