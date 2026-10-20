/// What the player's restore came to, for the player to be told.
enum RestoreOutcome {
  /// The store answered, and nothing the app sells was found.
  nothingFound,

  /// Remove ads was found again, or was already owned.
  restored,

  /// The store couldn't be reached: nothing was asked.
  storeUnreachable,
}
