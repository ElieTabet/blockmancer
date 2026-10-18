/// Where a purchase stands, as the store reports it.
enum PurchaseOutcome {
  /// The player backed out of the store's sheet.
  canceled,

  /// The store refused it, or something broke ([PurchaseUpdate.code] says).
  failed,

  /// Waiting on the store (a parent's approval, a slow payment).
  pending,

  purchased,

  /// Found again by a restore, or by the launch's re-check.
  restored,
}

/// One update from the store about [productId].
typedef PurchaseUpdate = ({
  String? code,
  PurchaseOutcome outcome,
  String productId,
});
